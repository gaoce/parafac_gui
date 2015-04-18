function MMR(data,f)

%MMR plots the EEMs of measured, modelled and residuals for a chosen model.
%As both surface and contour plots one at a time. 
%
%
%INPUT: MMR(data,f)
%data: refers to the location of the data
%f: is the number of components in the model to be evaluated.
%
%Example
%MMR(Test2,5)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


eval(['Model=','data.Model',int2str(f)]);

M =nmodel(Model);   
E=data.X-M;
M=data.X-E;

figure;
for i=(1:1:(data.nSample)), pause   
    if i<data.nSample,
subplot(3,2,1),
contourf(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), colorbar    
title(['Measured (' num2str(i) ')']),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')

subplot(3,2,3),
contourf(data.Ex,data.Em,(squeeze(M(i,:,:)))), colorbar 
title('Model'),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
subplot(3,2,5),
contourf(data.Ex,data.Em,(squeeze(E(i,:,:)))), colorbar 
title('Residual'),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')

subplot(3,2,2),
surfc(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), axis tight
shading interp
view(-20,56)
title(['Measured (' num2str(i) ')']),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')

subplot(3,2,4),
surfc(data.Ex,data.Em,(squeeze(M(i,:,:)))), axis tight
shading interp
view(-20,56)
title('Model'),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
subplot(3,2,6),
surfc(data.Ex,data.Em,(squeeze(E(i,:,:)))), axis tight 
shading interp
view(-20,56)
title('Residual'),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')




    end
end