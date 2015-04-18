function MeanError(data,fA,fB,fC)

% The MeanError function plots the mean residuals for the whole data
%set as an EEM (both contour and surface plots) for three different models.
% This can be used to help evaluate the appropriate number of components.
% Are the peak regions in the residuals? Or are they basicaly flat and noisy?
%
%INPUT: MeanError(data,fA,fB,fC)
%data: Define which data to use
%fA: Number of compnents in first model to compare
%fB: Number of components in the second model to compare 
%fC: Number of components in the third model to compare
%
%Example
%MeanError(Test2,3,4,5)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805



eval(['ModelA=','data.Model',int2str(fA)]);
eval(['ModelB=','data.Model',int2str(fB)]);
eval(['ModelC=','data.Model',int2str(fC)]);

MA =nmodel(ModelA);   
EA=data.X-MA;
MA=data.X-EA;

MB =nmodel(ModelB);   
EB=data.X-MB;
MB=data.X-EB;

MC =nmodel(ModelC);   
EC=data.X-MC;
MC=data.X-EC;

meanA=squeeze(missmean(EA));
meanB=squeeze(missmean(EB));
meanC=squeeze(missmean(EC));




subplot(2,3,1),
contourf(data.Ex,data.Em,(meanA)), colorbar  
axis tight
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
title([num2str(fA) ' Components'])
subplot(2,3,2),
contourf(data.Ex,data.Em,(meanB)), colorbar  
axis tight
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
title([num2str(fB) ' Components'])
subplot(2,3,3),
contourf(data.Ex,data.Em,(meanC)), colorbar  
axis tight
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
title([num2str(fC) ' Components'])

subplot(2,3,4),
surfc(data.Ex,data.Em,(meanA)),  
shading interp
view(-20,56)
axis tight
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
title([num2str(fA) ' Components'])
subplot(2,3,5),
surfc(data.Ex,data.Em,(meanB)),  
shading interp
view(-20,56) 
axis tight
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
title([num2str(fB) ' Components'])
subplot(2,3,6),
surfc(data.Ex,data.Em,(meanC)),  
shading interp
view(-20,56) 
axis tight
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
title([num2str(fC) ' Components'])
