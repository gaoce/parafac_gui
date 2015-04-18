function SplitHalfValidation(data,split,f)

%The SplitHalfValidation function automatically compares the excitation 
%and emission loadings from different split half models and determines 
%whether they are the same or not (i.e. is the model valid). 
%The function derives Tucker Congruence Coeficients as described in:
%Lorenzo-Seva, U., Berge, J.M.F.T., 2006. Methodology, 2 (2), 57–64.
%
%INPUT: SplitHalfLoadings(data,split,f)
%data: refers to the data structure where the data is (e.g. AnalysisData)
%split: can be either '1-2' or '3-4' depending on which halves are to be examined;
%f: the number of compoents in the model to be examined.
%
%Example
%SplitHalfValidation(Analysis,'1-2',4)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805

switch split
    case{'1-2'}
Cal=data.Split(1);
Val=data.Split(2);
end

switch split
    case{'3-4'}
Cal=data.Split(3);
Val=data.Split(4);
end


f=num2str(f);
eval(['Fac_Cal=','Cal.Fac_',f,';']); 
eval(['Fac_Val=','Val.Fac_',f,';']); 
    disp([f ' Component Model, Split=' split])
TCC(Fac_Cal,Fac_Val);

    
    
%Plot loadings
[A1,B1,C1]=fac2let(Fac_Cal);
[A2,B2,C2]=fac2let(Fac_Val);
f=size(A1);
f=f(1,2);
CompLegend=(1:f);
CompLegend=CompLegend';
CompLegend=num2str(CompLegend);


figure,eval('set(gcf,''Name'',''Split Half Comparison'');');
subplot(2,2,1),
plot(data.Em,B1), 
axis tight
ylabel('Emission loadings')
xlabel('Em. (nm)')
subplot(2,2,2),
plot(data.Ex,C1), 
axis tight
legend(CompLegend)
ylabel('Excitation loadings')
xlabel('Ex. (nm)')
subplot(2,2,3),
plot(data.Em,B2), 
axis tight
ylabel('Emission loadings')
xlabel('Em. (nm)')
subplot(2,2,4),
plot(data.Ex,C2), 
axis tight
legend(CompLegend)
ylabel('Excitation loadings')
xlabel('Ex. (nm)')





