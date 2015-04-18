function PlotLL(data,f)

%The PlotLL function is used to plot both the leverages and loadings 
%of a chosen PARAFAC model
%Input:  PlotLL(data,f)
%data: identifies the test data where the model results are (e.g. Test1).
%f: state the number of components
%
%Example
%PlotLL(Test,3)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805

eval(['Model=','data.Model',int2str(f)]);
DimX = size(data.X);
X = reshape(data.X,DimX(1),prod(DimX(2:end)));
   
[A,B,C]=fac2let(Model);

CompLegend=(1:f);
CompLegend=CompLegend';
CompLegend=num2str(CompLegend);



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


figure, 
eval(['set(gcf,''Name'',''Loadings & Leverage'');']);
subplot(3,2,1),
plot(A), 
axis tight
ylabel('Scores')
xlabel('Sample Nr')
title('a')
legend(CompLegend,'Location','Best')
subplot(3,2,3),
plot(data.Em,B), 
axis tight
ylabel('Emission loadings')
xlabel('Em. (nm)')
title('b')
subplot(3,2,5),
plot(data.Ex,C), 
axis tight
ylabel('Excitation loadings')
xlabel('Ex. (nm)')
title('c')


% PLOTS OF LEVERAGE
  
  A=reshape(factors(lidx(1,1):lidx(1,2)),DimX(1),f);
    lev=diag(A*pinv(A'*A)*A');
    subplot(3,2,2)
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
    subplot(3,2,4)
    if std(lev)>eps
      plot(data.Em,lev+100*eps,'+'), axis tight
    else
      warning('Leverage is constant')
    end
    xlabel('Em. (nm)');
    ylabel('Leverage');
    
    A=reshape(factors(lidx(3,1):lidx(3,2)),DimX(3),f);
    lev=diag(A*pinv(A'*A)*A');
    subplot(3,2,6)
    if std(lev)>eps
      plot(data.Ex,lev+100*eps,'+'), axis tight
    else
      warning('Leverage is constant')
    end
    xlabel('Ex. (nm)');
    ylabel('Leverage');
    
    
    