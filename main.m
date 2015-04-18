function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 17-Apr-2015 21:55:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

%% Configure path ==============================================================
% Developer only: change the path of he following toolboxes in case they
% are relocated or renamed

% DOMFLour
addpath('./lib/DOMFluor/');
addpath('./lib/DOMFluor/nway/');

% export_fig 
addpath('./lib/export_fig/');

% FastPeakFind
addpath('./lib/FastPeakFind/');

% RotateXLabels
addpath('./lib/rotateXLabels/');

% Our code
addpath('./lib/gui/');
% ==============================================================================


%% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in input_exp.
function input_exp_Callback(hObject, eventdata, handles)
% hObject    handle to input_exp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Get numEx, numEm
numEx = data.numEx;
numEm = data.numEm;


% Get experiment data
[fileNames,pathName,~] = uigetfile('.txt', 'MultiSelect', 'on');
expEEM = buildTensor(fileNames, pathName, numEm, numEx);

% Save a copy of original EEM data
data.expEEM = expEEM;

% Normalized EEM data, tentative, will be changed by normalization
data.normEEM = expEEM;

% Set a flag showing the completion of data input
data.input = 1;

% Update
guidata(hObject, data);

% Disable normalization and its flag when new data is imported
set(findobj('Tag', 'normFlag'), 'String', '');
% if no background data is available
% if data.bg ~= 1
%     set(findobj('Tag', 'normalize'), 'Enable', 'off');
% end

% Enable input background and plotting
set(findobj('Tag', 'input_bg'), 'Enable', 'on');
set(findobj('Tag', 'plot_contour'), 'Enable', 'on');
set(findobj('Tag', 'plot_intensity'), 'Enable', 'on');

% If the parameters allow, enable pftest
if checkTagNum('numIter') ~= 0 && checkTagNum('numMaxFac') ~= 0
    set(findobj('Tag', 'pftest'), 'Enable', 'on');
end
set(findobj('Tag', 'numFac'), 'Enable', 'on');

% --- Executes on button press in input_bg.
function input_bg_Callback(hObject, eventdata, handles)
% hObject    handle to input_bg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get experiment data

% Get data
data = guidata(hObject);

% TODO
% Get numEx, numEm
% numEx = data.numEx;
% numEm = data.numEm;
numEx = 47;
numEm = 361;

% Get background file
[fileNames,pathName,~] = uigetfile('.txt', 'MultiSelect', 'on');
bgEEM = buildTensor(fileNames, pathName, numEm, numEx);

% Save a copy of original EEM data
data.bgEEM = bgEEM;

% Set a flag for background data
data.bg = 1;

% Enable normalization
set(findobj('Tag', 'normalize'), 'Enable', 'on');

% New background data, no longer normalized
set(findobj('Tag', 'normFlag'), 'String', '');

% Update
guidata(hObject, data);


% --- Executes on button press in normalize.
function normalize_Callback(hObject, eventdata, handles)
% hObject    handle to normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);
% Normalize data
data.normEEM = normEEM(data.expEEM, data.bgEEM);

% Set normalization flag
set(findobj('Tag', 'normFlag'), 'String', 'Data Normalized!');

% Update
guidata(hObject,data);

% --- Executes on button press in plot_contour.
function plot_contour_Callback(hObject, eventdata, handles)
% hObject    handle to plot_contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Get path
outPath = uigetdir();

% TODO
% check if outPath is NA

% Plot data
plotContour(data.normEEM, 'RU', outPath);

msgbox('Plotting completed!');



function numEx_Callback(hObject, eventdata, handles)
% hObject    handle to numEx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numEx as text
%        str2double(get(hObject,'String')) returns contents of numEx as a double

% Get data
data = guidata(hObject);

% Store the data
numEx = getNum(hObject);
if numEx == 0
    set(findobj('Tag', 'numEm'), 'Enable', 'off');
    set(findobj('Tag', 'input_exp'), 'Enable', 'off');
    set(findobj('Tag', 'input_bg'), 'Enable', 'off');
    return
