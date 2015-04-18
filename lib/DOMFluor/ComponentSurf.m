function ComponentSurf(data,f)

%The ComponentSurf function creates contour plots of each component.
%A new figure window is made for each component.
%
%data: soure of data
%f: number of components in model
%
%Example:
%ComponentSurf(AnalysisData,5)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


eval(['Model=','data.Model',int2str(f)]);

M =nmodel(Model);   
E=data.X-M;
[A,B,C]=fac2let(Model);
Comp=[];
for i=(1:f),
    Comp=reshape((krb(C(:,i),B(:,i))'),[1 data.nEm data.nEx]); 
    Comp=flucut(Comp,data.Em,data.Ex,[0 NaN],[NaN NaN]); 
    figure;
    surfc(data.Ex,data.Em,(squeeze(Comp(1,:,:)))), axis tight,    
    title(['Component ' num2str(i)]),
    shading interp
    view(-20,56)
    xlabel('Ex. (nm)')
    ylabel('Em. (nm)')
end





function [Xnew,EmNew,ExNew] = flucut(X,EmAx,ExAx,Cut1,Cut2)
%[Xnew,EmNew,ExNew] = flucut(X,EmAx,ExAx,Cut1,Cut2)
%
% Inserts a mixture of NaN and 0 values outside the data area of
% an EEM (Excitation-Emission Matrix).
%
% INPUT:
%    X      The X-array from the fluoressence spectra
%    EmAx   The Emitation Axis
%    ExAx   The Excitation Axis
%    Cut1   Two numbers indicating how far away from the Rayleigh scatter
%    Cut2   line NaN and 0 values should be insterted. Negative values
%           indicate that the NaN's or 0's should be inserted above the
%           Rayleigh scatter line. First number is for NaN values the
%           the second for 0's. NaN values indicate that nothing should
%           be insterted. E.g. [NaN 10] means that no NaN-values should be
%           inserted, but 0's should be inserted 10nm from the Rayleigh
%           scatter line. Cut1 is for 1st order Rayleigh, Cut2 is for 2nd
%           order Rayleigh.
% 
% Example: [Xnew,EmNew,ExNew] = flucut(X,EmAx,ExAx,[-10 10],[-10 20]);
%
% OUTPUT:
%    Xnew   New X-array with inserted NaN and 0-values. Columns with only missing
%            values are removed
%    EmNew  Same reduced dimension as Xnew
%    ExNew  Same reduced dimension as Xnew

% OMAL 210504

%Checks if the vectors are correctly given.

if isempty(EmAx)
  try
    EmAx = X.axisscale{2};
  end
end
if isempty(ExAx)
  try
    ExAx = X.axisscale{3};
  end
end

if length(EmAx)~=size(X,2)
  if length(EmAx)==size(X,2)
    error('You have mixed Em and Ex')
  else
    error('The correct Em and Ex are not given')
  end
end

%Lines 39-50 inserts values into Cut1 and Cut2 if these are not given.
if nargin<4
  Cut1=ones(1,2)*NaN;
end
if length(Cut1)<2
  Cut1=[Cut1 NaN];
end
if nargin<5
  Cut2=ones(1,2)*NaN;
end
if length(Cut2)<2
  Cut2=[Cut2 NaN];
end

%Runs an insertion twice. First with NaN's and then with 0's.
in=[NaN 0];
for i=1:2
  %If the Cut parameter is set to NaN noting is done.
  if Cut1(i)~=NaN
    for j = 1:length(ExAx)
      k = find(EmAx<(ExAx(j)-Cut1(i)));
      X(:,k,j)=in(i);
    end
  end

  if Cut2(i)~=NaN
    for j = 1:length(ExAx)
      k = find(EmAx>(ExAx(j)*2+Cut2(i)));
      X(:,k,j)=in(i);
    end
  end
end

%The matrix is reduced in size in the cases when NaN's have been introduced
%into whole slabs in the 2nd or 3rd mode of the original data. Nothing
%happens here in the cases where 0's have been inserted.
n=squeeze(isnan(X(1,:,:)));
i=find(sum(n)<size(X,2));
j=find(sum(n')<size(X,3));
Xnew=X(:,j,i);
EmNew=EmAx(j);
ExNew=ExAx(i);
