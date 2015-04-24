function setup(varargin)
% Configure path
% Change the path of he following toolboxes in case they are moved or renamed

% Restore original path first
restoredefaultpath;

if nargin == 0
    setupMode = 'norm';
elseif nargin == 1
    setupMode = varargin{1};
else
    error('Wrong number of inputs');
end

if setupMode == 'test'
    addpath(fullfile(pwd, './test'));
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
