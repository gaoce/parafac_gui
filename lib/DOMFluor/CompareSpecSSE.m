function CompareSpecSSE(data,fA,fB,fC)

% The CompareSpecSSE function plots the sum of squared error (residuals) 
%in both the excitation and emission dimensions for three different models.
% This can be used to help evaluate the appropriate number of components.
% A small change in the sum of squared residual spectra indicates that the
% addition of the last component might have been unesscessary.
%
%INPUT: CompareSpecSSE(data,fA,fB,fC)
%data: Define which data to use
%fA: Number of compnents in first model to compare
%fB: Number of components in the second model to compare 
%fC: Number of components in the third model to compare
%
%Example
%CompareSpecSSE(Test2,3,4,5)

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


intE_em=permute(EA,[3 1 2]);
intE_em=intE_em.*intE_em; %Squared
intE_em=misssum(intE_em); %Sum
intE_em=squeeze(intE_em);
intE_emA=misssum(intE_em); %Sum

intE_ex=permute(EA,[2 1 3]);
intE_ex=intE_ex.*intE_ex;
intE_ex=misssum(intE_ex);
intE_ex=squeeze(intE_ex);
intE_exA=misssum(intE_ex);

intE_em=permute(EB,[3 1 2]);
intE_em=intE_em.*intE_em;
intE_em=misssum(intE_em);
intE_em=squeeze(intE_em);
intE_emB=misssum(intE_em);

intE_ex=permute(EB,[2 1 3]);
intE_ex=intE_ex.*intE_ex;
intE_ex=misssum(intE_ex);
intE_ex=squeeze(intE_ex);
intE_exB=misssum(intE_ex);

intE_em=permute(EC,[3 1 2]);
intE_em=intE_em.*intE_em;
intE_em=misssum(intE_em);
intE_em=squeeze(intE_em);
intE_emC=misssum(intE_em);

intE_ex=permute(EC,[2 1 3]);
intE_ex=intE_ex.*intE_ex;
intE_ex=misssum(intE_ex);
intE_ex=squeeze(intE_ex);
intE_exC=misssum(intE_ex);



subplot(2,1,1),
plot(data.Ex,intE_exA(1,:),data.Ex,intE_exB(1,:),data.Ex,intE_exC(1,:))
legend([num2str(fA) ' Components'],[num2str(fB) ' Components'],[num2str(fC) ' Components'])
axis tight
xlabel('Ex. (nm)')
ylabel('Sum of Squared Error')
subplot(2,1,2),
plot(data.Em,intE_emA(1,:),data.Em,intE_emB(1,:),data.Em,intE_emC(1,:))
axis tight
xlabel('Em. (nm)')
ylabel('Sum of Squared Error')