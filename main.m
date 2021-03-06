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

% Last Modified by GUIDE v2.5 11-Sep-2015 22:33:20

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

% Center the gui in the center of the screen
movegui(gcf,'center');

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


% --- Executes on button press in inputExp.
function inputExp_Callback(hObject, eventdata, handles)
% hObject    handle to inputExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Get last opened location
if ~isfield(data, 'lastPath')
    data.lastPath = '.';
end
lastPath = data.lastPath;

% Get experiment data
% EEM stands for ex em matrix
[fileNames, pathName, ~] = uigetfile([lastPath, '/.txt'], 'MultiSelect', 'on');

% Check file names
if ~iscell(fileNames)
    if ischar(fileNames)
        % Single file ??
        fileNames = {fileNames};
    elseif fileNames == 0
        % The user cancels the select, quit quitely
        switchComp({'inputBg', 'normalize', 'plotContour', 'plotPeak'},...
                    'off', hObject);
        return
    else
        disp('If you see these msg, please email author');
    end
end

% Update lastPath
data.lastPath = pathName;

% Constuct EEM obj from input files
expEEM = buildTensor(fileNames, pathName);

% Abort if no path is selected
if isnumeric(expEEM) && (expEEM == 0)
    waitfor(msgbox('The data cannot be imported, check the parameters'));
    % TODO there should be some existing cell array like inBtn = {'inputBg', 'inputExp'}
    switchComp({'inputBg'}, 'off');
    return
end

% Save a copy of original EEM data
data.expEEM = expEEM;

% Normalized EEM data, tentative, will be changed by normalization
data.normEEM = expEEM;

% Setup numEmVal and numExVal in data
data.numEmVal = expEEM.nEm;
data.numExVal = expEEM.nEx;

% Set a flag showing the completion of data input
data.input = 1;

% Update
guidata(hObject, data);

% Disable normalization and its flag when new data is imported
set(findobj('Tag', 'normFlag'), 'String', '');

% Enable input background and plotting
switchComp({'inputBg', 'plotContour', 'plotPeak', 'numFac'}, 'on', hObject);

% If the parameters allow, enable pftest
if checkTagNum('numIter') ~= 0 && checkTagNum('numMaxFac') ~= 0
    switchComp({'pftest'}, 'on');
end


% --- Executes on button press in inputBg.
function inputBg_Callback(hObject, eventdata, handles)
% hObject    handle to inputBg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get experiment data

% Get data
data = guidata(hObject);

% Get last opened location
if ~isfield(data, 'lastPath')
    data.lastPath = '.';
end
lastPath = data.lastPath;

% Get background file
[fileNames, pathName, ~] = uigetfile([lastPath, '/.txt'], 'MultiSelect', 'on');

% Check file names
if ~iscell(fileNames)
    if ischar(fileNames)
        % Single file ??
        fileNames = {fileNames};
    elseif fileNames == 0
        % The user cancels the select, quit quitely
        % TODO: there should be a function to do this
        switchComp({'normalize'}, 'off', hObject);
        return
    else
        disp('If you see these msg, please email author');
    end
end

% Update lastPath
data.lastPath = pathName;

% Construct EEM data
bgEEM = buildTensor(fileNames, pathName);

% Abort if no path is selected
if isnumeric(bgEEM) && (bgEEM == 0)
    waitfor(msgbox('The data cannot be imported, check the parameters'));
    switchComp({'normalize'}, 'off', hObject);
    return
end

% Assign background data
data.bgEEM = bgEEM;

% Set a flag for background data
data.bg = 1;

% Enable normalization
switchComp({'normalize'}, 'on', hObject);

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

% --- Executes on button press in plotContour.
function plotContour_Callback(hObject, eventdata, handles)
% hObject    handle to plotContour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Get last opened location
if ~isfield(data, 'lastPlotPath')
    data.lastPlotPath = '.';
end
lastPlotPath = data.lastPlotPath;

% Get path
outPath = uigetdir(lastPlotPath, 'Selection location');

% Abort if no path is selected
if outPath == 0
    waitfor(msgbox('Invalid path!'));
    return
end

% Update lastPlotPath
data.lastPlotPath = outPath;

% Plot data
fhs = plotContour(data.normEEM, 'RU', outPath);

