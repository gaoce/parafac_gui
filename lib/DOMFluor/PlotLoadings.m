function PlotLoadings(data,f)

%The PlotLoadings function is used to plot the loadings of each sample,
%emission wavelength and excitation wavelength.
%Input:  PlotLoadings(data,f)
%data: identifies the test data where the model results are (e.g. Test1).
%f: state the number of components
%
%Example
%PlotLoadings(Test,3)

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

figure, 
eval(['set(gcf,''Name'',''Scores and Loadings'');']);
subplot(2,2,1),
plot(A), 
axis tight
ylabel('Scores')
xlabel('Sample Nr')
title('a')
legend(CompLegend,'Location','Best')
subplot(2,2,2),
plot(data.Em,B), 
axis tight
ylabel('Emission loadings')
xlabel('Em. (nm)')
title('b')
subplot(2,2,3),
plot(data.Ex,C), 
axis tight
ylabel('Excitation loadings')
xlabel('Ex. (nm)')
title('c')


    
    