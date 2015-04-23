clear;
setup('test');

import matlab.unittest.TestSuite;

fileSuite = TestSuite.fromFile('GuiTest.m'); 

result = run(fileSuite);
