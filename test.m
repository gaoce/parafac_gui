% clear residual objects
clear;

% Add paths, especially mock functions
setup('test');

% Construct TestSuite
import matlab.unittest.TestSuite;
fileSuite = TestSuite.fromFile('GuiTest.m'); 

% Run the test
result = run(fileSuite);
