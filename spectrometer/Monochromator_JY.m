classdef (Sealed) Monochromator_JY < handle
%this class is implemented so there can be only one instance at a time. See 
%http://www.mathworks.com/help/techdoc/matlab_oop/bru6n2g.html for details.
%Note that the way to call the class is to call JY =
%Monochromator_JY.getInstance, (instead of JY = Monochromator_JY).
    properties (SetAccess = private)
      mono; %the activexserver for JY
      initialized=0;
      hPanel;     %handle to the panel to draw controls in
      hChildren;
      handles;
      nPixelsPerArray = 32;
      zeroPixel = 16; %which pixel of the detector at lambda = 0
    end
   properties %public properties
   end

   properties (Dependent)
     wavelength;
     wavenumbers;
     wavelengthAxis;
     wavenumbersAxis;
     slit;
     turret;
     
   end
   
    %make the constructor private
    methods (Access = private)

      function obj = Monochromator_JY
        Initialize(obj);
      end
      
    end
     
    %hold the instance as a persistent variable
    methods (Static)
      function singleObj = getInstance
        persistent localObj
        if isempty(localObj) || ~isvalid(localObj)
          localObj = Monochromator_JY;
        end
        singleObj = localObj;
      end
    end
    
    methods %public
      function InitializeGui(obj,hPanel)
        obj.hPanel = hPanel; %has to come first
        obj.DrawControls; %has to come second
        obj.UpdateWavelengthWavenumbers;
        obj.UpdateSlit;
        obj.UpdateTurret;
        obj.handles = guihandles(obj.hPanel);    %last      

      end
      
      function delete(obj)
        obj.mono.CloseCommunications;
        delete(obj.mono);
        DeleteControls(obj); %remove gui elements
      end
    
      function out = get.wavelength(obj)
        if obj.initialized
          out = obj.mono.GetCurrentWavelength;
        else
          out = 3000;
        end
      end
      
      function out = get.wavenumbers(obj)
        out = 10^7/obj.mono.GetCurrentWavelength;
      end
      
      function out = get.wavelengthAxis(obj)
        dir = -1; %do increasing pixels go to higher (+1) or lower (-1) wavelength
        tur = obj.turret;
        dispersion = 0;
        switch tur
          case 0
            dispersion = 15.926; %nm/pix
          case 1
            dispersion = 10.3; %nm/pix
          case 2
            dispersion = 5.15; %nm/pix
          otherwise
            warning('turret numbering is out of bounds');
        end
        out = dir.*((1:obj.nPixelsPerArray)-obj.zeroPixel)*dispersion ...
          + obj.wavelength;
      end
      
      function out = get.wavenumbersAxis(obj);
        out = 10^7./obj.wavelengthAxis;
      end
      
      function out = get.slit(obj)
        if obj.initialized
          out = obj.mono.GetCurrentSlitWidth(0); %0 means front slit (only one installed currenlty)
        else
          out = 30;
        end
      end
      function out = get.turret(obj)
        if obj.initialized
          out = obj.mono.GetCurrentTurret;
        else
          out = 1;
        end
      end
    end
    
    methods (Access = protected) %private
        function Initialize(obj)
          
          %% START HERE
          try
            obj.mono = actxserver('JYMono.monochromator');
            obj.mono.UniqueID = 'Mono1'; %this cost me $800...
            obj.mono.Load; %
            obj.mono.OpenCommunications;
            obj.mono.Initialize;
            obj.initialized = 1;
          catch E
            warning(E.identifier, 'Monochromator');
            warning('Monochromator not found.  Enter simulation mode.');
          end
          
        end
        
        function DrawControls(obj)
          obj.hChildren = uicontrol(obj.hPanel,...
            'Style','edit',...
            'Tag','editWavelength',...
            'Callback',{@(hObject,eventdata) editWavelength_Callback(obj,hObject,eventdata)},...
            'units','normalized',...
            'Position',[0.05 0.70 0.3 0.25]... 
            );
          obj.hChildren(2) = uicontrol(obj.hPanel,...
            'Style','edit',...
            'Tag','editWavenumbers',...
            'Callback',{@(hObject,eventdata) editWavenumbers_Callback(obj,hObject,eventdata)},...
            'units','normalized',...
            'Position',[0.05 0.4 0.3 0.25]... 
            );
          obj.hChildren(3) = uicontrol(obj.hPanel,...
            'Style','edit',...
            'Tag','editSlit',...
            'Callback',{@(hObject,eventdata) editSlit_Callback(obj,hObject,eventdata)},...
            'units','normalized',...
            'Position',[0.05 0.1 0.3 0.25]... 
            );
          obj.hChildren(4) = uicontrol(obj.hPanel,...
            'Style','text',...
            'Tag','textWavelength',...
            'String','nm',...
            'HorizontalAlignment','left',...
            'units','normalized',...
            'Position',[0.355 0.7 0.2 0.25]... 
            );
          obj.hChildren(5) = uicontrol(obj.hPanel,...
            'Style','text',...
            'Tag','textWavenumbers',...
            'String','cm-1',...
            'HorizontalAlignment','left',...
            'units','normalized',...
            'Position',[0.355 0.4 0.2 0.25]... 
            );
          obj.hChildren(6) = uicontrol(obj.hPanel,...
            'Style','text',...
            'Tag','textSlit',...
            'String','mm',...
            'HorizontalAlignment','left',...
            'units','normalized',...
            'Position',[0.355 0.1 0.2 0.25]... 
            );

          %turret button group is a little more complex
          %first the group
          obj.hChildren(7) = uibuttongroup(obj.hPanel,...
            'Tag','bgTurret',...
            'BorderType','none',...
            'units','normalized',...
            'Position',[0.5 0.0 0.5 1]);
          
          %now the individual radio btns
          obj.hChildren(8) = uicontrol(obj.hChildren(7),...
            'Style','Radio',...
            'String','150 l/mm',...
            'UserData',0,...
            'units','normalized',...
            'Position',[0.1 0.1 0.8 0.25]);
          %now the individual radio btns
          obj.hChildren(9) = uicontrol(obj.hChildren(7),...
            'Style','Radio',...
            'String','75 l/mm',...
            'UserData',1,...
            'units','normalized',...
            'Position',[0.1 0.4 0.8 0.25]);
          %now the individual radio btns
          obj.hChildren(10) = uicontrol(obj.hChildren(7),...
            'Style','Radio',...
            'String','50 l/mm',...
            'UserData',2,...
            'units','normalized',...
            'Position',[0.1 0.7 0.8 0.25]);
          
          %make sure selection is off
          set(obj.hChildren(7),'SelectedObject',[]);
          
          %set selection function callback
          set(obj.hChildren(7),'SelectionChangeFcn',...
            {@(hObject,eventdata) bgTurret_Callback(obj,hObject,eventdata)})
          
          %finally update handles
          obj.handles = guihandles(obj.hPanel);
        end
        
        function DeleteControls(obj)
          delete(obj.hChildren);
        end
        
        function UpdateWavelengthWavenumbers(obj)
          wl = obj.wavelength; %read from spec
          wn = 10^7/wl; %convert to cm-1
          set(obj.handles.editWavelength,'String',sprintf('%8.2f',wl));
          set(obj.handles.editWavenumbers,'String',sprintf('%8.2f',wn));
        end
        function UpdateSlit(obj)
          set(obj.handles.editSlit,'String',sprintf('%4.1f',obj.slit));
        end
        function UpdateTurret(obj)
 %         fprintf(1,'update turret is %i\n',obj.turret);
          t = obj.turret;
          h = get(obj.handles.bgTurret,'Children');
          n = length(h);
          for i = 1:n
            udat = get(h(i),'UserData');
            if t==udat,
              set(obj.handles.bgTurret,'SelectedObject',h(i));
            end
          end
          %set(obj.handles.editSlit,'String',sprintf('%4.1f',obj.slit));
        end
          
        function out = ReadSlit(obj)
          out = str2double(get(obj.handles.editSlit,'String'));
        end
        function out = ReadWavelength(obj)
          out = str2double(get(obj.handles.editWavelength,'String'));
        end
        function out = ReadWavenumbers(obj)
          out = str2double(get(obj.handles.editWavenumbers,'String'));
        end
        function out = ReadTurret(obj)
          %warning('SGRLAB:NotImplementedYet','read turret is not implemented yet');
          %out = str2double(get(obj.handles.editWavelength,'String'));
          out = get(get(obj.handles.bgTurret,'SelectedObject'),'UserData');
        end

    end
    methods (Access = public)
        function editWavelength_Callback(obj,hObject, eventdata)
          new = ReadWavelength(obj);
          %TODO add error checking here
          obj.mono.MovetoWavelength(new)
          while obj.mono.IsBusy
            drawnow
            obj.UpdateWavelengthWavenumbers;
          end
          obj.UpdateWavelengthWavenumbers;

        end
        function editWavenumbers_Callback(obj,hObject, eventdata)
         new = ReadWavenumbers(obj);
         new = 10^7/new;
          %TODO add error checking here
          obj.mono.MovetoWavelength(new)
          while obj.mono.IsBusy
            drawnow
            obj.UpdateWavelengthWavenumbers;
          end
          obj.UpdateWavelengthWavenumbers;
        end
        function editSlit_Callback(obj,hObject, eventdata)
          newslit = ReadSlit(obj);
          %TODO add error checking here with IsTargetWithinLimits()
          obj.mono.MovetoSlitWidth(0,newslit);
          while obj.mono.IsBusy
            drawnow
            obj.UpdateSlit;
          end
          obj.UpdateSlit;
        end
        function bgTurret_Callback(obj,hObject, eventdata)
          val = ReadTurret(obj);
%          fprintf(1,'callback turret is %i\n',val);
          obj.mono.MovetoTurret(val);
          while obj.mono.IsBusy
            drawnow
          end
          obj.UpdateTurret; %shouldn't change anything...
        end
    end
end
