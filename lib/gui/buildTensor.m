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
    [~,name,~] = fileparts(fileName);
    
    % Get data
    [mat, Ex, Em] = getMat(fileName);
    
    X(i,:,:) = mat;
    Sample{i} = name;
end

EEMData.X = X;
EEMData.Ex = Ex;
EEMData.Em = Em;
EEMData.nEx = numEx;
EEMData.nEm = numEm;
EEMData.nSample = numSample;
EEMData.Sample = Sample;

end


function [mat, Ex, Em] = getMat(fileName)

% Open file
fid = fopen(fileName);

formSpec = ['%s\t', repmat('%f\t', 1, 47)];
C = textscan(fid, formSpec, 1, 'CollectOutput', 1, 'HeaderLines', 3);
Ex = C{2}(:);

formSpec = [repmat('%f\t', 1, 47), '%f'];
C = textscan(fid, formSpec, 'CollectOutput', 1);

Em = C{1}(:,1);
mat = C{1}(:,2:end);

fclose(fid);

end