else
    data.numEx = numEx;
    set(findobj('Tag', 'numEm'), 'Enable', 'on');
    if checkTagNum('numEm') ~= 0
        set(findobj('Tag', 'input_exp'), 'Enable', 'on');
        set(findobj('Tag', 'input_bg'), 'Enable', 'on');
    end
end

% Update
guidata(hObject,data);


% --- Executes during object creation, after setting all properties.
function numEx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numEx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numEm_Callback(hObject, eventdata, handles)
% hObject    handle to numEm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numEm as text
%        str2double(get(hObject,'String')) returns contents of numEm as a double

% Get data
data = guidata(hObject);

% Store the data
numEm = getNum(hObject);
if numEm == 0
    set(findobj('Tag', 'numEx'), 'Enable', 'off');
    set(findobj('Tag', 'input_exp'), 'Enable', 'off');
    set(findobj('Tag', 'input_bg'), 'Enable', 'off');
    return
else
    data.numEm = numEm;
    set(findobj('Tag', 'numEx'), 'Enable', 'on');
    if checkTagNum('numEx') ~= 0
        set(findobj('Tag', 'input_exp'), 'Enable', 'on');
        set(findobj('Tag', 'input_bg'), 'Enable', 'on');
    end
end

% Update
guidata(hObject,data);


% --- Executes during object creation, after setting all properties.
function numEm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numEm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Helper function ---
function n = getNum(hObject)
% Get the number from edit box and check its validity

% Get number of excitation wavelengths
n = str2double(get(hObject,'String'));

% Determine if numEx is NaN or non-interger
if isnan(n) || ~isequal(fix(n), n) || n <= 0
    errordlg('You must enter an positive integer', 'Invalid Input', 'modal');
    set(hObject,'String', '')
    n = 0;
    return
end

function n = checkTagNum(tag)
% Get the number from edit box and check its validity

% Get number of excitation wavelengths
hObject = findobj('Tag', tag);
n = str2double(get(hObject, 'String'));

% Determine if n is NaN or non-interger or  <=0
if isnan(n) || ~isequal(fix(n), n) || n <= 0
    n = 0;
    return
end


function numIter_Callback(hObject, eventdata, handles)
% hObject    handle to numIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numIter as text
%        str2double(get(hObject,'String')) returns contents of numIter as a double

% Get data
data = guidata(hObject);

% Store the data
numIter = getNum(hObject);
if numIter == 0
    set(findobj('Tag', 'numFacMax'), 'Enable', 'off');
    set(findobj('Tag', 'pftest'), 'Enable', 'off');
    return
else
    data.numIter = numIter;
    set(findobj('Tag', 'numMaxFac'), 'Enable', 'on');
    if checkTagNum('numMaxFac') ~= 0 && isfield(data, 'input') && data.input == 1
        set(findobj('Tag', 'pftest'), 'Enable', 'on');
    end
end
% Update
guidata(hObject, data);

% --- Executes during object creation, after setting all properties.
function numIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numMaxFac_Callback(hObject, eventdata, handles)
% hObject    handle to numMaxFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numMaxFac as text
%        str2double(get(hObject,'String')) returns contents of numMaxFac as a double

% Get data
data = guidata(hObject);

% Store the data
numMaxFac = getNum(hObject);
if numMaxFac == 0
    set(findobj('Tag', 'numIter'), 'Enable', 'off');
    set(findobj('Tag', 'pftest'), 'Enable', 'off');
    return
else
    data.numMaxFac = numMaxFac;
    set(findobj('Tag', 'numIter'), 'Enable', 'on');
    if checkTagNum('numIter') ~= 0 && isfield(data, 'input') && data.input == 1
        set(findobj('Tag', 'pftest'), 'Enable', 'on');
    end
end
% Update
guidata(hObject,data);

% --- Executes during object creation, after setting all properties.
function numMaxFac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numMaxFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pftest.
function pftest_Callback(hObject, eventdata, handles)
% hObject    handle to pftest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% pftest
[ssX,Corco,It] = pftest(data.numIter, data.normEEM.X, data.numMaxFac, ...
    [0 0 0 0 NaN]);


