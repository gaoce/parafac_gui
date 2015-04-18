function [data]=RandInitResult(data,f,it)

%This function presents the results of the Random Initialisation Analysis.
%INPUT: [data]=RandInitResult(data,f,it)
%f: Number of compnents to fit
%it: number of models to fit
%
%Example: [AnalysisData]=RandInitResult(AnalysisData,5,10)


%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


y=[];

for i=1:it,
eval(['Err=data.Err',int2str(f),'_It',int2str(i)]);
y=[y; Err];

end


miny=min(y);
for j=1:it,
    if y(j,1)==miny
        eval(['data.Model',int2str(f),'=data.Model',int2str(f),'_It',int2str(j)]);
        l=j;
    end
end

plot((1:it),y,l,miny,'O')
title([num2str(f), ' component model, (green "O" is least squares result)']),
xlabel('Model nr.')
ylabel('Sum of Squared Error')

