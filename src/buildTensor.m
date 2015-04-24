function EEMData = buildTensor(fileNames, pathName)
% Arguments:
%   fileNames: name of input files
%   pathName: path of input files

% Returns
% A struct with the following fields:
%   X: a tensor, sample x Em x Ex
%   Ex: Ex wavelengths
%   Em: Em wavelengths
%   nEx: number of Ex
%   nEm: number of Em
%   nSample: number of samples
%   Sample: names of samples

% Num of header lines and title lines
% DATATYPE	 3 Dimensional Data            <= header line
% XYZUNITS	 Nanometer;Nanometer;Emission  <= header line
% DECIMALSYMBOL	 .                         <= header line
% X/Y	220.0	225.0	...                <= title line
nHeader = 3;

% Num of sample is number of input files
numSample = length(fileNames);

% Get Em and Ex number by reading the first file, they should have the same
% dimension, or the experiments are wrong. There is a check below
[numEm, numEx] = getNums(fileNames{1}, pathName);

% Preallocation of tensor
X = zeros(numSample, numEm, numEx);

sampleNames = cell(numSample,1);

for i = 1:numSample
    % Construct file name
    fileName = [pathName, '/', fileNames{i}];
    
    % Get sample name, namely file name excluding extension
    [~, name, ~] = fileparts(fileName);
    
    % Get data
    [mat, Em, Ex] = getIntensityMatrix(fileName, numEx);
    
    % Check if the input size does not match
    if any(size(mat) ~= [numEm, numEx])
        EEMData = 0;
        return
    end
    
    % Assign the matrix to a slice of tensor
    X(i,:,:) = mat;
    
    % Add sample name
    sampleNames{i} = name;
end

% Construct EEM obj
EEMData.X = X;
EEMData.Ex = Ex;
EEMData.Em = Em;
EEMData.nEx = numEx;
EEMData.nEm = numEm;
EEMData.nSample = numSample;
EEMData.Sample = sampleNames;

    function [numEm, numEx] = getNums(fileName, pathName)
        % Get the numbers of lines (numEm in the context of this file) and
        % columns (numEx) in the data table.
       
        fd = fopen([pathName, '/', fileName]);
        
        % Skip the header lines
        for iNotUsee = 1:nHeader
            fgetl(fd);
        end
        
        % Count the number of tabs in title line, numEx = numTab - 1 + 1
        titleLine = fgetl(fd);
        numEx = length(strfind(titleLine, sprintf('\t')));
        
        % Count the lines in the data table
        numEm = 0;
        tline = fgetl(fd);      
        % Stop in the end or if the trailing lines in the files are blank lines
        while ischar(tline) && ~isempty(tline)
            numEm = numEm + 1;
            tline = fgetl(fd);
        end
        
        fclose(fd);
    end

    function [mat, Em, Ex] = getIntensityMatrix(fileName, numEx)
        % The backstage hero: read the file and extract intensity matrix and
        % wavelengths used in the experiment
        % Arguments:
        %   fileName: name of input data
        %   numEx: number of ex wavelength
        % Returns:
        %   mat: intensity matrix
        %   Em: emission wavelengths
        %   Ex: exciation wavelengths
        
        % Open file
        fid = fopen(fileName);
        
        % Read the fourth line (because the first 3 are header lines)
        formSpec = ['%s\t', repmat('%f\t', 1, numEx)];
        C = textscan(fid, formSpec, 1, 'CollectOutput', 1, ...
            'HeaderLines', nHeader);
        Ex = C{2}(:); % Excitation wavelengths
        
        % Read the remaining lines
        formSpec = [repmat('%f\t', 1, numEx), '%f'];
        C = textscan(fid, formSpec, 'CollectOutput', 1);
        
        Em = C{1}(:,1); % Emission wavelengths
        mat = C{1}(:,2:end); % intensity matrix
        
        fclose(fid);
    end

end