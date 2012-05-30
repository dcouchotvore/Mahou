
function varargout = ParameterTest1(varargin)
% PARAMETERTEST1 MATLAB code for ParameterTest1.fig
%      PARAMETERTEST1, by itself, creates a new PARAMETERTEST1 or raises the existing
%      singleton*.
%
%      H = PARAMETERTEST1 returns the handle to a new PARAMETERTEST1 or the handle to
%      the existing singleton*.
%
%      PARAMETERTEST1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMETERTEST1.M with the given input arguments.
%
%      PARAMETERTEST1('Property','Value',...) creates a new PARAMETERTEST1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ParameterTest1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ParameterTest1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ParameterTest1

% Last Modified by GUIDE v2.5 24-May-2012 13:27:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ParameterTest1_OpeningFcn, ...
                   'gui_OutputFcn',  @ParameterTest1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end
% End initialization code - DO NOT EDIT

% --- Executes just before ParameterTest1 is made visible.
function ParameterTest1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ParameterTest1 (see VARARGIN)

% Choose default command line output for ParameterTest1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using ParameterTest1.
%if strcmp(get(hObject,'Visible'),'off')
%    plot(rand(5));
%end
    debug = get(handles.listbox2, 'String');
    
    global dllinfo;             %%%Could be put into handles

    files = dir('hardware/*.dll');
    count = size(files);
    for ii=1:count
        fname = files(ii).name;
        filename = ['hardware/' fname];
        [path modulename] = fileparts(filename);
        headername = ['hardware/' modulename '.h'];
        loadlibrary(filename, headername);
        calllib(modulename, 'Initialize');
        str = repmat(' ', 1, 100);                           %# allocate buffer
        pStr = libpointer('stringPtr', str);
        [namesize devicename] = calllib(modulename, 'GetDeviceName', pStr);
        dllinfo(ii).filename = modulename;
        dllinfo(ii).devicename = devicename;
        end
    devicenames = {dllinfo.devicename};
    set(handles.listbox2, 'String', devicenames, 'Value', 1);
    populate_parameters(handles);
end

function populate_parameters(handles)
    global dllinfo;
    index = get(handles.listbox2, 'Value');
    module_name = dllinfo(index).filename;
    if isfield(dllinfo(index), 'parameters')==0 || isempty(dllinfo(index).parameters)
        count = calllib(module_name, 'GetParameterCount');
        for ii=1:count
            str = repmat(' ', 1, 100);                           %# allocate buffer
            pStr = libpointer('stringPtr', str);
            [value parameter_name] = calllib(module_name, 'GetParameterData', pStr, 0, 0);
            dllinfo(index).parameters(ii).name = parameter_name;
            end
        dllinfo(index).parameter_count = count;    
        end
        
    for ii=1:dllinfo(index).parameter_count
        str = repmat(' ', 1, 100);
        pStr = libpointer('stringPtr', str);
        qStr = libpointer('stringPtr', dllinfo(index).parameters(ii).name);
        [value parameter_name parameter_data] = calllib(module_name, 'GetParameter', qStr, pStr);
        outputStr(ii).name = [dllinfo(index).parameters(ii).name ': ' parameter_data];
        end
    outputstrings = {outputStr.name};
    set(handles.text1, 'String', outputstrings);
        
    
end

% UIWAIT makes ParameterTest1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ParameterTest1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end
end

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
end
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)
end

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end;
delete(handles.figure1)
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
end
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
   
    
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)

% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
   populate_parameters(handles); 
end


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)

% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
