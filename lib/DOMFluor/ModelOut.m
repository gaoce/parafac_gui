function [FMax,B,C]=ModelOut(data,f,excelname)

%The ModelOut function exports the model results to an excel file.
%Three sheets are created. "FMax" with the fluorescence intensity of each
%component in each sample, and "Em Loadings" and "Ex Loadings" with the 
%spectral loadings of each component.
%
%data: soure of data
%f: number of components in model to export
%excelname: name and location of the excel file to create.
%
%Example:
%[FMax,B,C]=ModelOut(AnalysisData,5,'C:\MyParafacResults.xls')

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


eval(['Model=','data.Model',int2str(f)]);

M =nmodel(Model);   
E=data.X-M;
[A,B,C]=fac2let(Model);
BMax=max(B);
CMax=max(C);

FMax=[];
for i=(1:(data.nSample)),
    FMax(i,:)=(A(i,:)).*(BMax.*CMax);
end


B=[data.Em B];
C=[data.Ex C];

xlswrite(excelname,FMax,'FMax')
xlswrite(excelname,B,'Em Loadings')
xlswrite(excelname,C,'Ex Loadings')

