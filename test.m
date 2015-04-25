% clear residual objects
clear;

% Add paths, especially mock functions
setup('test');

% Add results folder to test
if ~exist('test/results', 'dir')
    mkdir('test/results');
end

% Construct TestSuite
import matlab.unittest.TestSuite;
testCases = [CallbackTests];

% Run the test
result = run(testCases)