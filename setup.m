function setup(varargin)
% Configure path
% Change the path of he following toolboxes in case they are moved or renamed

if nargin == 0
    setupMode = 'norm';
elseif nargin == 1
    setupMode = varargin{1};
else
    error('Wrong number of inputs');
end

if setupMode == 'test'
    addpath('./test');
end

% DOMFLour
addpath('./lib/DOMFluor/');
addpath('./lib/DOMFluor/nway/');

% FastPeakFind
addpath('./lib/FastPeakFind/');

% PlotPub
addpath('./lib/plotPub/');

% Our code
addpath('./src/');

end