% Get a success signal
waitfor(msgbox('Plotting completed! Close all Images?'));
close(fhs);

% Update data
guidata(hObject, data);


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
numIterVal = getNum(hObject);
if numIterVal == 0
    switchComp({'numMaxFac', 'pftest'}, 'off', hObject);
    return
else
    data.numIterVal = numIterVal;
    switchComp({'numMaxFac'}, 'on', hObject);
    if checkTagNum('numMaxFac') ~= 0 && isfield(data, 'input') && data.input == 1
        switchComp({'pftest'}, 'on', hObject);
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
numMaxFacVal = getNum(hObject);
if numMaxFacVal == 0
    switchComp({'numIter', 'pftest'}, 'off', hObject);
    return
else
    data.numMaxFacVal = numMaxFacVal;
    switchComp({'numIter'}, 'on', hObject);
    if checkTagNum('numIter') ~= 0 && isfield(data, 'input') && data.input == 1
        switchComp({'pftest'}, 'on', hObject);
    end
end

% Update
guidata(hObject, data);

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

% pftest, evalc is used to capture the screen output
evalc('pftest(data.numIterVal, data.normEEM.X, data.numMaxFacVal,[0 0 0 0 NaN])');

tHandle = gcf;
movegui(tHandle, 'center');

% Get a success signal
msg = sprintf('Test completed! Close Images?');
waitfor(msgbox(msg));
close(tHandle);


% --- Executes on button press in plotPeak.
function plotPeak_Callback(hObject, eventdata, handles)
% hObject    handle to plotPeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Get peak values
minEm = min(data.normEEM.Em);
maxEm = max(data.normEEM.Em);

minEx = min(data.normEEM.Ex);
maxEx = max(data.normEEM.Ex);

promptEm = sprintf('Peak Em [%.1f, %1.f]', minEm, maxEm);
promptEx = sprintf('Peak Ex [%.1f, %1.f]', minEx, maxEx);
prompt = {promptEm, promptEx};
dlg_title = 'Input';
num_lines = 1;

% Loop until get a statisfying result
while 1
    answer = inputdlg(prompt, dlg_title, num_lines);
    
    % The user cancled without input
    if isempty(answer)
        return
    end
    peakEm = str2double(answer{1});
    peakEx = str2double(answer{2});
    
    % check if the values are ok
    if ~isnan(peakEm) && ~isnan(peakEx) && peakEm > 0 && peakEx > 0;
        break;
    else
        waitfor(errordlg('Invalid input, must be a positive number'));
    end
end

% Get last opened location
if ~isfield(data, 'lastPlotPath')
    data.lastPlotPath = '.';
end
lastPlotPath = data.lastPlotPath;

% Get path
outPath = uigetdir(lastPlotPath, 'Selection location');

% Abort if no path is selected
if outPath == 0
    waitfor(msgbox('Invalid path!'));
    return
end

% Update lastPath
data.lastPlotPath = outPath;

% Plot data
fh = plotPeak(data.normEEM, peakEm, peakEx, outPath);

% Success
% Get a success signal
waitfor(msgbox('Plotting completed! Close all Images?'));
close(fh);

% Update
guidata(hObject, data);

% --- Executes on button press in decompose.
function decompose_Callback(hObject, eventdata, handles)
% hObject    handle to decompose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Decomposition
[~, factsCP] = evalc('parafac(data.normEEM.X, data.numFacVal, [0 0 0 0 NaN])');

% Store data
data.factsCP = factsCP;

% Set a flag to show decompose is done
data.decompose = 1;

% Update
guidata(hObject,data);

% Enable plotting
switchComp({'plotCompContour', 'plotCompPeak', 'exportData'}, ...
    'on', hObject);

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
numFacVal = getNum(hObject);
if numFacVal == 0
    switchComp({'decompose', 'plotCompContour', 'plotCompPeak'}, 'off', hObject);
    % Wrong number, must re-do the decomposition
    data.decompose = 0;
else
    data.numFacVal = numFacVal;
    switchComp({'decompose'}, 'on', hObject);
    if data.decompose == 1
        switchComp({'plotCompContour', 'plotCompPeak'}, 'on', hObject);
    end
end

% Update
guidata(hObject, data);


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


% --- Executes on button press in plotCompContour.
function plotCompContour_Callback(hObject, eventdata, handles)
% hObject    handle to plotCompContour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Alias
factsCP = data.factsCP;

