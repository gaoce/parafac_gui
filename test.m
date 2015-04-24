% clear residual objects
clear;

% Add paths, especially mock functions
setup('test');

% Construct TestSuite
import matlab.unittest.TestSuite;
testCases = [Callbacks];

% Run the test
result = run(testCases)