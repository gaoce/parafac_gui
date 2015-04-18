function EvalModel(data,f)

%EvalModel allows one to evaluate the fit of a PARAFAC model. 
%The measured, modelled and residual (measured-modelled) EEMs are plotted
%as contour plots one at a time. 
%In addition the spectral loadings of each component are
%plotted and the fluorecence of each component in each sample is plotted as
%a bar chart of fluorescence maximum values.
%Finally a diagonal slice across the EEM (equivalent of a synchronous scan) 
%is plotted for the measured, modeled and residual data.
%
%INPUT: EvalModel(data,f)
%data: refers to the location of the data
%f: is the number of components in the model to be evaluated.
%
%Example
%EvalModel(Test2,5)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


eval(['Model=','data.Model',int2str(f)]);

M =nmodel(Model);   
E=data.X-M;
M=data.X-E;
[A,B,C]=fac2let(Model);
BMax=max(B);
CMax=max(C);

FMax=[];
for i=(1:(data.nSample)),
    FMax(i,:)=(A(i,:)).*(BMax.*CMax);
end
CompLegend=(1:f);
CompLegend=CompLegend';
CompLegend=num2str(CompLegend);

figure;
for i=(1:1:(data.nSample)), pause   
subplot(3,3,1),
contourf(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), colorbar    
title(['Measured (' num2str(i) ')']),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')

subplot(3,3,4),
contourf(data.Ex,data.Em,(squeeze(M(i,:,:)))), colorbar 
title('Model'),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')
subplot(3,3,7),
contourf(data.Ex,data.Em,(squeeze(E(i,:,:)))), colorbar 
title('Residual'),
xlabel('Ex. (nm)')
ylabel('Em. (nm)')


subplot(3,3,3)
bar(FMax(i,:))
title('Fl. Max')
ylabel('Fl.')
xlabel('Component')

subplot(3,3,2),
plot(data.Em,B), 
axis tight
legend(CompLegend)
title('Emission loadings')
xlabel('Em. (nm)')
subplot(3,3,5),
plot(data.Ex,C), 
axis tight
legend()
title('Excitation loadings')
xlabel('Ex. (nm)')


subplot(3,3,6),
[I,J,K]=size(data.X);
d = min(J,K);
id1 = round(linspace(1,J,d));
id2 = round(linspace(1,K,d));
SSX=[];
SSM=[];
SSE=[];
for ii=1:d
    SSX=[SSX;[squeeze(data.X(i,id1(ii),id2(ii)))]];
    SSM=[SSM;[squeeze(M(i,id1(ii),id2(ii)))]];
    SSE=[SSE;[squeeze(E(i,id1(ii),id2(ii)))]];
end
plot(data.Ex(id2),SSX,data.Ex(id2),SSM,data.Ex(id2),SSE), axis tight
legend('Measured','Model','Residual')
title('Diagonal across the EEM ')
xlabel('Ex. (nm)')

end