% --- Executes on button press in plot_intensity.
function plot_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to plot_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Get path
outPath = uigetdir();

% Plot data
plotIntensity(data.normEEM, outPath);

msgbox('Plotting completed!');


% --- Executes on button press in decompose.
function decompose_Callback(hObject, eventdata, handles)
% hObject    handle to decompose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Decomposition
[factsCP] = parafac(data.normEEM.X, data.numFac, [0 0 0 0 NaN]);

% Store data
data.factsCP = factsCP;

% Set a flag to show decompose is done
data.decompose = 1;

% Update
guidata(hObject,data);

% Enable plotting
set(findobj('Tag', 'plot_comp_contour'), 'Enable', 'on');
set(findobj('Tag', 'plot_comp_intensity'), 'Enable', 'on');

msgbox('Decomposition completed!');



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numFac_Callback(hObject, eventdata, handles)
% hObject    handle to numFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numFac as text
%        str2double(get(hObject,'String')) returns contents of numFac as a double

% Get data
data = guidata(hObject);

% Store the data
numFac = getNum(hObject);
if numFac == 0
    set(findobj('Tag', 'decompose'), 'Enable', 'off');
    set(findobj('Tag', 'plot_comp_contour'), 'Enable', 'off');
    set(findobj('Tag', 'plot_comp_intensity'), 'Enable', 'off');
    % Wrong number, must re-do the decomposition
    data.decompose = 0;
else
    data.numFac = numFac;    
    set(findobj('Tag', 'decompose'), 'Enable', 'on');
    if data.decompose == 1
        set(findobj('Tag', 'plot_comp_contour'), 'Enable', 'on');
        set(findobj('Tag', 'plot_comp_intensity'), 'Enable', 'on');
    end
end

% Update
guidata(hObject,data);


% --- Executes during object creation, after setting all properties.
function numFac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_comp_contour.
function plot_comp_contour_Callback(hObject, eventdata, handles)
% hObject    handle to plot_comp_contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Alias
factsCP = data.factsCP;

% Get number of components
numComp = size(data.factsCP{1}, 2);

% Get output dir
outPath = uigetdir();
if outPath == 0
    waitfor(msgbox(['Invalid path!']));
    return
end

for i = 1:numComp
    % Create dir if not exists
    newDir = ['comp', num2str(i)];
    if exist([outPath,'/', newDir], 'dir') ~= 7
        mkdir(outPath, newDir);
    end
    
    decompName = ['decompEEM', num2str(i)];
    if isfield(data, decompName)
        decompEEM = data.(decompName);
    else
        decompEEM = data.normEEM;
        decompEEM.X = nmodel({factsCP{1}(:,i),factsCP{2}(:,i),factsCP{3}(:,i)});
        data.(decompName) = decompEEM;        
    end
    
    plotContour(decompEEM, 'RU', [outPath, '/', newDir]);
    uicontrol(hObject);
end

% Update
guidata(hObject,data);

% Gain focus
uicontrol(hObject);
msgbox('Plotting completed!');

% --- Executes on button press in plot_comp_intensity.
function plot_comp_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to plot_comp_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get data
data = guidata(hObject);

% Alias
factsCP = data.factsCP;

% Get number of components
numComp = size(data.factsCP{1}, 2);

% Get output dir
outPath = uigetdir();
if outPath == 0
    waitfor(msgbox(['Invalid path!']));
    return
end

for i = 1:numComp
    newDir = ['comp', num2str(i)];
    if exist([outPath,'/', newDir], 'dir') ~= 7
        mkdir(outPath, newDir);
    end
    decompName = ['decompEEM', num2str(i)];
    if isfield(data, decompName)
        decompEEM = data.(decompName);
    else
        decompEEM = data.normEEM;
        decompEEM.X = nmodel({factsCP{1}(:,i),factsCP{2}(:,i),factsCP{3}(:,i)});
        data.(decompName) = decompEEM;        
    end
    plotIntensity(decompEEM, [outPath, '/', newDir]);
    uicontrol(hObject);
end

% Update
guidata(hObject,data);

% Gain focus
uicontrol(hObject);
msgbox('Plotting completed!');
