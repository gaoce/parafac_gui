function PlotLeverage(data,f)

%The PlotLeverage function is used to plot the leverages of each sample,
%emission wavelength and excitation wavelength.
%Input:  PlotLeverage(data,f)
%data: identifies the test data where the model results are (e.g. Test1).
%f: state the number of components
%
%Example
%PlotLeverage(Test,3)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


eval(['Model=','data.Model',int2str(f)]);
DimX = size(data.X);
X = reshape(data.X,DimX(1),prod(DimX(2:end)));


f2 = [];
for f1=1:length(Model)
  f2=[f2;Model{f1}(:)];
end
factors = f2;

lidx=[];
lidx(1,:)=[1 DimX(1)*f];
for i=2:3
  lidx=[lidx;[lidx(i-1,2)+1 sum(DimX(1:i))*f]];
end
% PLOTS OF LEVERAGE
  figure
  eval(['set(gcf,''Name'',''Leverage'');']);
 
  A=reshape(factors(lidx(1,1):lidx(1,2)),DimX(1),f);
    lev=diag(A*pinv(A'*A)*A');
    subplot(2,2,1)
    if std(lev)>eps
      plot(lev+100*eps,'+'), 
      for j=1:DimX(1)
        text(j,lev(j),num2str(j))
      end
    else
      warning('Leverage is constant')
    end
    xlabel('Sample Nr');
    ylabel('Leverage');
    
    A=reshape(factors(lidx(2,1):lidx(2,2)),DimX(2),f);
    lev=diag(A*pinv(A'*A)*A');
    subplot(2,2,2)
    if std(lev)>eps
      plot(data.Em,lev+100*eps,'+'), axis tight
    else
      warning('Leverage is constant')
    end
    xlabel('Em. (nm)');
    ylabel('Leverage');
    
    A=reshape(factors(lidx(3,1):lidx(3,2)),DimX(3),f);
    lev=diag(A*pinv(A'*A)*A');
    subplot(2,2,3)
    if std(lev)>eps
      plot(data.Ex,lev+100*eps,'+'), axis tight
    else
      warning('Leverage is constant')
    end
    xlabel('Ex. (nm)');
    ylabel('Leverage');
    
    
    