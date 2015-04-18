function [Test2]=RemoveOutliers(data,OutSample,OutEm,OutEx)

%The RemoveOutlier function removes certain samples or wavelengths from the
%dataset.
%
%INPUT: [newdata]=RemoveOutliers(data,OutSample,OutEm,OutEx)
%data: identifies the data 
%OutSample: List smaples e.g. [1 5 9]  removes the first fifth and nineth
%       sample from the data set 
%OutEm: lists the emission wavlengths to be removed e.g. [1 2 3]  removes
%       the first three emission wavelengths.
%OutEx: same as OutEm just for excitation wavelengths
%
%Example
%[Test2]=RemoveOutliers(Test1,[5 25 30],[],[])

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805

%removes bad samples
Test2.X=data.X;
Test2.X(OutSample,:,:)='';

%removes bad em wavelengths
OutEmSize=size(OutEm);
if OutEmSize(1,1)==[0]
Test2.Em=data.Em;
else
    Test2.Em=data.Em;
    Test2.Em(OutEm,:)='';
    Test2.X(:,OutEm,:)='';
end

%removes bad ex wavelengths
OutExSize=size(OutEx);
if OutExSize(1,1)==[0]
Test2.Ex=data.Ex;
else
    Test2.Ex=data.Ex;
    Test2.Ex(OutEx,:)='';
    Test2.X(:,:,OutEx)='';
end
Test2.nSample=size(Test2.X,1);
Test2.nEm=size(Test2.X,2);
Test2.nEx=size(Test2.X,3);
