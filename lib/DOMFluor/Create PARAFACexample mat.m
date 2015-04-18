%% Step 1. Read the data into the MATLAB workspace from "csv" (comma,
% separated values)format. This will then save the data to a MATLAB
% workspace called "PARAFACexample.mat". Three csv files are required for
% the tutorial. 1- "fl.csv", containing the fluorescence data, 2- "Ex.csv"
% containing the excitation wavelengths, and 3- "Em.csv" containing the
% emission wavelengths.


%Here you need to specify where you have saved the files
cd 'C:\Documents and Settings\cst\My Documents\iFolder\Daily work files\MATLAB\Toolboxes\DOMFluor';
%Do not edit below this line.
clear; %Clears workspace
clc;  %Clears Command Window

%Read data files in
OriginalData.Ex = csvread('Ex.csv',1); %Excitation wavelengths
OriginalData.Em = csvread('Em.csv',1); %Emission wavelengths
OriginalData.X= csvread('fl.csv',1); %Fluorescence data

OriginalData.nEx=(size(OriginalData.Ex,1)); %identifys the number of Excitation wavelengths
OriginalData.nEm=(size(OriginalData.Em,1)); %identifys the number of Emission wavelengths
OriginalData.nSample=(size(OriginalData.X,1)); OriginalData.nSample=OriginalData.nSample/OriginalData.nEm; %identifys the number of samples

%reorganises the data
OriginalData.X=(reshape(OriginalData.X',OriginalData.nEx,OriginalData.nEm,OriginalData.nSample));
OriginalData.X=permute(OriginalData.X,[3 2 1]);

%Create some error samples
OriginalData.XBackup=OriginalData.X; %Make backup copy of data without outliers 
OriginalData.X(5,:,7:9)=OriginalData.X(5,:,7:9).*1.5;
OriginalData.X(30,50:70,:)=OriginalData.X(30,50:70,:)./1.4;


%plots EEMs of the data with a 0.2s pause between plots.
for i=(1:OriginalData.nSample), pause(0.2),
contourf(OriginalData.Ex,OriginalData.Em,(reshape(OriginalData.X((i),:),OriginalData.nEm,OriginalData.nEx))), colorbar
title((i))
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
end

%deletes unwanted items from workspace
clear i;
%saves workspace
save PARAFACexample.mat;
