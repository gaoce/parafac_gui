function EEMData = buildTensor(fileNames, pathName, numEm, numEx)
% Arguments:
%   fileNames: name of input files
%   pathName: path of input files
%   numEx: number of excitation wavelengths
%   numEm: number of emission wavelengths

% Returns
% A struct with the following fields:
%   X: a tensor, sample x Em x Ex
%   Ex: Ex wavelengths
%   Em: Em wavelengths
%   nEx: number of Ex
%   nEm: number of Em
%   nSample: number of samples
%   Sample: names of samples

% Num of sample is number of input files
numSample = length(fileNames);

% Preallocation of tensor
X = zeros(numSample, numEm, numEx);

Sample = cell(numSample,1);

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
    Sample{i} = name;
end

% Construct EEM obj
EEMData.X = X;
EEMData.Ex = Ex;
EEMData.Em = Em;
EEMData.nEx = numEx;
EEMData.nEm = numEm;
EEMData.nSample = numSample;
EEMData.Sample = Sample;

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
C = textscan(fid, formSpec, 1, 'CollectOutput', 1, 'HeaderLines', 3);
Ex = C{2}(:); % Excitation wavelengths

% Read the remaining lines
formSpec = [repmat('%f\t', 1, numEx), '%f'];
C = textscan(fid, formSpec, 'CollectOutput', 1);

Em = C{1}(:,1); % Emission wavelengths
mat = C{1}(:,2:end); % intensity matrix

fclose(fid);
end