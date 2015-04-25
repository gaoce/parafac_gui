%% Test Class Definition
classdef CallbackTests < matlab.unittest.TestCase
    properties
        hObject
        guiData
    end
    
    methods(TestClassSetup)
        function createFigure(testCase)
            % App Graph Handle
            testCase.hObject = main();
        end
        
        function prepareData(testCase)
            % Import tensor
            fileNamesExp = {'2014-06-16 NA H2O2 5A.txt', ...
                '2014-06-16 NA H2O2 5B.txt',...
                '2014-06-16 NA H2O2 10A.txt',...
                '2014-06-16 NA H2O2 10A.txt'};
            pathNameExp = './test/data/exp';
            expEEM = buildTensor(fileNamesExp, pathNameExp);
            data = guidata(testCase.hObject);
            data.expEEM = expEEM;           
            
            % Background
            fileNamesBg = {'DI.txt', 'DI 2.txt'};
            pathNameBg = './test/data/bg';
            bgEEM = buildTensor(fileNamesBg, pathNameBg);
            data.bgEEM = bgEEM;
            
            % Normalize data
            data.normEEM = normEEM(expEEM, bgEEM);
            
            % Number of components
            data.numFacVal = 2;
            
            % Pftest
            data.numIterVal = 1;
            data.numMaxFacVal = 3;
            
            % Decompose
            [factsCP] = parafac(data.normEEM.X, data.numFacVal, [0 0 0 0 NaN]);
            data.factsCP = factsCP;
            
            % Update data
            testCase.guiData = data;
        end
    end
    
    methods(TestMethodSetup)
        function updateData(testCase)
            guidata(testCase.hObject, testCase.guiData);
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
            fileNames = {'2014-06-16 NA H2O2 5A.txt', ...
                        '2014-06-16 NA H2O2 5B.txt',...
                        '2014-06-16 NA H2O2 10A.txt',...
                        '2014-06-16 NA H2O2 10A.txt'};
            pathName = './test/data/exp';
            uigetfile('expOut', {fileNames, pathName});
                      
            % funciton handle
            fh = @() main('inputExp_Callback', testCase.hObject, [], []);
            
            % Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
        
        % Test the correct running of inputBg
        function test_inputBg_Callback(testCase)      
            % Mock uigetfile
            fileNames = {'DI.txt', 'DI 2.txt'};
            pathName = './test/data/bg';
            uigetfile('expOut', {fileNames, pathName});
            
            % funciton handle
            fh = @() main('inputBg_Callback', testCase.hObject, [], []);
            
            % Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
        
        % Test the correct running of normalize_Callback
        function test_normalize_Callback(testCase)
            % funciton handle
            fh = @() main('normalize_Callback', testCase.hObject, [], []);
            
            % Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
        
        % Test the correct running of plotContour_Callback
        function test_plotContour_Callback(testCase)      
            % Mock inputdlg
            uigetdir('expOut', './test/results');

            % funciton handle
            fh = @() main('plotContour_Callback', testCase.hObject, [], []);
            
            % Verify using test qualification
            testCase.verifyWarningFree(fh);
        end

        % Test the correct running of plotPeak_Callback
        function test_plotPeak_Callback(testCase)      
            % Mock inputdlg
            inputdlg('expOut', {'400';'350'});
   
            % Mock inputdlg
            uigetdir('expOut', './test/results');

            % funciton handle
            fh = @() main('plotPeak_Callback', testCase.hObject, [], []);
            
            % Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
        
        % Test the correct running of decompose_Callback
        function test_decompose_Callback(testCase)
            % funciton handle
            fh = @() main('decompose_Callback', testCase.hObject, [], []);
            
            % Verify using test qualification
            testCase.verifyWarningFree(fh);
        end      
        
        % Test the correct running of pftest_Callback
        function test_pftest_Callback(testCase)
            % funciton handle
            fh = @() main('pftest_Callback', testCase.hObject, [], []);
            
            % Verify using test qualification
            testCase.verifyWarningFree(fh);
        end
        
        % Test the correct running of plotCompContour_Callback
        function test_plotCompContour_Callback(testCase)      
            % Mock uigetdir
            uigetdir('expOut', './test/results');

            % funciton handle
            fh = @() main('plotCompContour_Callback', testCase.hObject, [], []);
            
            % Verify using test qualification
            testCase.verifyWarningFree(fh);
        end

        % Test the correct running of plotCompPeak_Callback
        function test_plotCompPeak_Callback(testCase)      
            % Mock built-in functions
            inputdlg('expOut', {'400';'350'});
            uigetdir('expOut', './test/results');

            % funciton handle
            fh = @() main('plotCompPeak_Callback', testCase.hObject, [], []);
            
            % Verify using test qualification
            testCase.verifyWarningFree(fh);
        end         
    end

end
