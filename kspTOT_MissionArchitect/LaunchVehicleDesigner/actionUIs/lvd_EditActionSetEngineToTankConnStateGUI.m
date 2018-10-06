function varargout = lvd_EditActionSetEngineToTankConnStateGUI(varargin)
% LVD_EDITACTIONSETENGINETOTANKCONNSTATEGUI MATLAB code for lvd_EditActionSetEngineToTankConnStateGUI.fig
%      LVD_EDITACTIONSETENGINETOTANKCONNSTATEGUI, by itself, creates a new LVD_EDITACTIONSETENGINETOTANKCONNSTATEGUI or raises the existing
%      singleton*.
%
%      H = LVD_EDITACTIONSETENGINETOTANKCONNSTATEGUI returns the handle to a new LVD_EDITACTIONSETENGINETOTANKCONNSTATEGUI or the handle to
%      the existing singleton*.
%
%      LVD_EDITACTIONSETENGINETOTANKCONNSTATEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LVD_EDITACTIONSETENGINETOTANKCONNSTATEGUI.M with the given input arguments.
%
%      LVD_EDITACTIONSETENGINETOTANKCONNSTATEGUI('Property','Value',...) creates a new LVD_EDITACTIONSETENGINETOTANKCONNSTATEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lvd_EditActionSetEngineToTankConnStateGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lvd_EditActionSetEngineToTankConnStateGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lvd_EditActionSetEngineToTankConnStateGUI

% Last Modified by GUIDE v2.5 17-Sep-2018 18:49:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lvd_EditActionSetEngineToTankConnStateGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @lvd_EditActionSetEngineToTankConnStateGUI_OutputFcn, ...
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


% --- Executes just before lvd_EditActionSetEngineToTankConnStateGUI is made visible.
function lvd_EditActionSetEngineToTankConnStateGUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to lvd_EditActionSetEngineToTankConnStateGUI (see VARARGIN)

    % Choose default command line output for lvd_EditActionSetEngineToTankConnStateGUI
    handles.output = hObject;

    action = varargin{1};
    setappdata(hObject,'action',action);
    
    lv = varargin{2};
    setappdata(hObject,'lv',lv);
    
    populateGUI(handles, action, lv);

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes lvd_EditActionSetEngineToTankConnStateGUI wait for user response (see UIRESUME)
    uiwait(handles.lvd_EditActionSetEngineToTankConnStateGUI);

    
function populateGUI(handles, action, lv)
    [e2TConnStr, e2TConns] = lv.getEngineToTankConnectionsListBoxStr();
    set(handles.refConnCombo,'String',e2TConnStr);
    
    if(not(isempty(action.conn)))
        ind = find(e2TConns == action.conn,1,'first');
    else
        ind = [];
    end
    
    if(not(isempty(ind)))
        set(handles.refConnCombo,'Value',ind);
    end
    
    if(action.activeStateToSet)
        set(handles.stateCombo,'Value',1);
    else
        set(handles.stateCombo,'Value',2);
    end

% --- Outputs from this function are returned to the command line.
function varargout = lvd_EditActionSetEngineToTankConnStateGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    if(isempty(handles))
        varargout{1} = false;
    else  
        action = getappdata(hObject,'action');
        lv = getappdata(hObject,'lv');
        
        [~, e2TConns] = lv.getEngineToTankConnectionsListBoxStr();
        ind = get(handles.refConnCombo,'Value');
        action.conn = e2TConns(ind);
        
        contents = cellstr(get(handles.stateCombo,'String'));
        stateStr = contents{get(handles.stateCombo,'Value')};
        
        switch stateStr
            case 'Active'
                state = true;
            case 'Inactive'
                state = false;
            otherwise 
                error('Invalid state string: %s', stateStr);
        end
        
        action.activeStateToSet = state;
        
        varargout{1} = true;
        close(handles.lvd_EditActionSetEngineToTankConnStateGUI);
    end


% --- Executes on button press in saveAndCloseButton.
function saveAndCloseButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveAndCloseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)   
    uiresume(handles.lvd_EditActionSetEngineToTankConnStateGUI);


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close(handles.lvd_EditActionSetEngineToTankConnStateGUI);

% --- Executes on selection change in refConnCombo.
function refConnCombo_Callback(hObject, eventdata, handles)
% hObject    handle to refConnCombo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns refConnCombo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from refConnCombo


% --- Executes during object creation, after setting all properties.
function refConnCombo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refConnCombo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in stateCombo.
function stateCombo_Callback(hObject, eventdata, handles)
% hObject    handle to stateCombo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stateCombo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stateCombo


% --- Executes during object creation, after setting all properties.
function stateCombo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stateCombo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
