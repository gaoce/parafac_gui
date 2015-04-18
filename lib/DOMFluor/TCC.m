function TCC(factor1,factor2)

% The TCC function calculates the Tukker Congruence Coeffients between two 
%different PARAFAC models for the emission and excitation loadings. 
%The function derives Tucker Congruence Coeficients as described in:
%Lorenzo-Seva, U., Berge, J.M.F.T., 2006. Methodology, 2 (2), 57–64.
%
%
% INPUT: TCC(factor1,factor2)
%factor1: the first parafac model to compare
%factor2: the second parafac model to compare
%
%Example
%1) to compare a five component model before and after outliers have been
%removed,
%TCC(Test1.Model5,Test2.Model5)
%2)To compare a six component model derived on the whole data with one from
%the splithlaf analysis,
%TCC(AnalysisData.Model6,AnalysisData.Split(1).Fac_6)

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


Fac= size(factor1{2},2);


%Compare Em loadings
Loadi=factor1{2};
Loadj=factor2{2};


ii=sum(Loadi.^2);
jj=sum(Loadj.^2);

for i=1:Fac,
    for j=1:Fac,
        ij(i,j)=sum((Loadi(:,(i))).*(Loadj(:,(j)))); 
        B_TCC(i,j)=(ij(i,j))./(((ii(1,(i))).*(jj(1,(j))))^0.5);
        if B_TCC(i,j)>0.95,
            B_TCC95(i,j)=B_TCC(i,j);
        else B_TCC95(i,j)=0;
        end
    end
end
%Compare Ex loadings
Loadi=factor1{3};
Loadj=factor2{3};

ii=sum(Loadi.^2);
jj=sum(Loadj.^2);

for i=1:Fac,
    for j=1:Fac,
        ij(i,j)=sum((Loadi(:,(i))).*(Loadj(:,(j)))); 
        C_TCC(i,j)=(ij(i,j))./(((ii(1,(i))).*(jj(1,(j))))^0.5);
        if C_TCC(i,j)>0.95,
            C_TCC95(i,j)=C_TCC(i,j);
        else C_TCC95(i,j)=0;
        end
    end
end


%disp('Tucker’s Congruence Coefficient for Emission loadings ')
%disp(B_TCC)
%disp('Tucker’s Congruence Coefficient for Exciation loadings ')
%disp(C_TCC)


%disp('Tucker’s Congruence Coefficient for Emission loadings, (>0.95) ')
%disp(B_TCC95)
%disp('Tucker’s Congruence Coefficient for Exciation loadings (>0.95)')
%disp(C_TCC95)

for i=1:Fac,
    for j=1:Fac,
        if B_TCC(i,j)>0.95 & C_TCC(i,j)>0.95,
            Match(i,j)=1;
        else Match(i,j)=0;
        end
    end
end
x=(1:Fac);
y=(0:Fac)';
x=[x;Match];
Match=[y x];

if sum(Match(2:end,2:end),1)==ones(1,Fac),
    disp('Model Split half validated');
else disp('Result= Not Validated');
    
end
Match(2:end,2:end)

