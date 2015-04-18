function Compare2Models(data,fA,fB)

%Compare2Models compares the fit of two different models plotting
%the results of two models with different number of components in the same
%figure window. For each sample the measured, modeled (x2) and residual
%(x2) contour plots are shown. The function automatically pages through all
%the samples in the dataset. To stop before the last sample press
%Ctrl-c.
%
%INPUT: Compare2Models(data,fA,fB)
%
%data: Define which data to use (e.g. (Test2))
%fA: Number of compnents in first model to compare
%fB: Number of components in the second model to compare 
%
%Example
%Compare2Models(Test2,4,5)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805

eval(['ModelA=','data.Model',int2str(fA)]);
eval(['ModelB=','data.Model',int2str(fB)]);

MA =nmodel(ModelA);   
EA=data.X-MA;
MA=data.X-EA;

MB =nmodel(ModelB);   
EB=data.X-MB;
MB=data.X-EB;


figure;
for i=(1:1:(data.nSample)), pause(0.2)  
subplot(3,3,2),
contourf(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), colorbar    
title(['Measured (' num2str(i) ')']),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
subplot(3,3,4),
contourf(data.Ex,data.Em,(squeeze(MA(i,:,:)))), colorbar 
title(([num2str(fA) ' component model']))
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
subplot(3,3,7),
contourf(data.Ex,data.Em,(squeeze(EA(i,:,:)))), colorbar 
title('Residuals')
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
subplot(3,3,6),
contourf(data.Ex,data.Em,(squeeze(MB(i,:,:)))), colorbar 
title(([num2str(fB) ' component model' ]))
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
subplot(3,3,9),
contourf(data.Ex,data.Em,(squeeze(EB(i,:,:)))), colorbar 
title('Residuals')
xlabel('Ex. (nm)')
ylabel('Em. (nm)')

end
