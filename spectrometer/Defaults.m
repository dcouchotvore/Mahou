classdef Defaults < handle
%Defaults Save and load public properties of classes as default values.
%
% Defaults are stored in the same folder as the Defaults.m file. They are
% saved as structures in those files with file names and variable names
% given by the 'Tag' property of the class.
% 
% Typical use would be:
%
% c = SomeClass(someoptions);
% d = Defaults(c); %this defines the defaults class for instance c.
% d.LoadDefaults; %this loads all the default public properties into instance c.
% d.LoadDefaults('prop'); %loads only c.prop
% d.SaveDefaults; %saves all the current values of the public properties into the defaults file
% d.SaveDefaults('prop'); %saves only the current value of c.prop to the
%     %defaults file and leaves the other values unchanged.
%
%Note: this Defaults class requires only that the class c have some public
%properites as listed by the properties function (ie at least
%GetAccess=public and Hidden =false) AND has a property Tag which is
%Hidden. I recommend defining Tag as
%
% properties(Hidden,SetAccess = immutable)
%   Tag;
% end
%
%this way Tag is available to the Defaults by name, but the Tag will not be
%written to the file, and the Tag cannot be changed after the object is
%instantiated.
%
  properties (SetAccess = private)
    filename; %the name of the defaults file for the active class
    varname; %the name of the variable in the file that hold the default values
    values; %the struct that will be saved
    inputClass; %the class we are operating on
    validated=0; %turns off function if there is an error
  end
  
  methods
    function obj = Defaults(inputClass)
      %add error checking on input?
      %make sure it is a class
      %make sure it has a Tag
      
      obj.inputClass = inputClass;
      
      [obj.filename, obj.varname] = DefaultsFileName(obj);
      
    end
        
    function LoadDefaults(obj,varargin)
      %read defaults (includes validation)
      ReadDefaults(obj);
      
      if isempty(varargin)
        %we will load all defaults
        names = fieldnames(obj.values);
      else
        if iscell(varargin{1})
          names = varargin{1};
        else
          %if the first input is not a cell, assume they will all be
          %strings
          names = varargin;
        end
      end
      
      %assign specified values to the input class
      n = length(names);
      for ii = 1:n
        name = names{ii};
        if isfield(obj.values,name) && ~isempty(obj.values.(name))
          %if the field exists (ie input name is valid) and the value is
          %not empty then make the assignment
          obj.inputClass.(name) = obj.values.(name);
        else
          warning('SGRLAB:BadDefaultField','not valid property name %s or value is empty (not saved in file)',name);
        end
        
      end
      
    end
    
    function SaveDefaults(obj,varargin)
      %read defaults (icludes validation)
      ReadDefaults(obj);
      
      %assign values to values from inputClass
      if isempty(varargin)
        %we will load all defaults
        names = fieldnames(obj.values);
      else
        if iscell(varargin{1})
          names = varargin{1};
        else
          %if the first input is not a cell, assume they will all be
          %strings
          names = varargin;
        end
      end
      
      %assign specified values to the input class
      n = length(names);
      for ii = 1:n
        name = names{ii};
        if isfield(obj.values,name)
          obj.values.(name) = obj.inputClass.(name);
        else
          warning('SGRLAB:BadDefaultField','not valid property name %s. Doing nothing.',name);
        end
      end
      
      %save back to the file:
      %this is a little tricky. We want to save the information in s as
      %a variable with the name obj.Tag (Motor1 for example). So we
      %make a field of a structure with the name obj.varname and the value
      %s. Then the save command we use with the '-struct' option, which
      %takes all the fields of a struct and saves them to variables
      %with the same names in a mat file. The append option means we
      %will add new variables to the mat file and replace existing ones
      %but leave other variables unchanged.
      saveStruct = struct(obj.varname,obj.values);
      if exist(obj.filename,'file')==2
        save(obj.filename,'-struct','saveStruct',obj.varname,'-append');
      else
        save(obj.filename,'-struct','saveStruct',obj.varname);
      end
     
    end
    
     
  end
  
  methods (Access = private)
    
    function [filename, varname] = DefaultsFileName(obj)
      %build the file name of the defaults file
      fullNameAndPath = mfilename('fullpath'); %name of this m-file
      [pathpart,~,~]=fileparts(fullNameAndPath);%we want path
      filename = [pathpart filesep 'defaults_' obj.inputClass.Tag '.mat'];
      %filename = [pathpart filesep 'defaults.mat'];
      
      varname = obj.inputClass.Tag;
    end
    
    function ReadDefaults(obj)
      %if file missing use empty defaults
      s = EmptyDefaults(obj);
 
      %input struct from file
      %try to load file
      if ~(exist(obj.filename,'file')==2)
        %if can't find it use empty
        warning('SGRLAB:DefaultsMissing',...
          ['Cannot find defaults file %s'...
          'on search path. Using empty defaults.'],obj.filename);
        obj.values = s;
        return; %return empty emp
      end
      
      %load file
      tmp = load(obj.filename);
      
          %if the structure with the name obj.Tag exists return it
          %otherwise the empty struct will be returned
          if isfield(tmp,obj.varname)
            s = tmp.(obj.varname);
          end
      
      %validate it
      s = ValidateDefaults(obj,s);
      

      %save it as values
      obj.values = s;
 
    end
    
    function s = ValidateDefaults(obj,old)
      %compare fields of values to properties of class
      new = EmptyDefaults(obj);
      
      %this is tricky because you have to look both ways. Probably could be
      %optimized.
      %look for extra fields: 
      %loop through fields of old (from disk)
      names = fieldnames(old);
      n = length(names);
      for ii = 1:n
        name = names(ii);
        if ~isfield(new,name)
          %if the property isn't used any more then delete it
          old = rmfield(old,name);
        end
      end
      
      %look for missing fields: 
      %loop through fields of old (from disk)
      names = fieldnames(new);
      n = length(names);
      for ii = 1:n
        name = names(ii);
        if ~isfield(new,name)
          %if the property isn't present then add it empty
          old.(name) = [];
        end
      end
      
      s = old;  
      obj.validated = 1;
    end
 
    function s = EmptyDefaults(obj)
      %warning('off','MATLAB:structOnObject');
      %s = struct(obj);
      names = properties(obj.inputClass); %public properties only
      vals = cell(1,length(names)); %empty cell array
      s = cell2struct(vals,names,2);
    end

  end
  
end