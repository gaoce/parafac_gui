%% Test Class Definition
classdef GuiTest < matlab.unittest.TestCase
     
    %% Test Method Block
    methods (Test)
        
        %% Test Function
        function testInputExp(testCase)      
            hObject = figure('Visible', 'off');
            
            global FILENAME;
            FILENAME = 'a';
            
            data = struct('numEm', 361, 'numEx', 47);
            guidata(hObject, data);
            
%             main('inputExp_Callback', hObject, [], []);
            
            %% Verify using test qualification
            testCase.verifyEqual(uigetfile(), 'a', 'Fail');
            
            close(hObject);
        end
    end
end