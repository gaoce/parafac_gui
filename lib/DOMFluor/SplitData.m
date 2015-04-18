function [AnalysisData]=SplitData(data)

% The SplitData function splits the data into halves in preperation for the
% Split Half Analysis.
%The data is split in to two halves, twice to allow for two comparisons 
%to be made. So a total of four halves are made (1,2,3,4), for 
%two comparisons 1-2 and 3-4.
%
%INPUT: [AnalysisData]=SplitData(data)
%data: indicate the location of the data to use (e.g. this could be Test2,
%       where the outliers have been found and removed). 
%       The data are placed into the "AnalysisData" structure.
%
%Example
%	[AnalysisData]=SplitData(Test2)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


%Create analysis data set

AnalysisData.X=data.X;
AnalysisData.Ex=data.Ex;
AnalysisData.Em=data.Em;
AnalysisData.nEx=data.nEx;
AnalysisData.nEm=data.nEm;
AnalysisData.nSample=data.nSample;

temp1=AnalysisData.X(1:4:(AnalysisData.nSample),:,:);
temp2=AnalysisData.X(2:4:(AnalysisData.nSample),:,:);
temp3=AnalysisData.X(3:4:(AnalysisData.nSample),:,:);
temp4=AnalysisData.X(4:4:(AnalysisData.nSample),:,:);

AnalysisData.Split(1).X=[temp1 ; temp2];
AnalysisData.Split(2).X=[temp3 ; temp4];
AnalysisData.Split(3).X=[temp1 ; temp3];
AnalysisData.Split(4).X=[temp2 ; temp4];

int_em=permute(AnalysisData.Split(1).X,[3 1 2]);
int_em=int_em.*int_em; %Squared
int_em=misssum(int_em); %Sum
int_em=squeeze(int_em);
int_em1A=misssum(int_em); %Sum

int_ex=permute(AnalysisData.Split(1).X,[2 1 3]);
int_ex=int_ex.*int_ex;
int_ex=misssum(int_ex);
int_ex=squeeze(int_ex);
int_ex1A=misssum(int_ex);

int_em=permute(AnalysisData.Split(2).X,[3 1 2]);
int_em=int_em.*int_em; %Squared
int_em=misssum(int_em); %Sum
int_em=squeeze(int_em);
int_em1B=misssum(int_em); %Sum

int_ex=permute(AnalysisData.Split(2).X,[2 1 3]);
int_ex=int_ex.*int_ex;
int_ex=misssum(int_ex);
int_ex=squeeze(int_ex);
int_ex1B=misssum(int_ex);

int_em=permute(AnalysisData.Split(3).X,[3 1 2]);
int_em=int_em.*int_em; %Squared
int_em=misssum(int_em); %Sum
int_em=squeeze(int_em);
int_em2A=misssum(int_em); %Sum

int_ex=permute(AnalysisData.Split(3).X,[2 1 3]);
int_ex=int_ex.*int_ex;
int_ex=misssum(int_ex);
int_ex=squeeze(int_ex);
int_ex2A=misssum(int_ex);

int_em=permute(AnalysisData.Split(4).X,[3 1 2]);
int_em=int_em.*int_em; %Squared
int_em=misssum(int_em); %Sum
int_em=squeeze(int_em);
int_em2B=misssum(int_em); %Sum

int_ex=permute(AnalysisData.Split(4).X,[2 1 3]);
int_ex=int_ex.*int_ex;
int_ex=misssum(int_ex);
int_ex=squeeze(int_ex);
int_ex2B=misssum(int_ex);



subplot(2,2,1),
plot(AnalysisData.Ex,int_ex1A(1,:),AnalysisData.Ex,int_ex1B(1,:))
title('Split 1-2')
axis tight
xlabel('Ex. (nm)')
ylabel('Sum of Squares')
subplot(2,2,3),
plot(AnalysisData.Em,int_em1A(1,:),AnalysisData.Em,int_em1B(1,:))
axis tight
xlabel('Em. (nm)')
ylabel('Sum of Squares')

subplot(2,2,2),
plot(AnalysisData.Ex,int_ex2A(1,:),AnalysisData.Ex,int_ex2B(1,:))
title('Split 3-4')
axis tight
xlabel('Ex. (nm)')
ylabel('Sum of Squares')
subplot(2,2,4),
plot(AnalysisData.Em,int_em2A(1,:),AnalysisData.Em,int_em2B(1,:))
axis tight
xlabel('Em. (nm)')
ylabel('Sum of Squares')