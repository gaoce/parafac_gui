%% Test Class Definition
classdef Callbacks < matlab.unittest.TestCase
    properties
        hObject
    end
    
    methods(TestClassSetup)
        function createFigure(testCase)
            % App Graph Handle
            testCase.hObject = main();
        end
    end
    
    methods(TestClassTeardown)
        function closeFigure(testCase)
            close(testCase.hObject)
        end
    end
    
    %% Test Method Block
    methods (Test)
        
        % Test the correct running of inputExp
        function test_inputExp_Callback(testCase)      
            %% Mock uigetfile
            global FILENAME PATHNAME;
            FILENAME = {'2014-06-16 NA H2O2 5A.txt', ...
                        '2014-06-16 NA H2O2 5B.txt',...
                        '2014-06-16 NA H2O2 10A.txt',...
                        '2014-06-16 NA H2O2 10A.txt'};
            PATHNAME = './test/data/exp';
            
            %% funciton handle
            fh = @() main('inputExp_Callback', testCase.hObject, [], []);
            
            %% Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
        
        % Test the correct running of inputBg
        function test_inputBg_Callback(testCase)      
            %% Mock uigetfile
            global FILENAME PATHNAME;
            FILENAME = {'DI.txt', 'DI 2.txt'};
            PATHNAME = './test/data/bg';
            
            %% funciton handle
            fh = @() main('inputBg_Callback', testCase.hObject, [], []);
            
            %% Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
        
        % Test the correct running of plotPeak_Callback
        function test_plotPeak_Callback(testCase)      
            % Prepare graph handle
            fileNames = {'2014-06-16 NA H2O2 5A.txt', ...
                '2014-06-16 NA H2O2 5B.txt',...
                '2014-06-16 NA H2O2 10A.txt',...
                '2014-06-16 NA H2O2 10A.txt'};
            pathName = './test/data/exp';
            expEEM = buildTensor(fileNames, pathName);
            data = guidata(testCase.hObject);
            data.expEEM = expEEM;
            data.normEEM = expEEM;
            guidata(testCase.hObject, data);
            
            % Mock inputdlg
            inputdlg('expOut', {'400';'350'});
   
            % Mock inputdlg
            uigetdir('expOut', './test/results');

            %% funciton handle
            fh = @() main('plotPeak_Callback', testCase.hObject, [], []);
            
            %% Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
    end

end