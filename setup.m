function setup(varargin)
% Configure path
% Change the path of he following toolboxes in case they are moved or renamed

if nargin == 0
    setupMode = 'dev';
elseif nargin == 1
    setupMode = varargin{1};
else
    error('Wrong number of inputs');
end

if strcmp(setupMode, 'test')
    addpath(fullfile(pwd, './test'));
    if ~isOn('PARAFAC_TESTING')
        % Restore original path first
        restoredefaultpath;
        setStatus('PARAFAC_TESTING');
    end
elseif strcmp(setupMode, 'dev')
    if ~isOn('PARAFAC_DEVELOPING')
        % Restore original path first
        restoredefaultpath;
        setStatus('PARAFAC_DEVELOPING');
    end
end

% DOMFLour
addpath(fullfile(pwd, './lib/DOMFluor/'));
addpath(fullfile(pwd, './lib/DOMFluor/nway/'));

% FastPeakFind
addpath(fullfile(pwd, './lib/FastPeakFind/'));

% PlotPub
addpath(fullfile(pwd, './lib/plotPub/'));

% Our code
addpath(fullfile(pwd, './src/'));

end


function on = isOn(status)
% Test dev status, used to skip lengthy restoredefaultpath process
on = exist([status, '.temp'], 'file');
end

function setStatus(status)
    delete('./*.temp');
    fclose(fopen([status, '.temp'], 'a'));
end