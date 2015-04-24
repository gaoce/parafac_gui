%% Test Class Definition
classdef Callbacks < matlab.unittest.TestCase
    properties
        hObject
    end
    
    methods(TestMethodSetup)
        function createFigure(testCase)
            % App Graph Handle
            testCase.hObject = main();
        end
    end
    
    methods(TestMethodTeardown)
        function closeFigure(testCase)
            close(testCase.hObject)
        end
    end
    
    %% Test Method Block
    methods (Test)
        
        % Test the correct running of inputExp
        function test_inputExp_Callback(testCase)      
            %% Prepare graph handle
            h = testCase.hObject;
            data = struct('numEm', 361, 'numEx', 47);
            guidata(h, data);

            %% Mock uigetfile
            global FILENAME PATHNAME;
            FILENAME = {'2014-06-16 NA H2O2 5A.txt', ...
                        '2014-06-16 NA H2O2 5B.txt'};
            PATHNAME = './data/North Attleborough';
            
            %% funciton handle
            fh = @() main('inputExp_Callback', h, [], []);
            
            %% Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
        
        % Test the correct running of inputBg
        function test_inputBg_Callback(testCase)      
            %% Prepare graph handle
            h = testCase.hObject;
            data = struct('numEm', 361, 'numEx', 47);
            guidata(h, data);

            %% Mock uigetfile
            global FILENAME PATHNAME;
            FILENAME = {'DI.txt', 'DI 2.txt'};
            PATHNAME = './data/DI';
            
            %% funciton handle
            fh = @() main('inputBg_Callback', h, [], []);
            
            %% Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
    end

end