% Get number of components
numComp = size(data.factsCP{1}, 2);

% Get last opened location
if ~isfield(data, 'lastPlotPath')
    data.lastPlotPath = '.';
end
lastPlotPath = data.lastPlotPath;

% Get output dir
outPath = uigetdir(lastPlotPath, 'Selection location');
if outPath == 0
    waitfor(msgbox('Invalid path!'));
    return
end

% Update lastPath
data.lastPlotPath = outPath;

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
    
    fhs = plotContour(decompEEM, 'RU', [outPath, '/', newDir]);
    uicontrol(hObject);
    
    % Get a success signal
    msg = sprintf('Comp %d plotting completed! Close all Images?', i);
    waitfor(msgbox(msg));
    close(fhs);
end

% Update
guidata(hObject, data);

% Gain focus
uicontrol(hObject);


% --- Executes on button press in plotCompPeak.
function plotCompPeak_Callback(hObject, eventdata, handles)
% hObject    handle to plotCompPeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Get peak values
minEm = min(data.normEEM.Em);
maxEm = max(data.normEEM.Em);
minEx = min(data.normEEM.Ex);
maxEx = max(data.normEEM.Ex);

promptEm = sprintf('Peak Em [%.1f, %1.f]', minEm, maxEm);
promptEx = sprintf('Peak Ex [%.1f, %1.f]', minEx, maxEx);
prompt = {promptEm, promptEx};
dlg_title = 'Input';
num_lines = 1;
while 1
    answer = inputdlg(prompt, dlg_title, num_lines);

    peakEm = str2double(answer{1});
    peakEx = str2double(answer{2});
    
    if ~isnan(peakEm) && ~isnan(peakEx) && peakEm > 0 && peakEx > 0;
        break;
    else
        waitfor(errordlg('Invalid input, must be a positive number'));
    end
end

% Alias
factsCP = data.factsCP;

% Get number of components
numComp = size(data.factsCP{1}, 2);

% Get last opened location
if ~isfield(data, 'lastPlotPath')
    data.lastPlotPath = '.';
end
lastPlotPath = data.lastPlotPath;

% Get output dir
outPath = uigetdir(lastPlotPath, 'Selection location');
if outPath == 0
    waitfor(msgbox('Invalid path!'));
    return
end

% Update lastPath
data.lastPlotPath = outPath;

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
    
    % Plot data
    fh = plotPeak(decompEEM, peakEm, peakEx, [outPath, '/', newDir]);
    
    % Get a success signal
    msg = sprintf('Comp %d plotting completed! Close all Images?', i);
    waitfor(msgbox(msg));
    close(fh);
    
    uicontrol(hObject);
end

% Update
guidata(hObject,data);

% Gain focus
uicontrol(hObject);

function call_unused()
% pftest is used in evalc, which could not be analyzed by app packaging sys.    
    pftest;
    parafac;


% --- Executes on button press in exportData.
function exportData_Callback(hObject, eventdata, handles)
% hObject    handle to exportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data
data = guidata(hObject);

% Alias
factsCP = data.factsCP;

% Get number of components
numComp = size(data.factsCP{1}, 2);

% Get last opened location
if ~isfield(data, 'lastPlotPath')
    data.lastPlotPath = '.';
end
lastPlotPath = data.lastPlotPath;

% Get output dir
outPath = uigetdir(lastPlotPath, 'Selection location');
if outPath == 0
    waitfor(msgbox('Invalid path!'));
    return
end

% Update lastPath
data.lastPlotPath = outPath;
EEM = data.expEEM;

for i = 1:numComp
    % Create dir if not exists
    newDir = ['comp', num2str(i)];
    if exist([outPath,'/', newDir], 'dir') ~= 7
        mkdir(outPath, newDir);
    end
    
    % Get tensor data
    facs = cell(1, 3);
    for j = 1:3
        facs{j} = data.factsCP{j}(:, i);
    end
    
    EEM.X = nmodel(facs);
    exportComp(EEM, [outPath,'/', newDir]);
end


uicontrol(hObject);

% Get a success signal
msg = sprintf('Data export completed!');
waitfor(msgbox(msg));

% Update
guidata(hObject, data);

% Gain focus
uicontrol(hObject);
