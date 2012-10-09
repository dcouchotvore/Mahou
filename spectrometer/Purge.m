function varargout = Purge(varargin)
% PURGE MATLAB code for Purge.fig
%      PURGE, by itself, creates a new PURGE or raises the existing
%      singleton*.
%
%      H = PURGE returns the handle to a new PURGE or the handle to
%      the existing singleton*.
%
%      PURGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PURGE.M with the given input arguments.
%
%      PURGE('Property','Value',...) creates a new PURGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Purge_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Purge_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Purge

% Last Modified by GUIDE v2.5 02-Oct-2012 10:14:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Purge_OpeningFcn, ...
                   'gui_OutputFcn',  @Purge_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before Purge is made visible.
function Purge_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Purge (see VARARGIN)

% Choose default command line output for Purge
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Purge wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Purge_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbCancel.
function pbCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
