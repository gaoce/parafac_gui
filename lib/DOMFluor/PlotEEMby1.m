function PlotEEMby1(sample,data,FlUnit)


%PlotEEMby1 Plots EEMs one at a time as contour plots. 
%
%INPUT: PlotEEMby1(sample,data,FlUnit);
%
%sample : Define which sample or number of samples to plot
%           (e.g 25, or 1:5)
%data: identifies the data to be plotted 
%           (e.g. OriginalData or CutData).
%FlUnit: defines units for the Fl axis label 
%           (e.g. 'A.U.' or 'QSE' or 'Raman Units'...etc)
%
%Example
%PlotEEMby1(1:5,OriginalData,'R.U.')

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805

figure
for i=(sample)
    contourf(data.Ex,data.Em,(squeeze(data.X(i,:,:))));
    colorbar;
    xlabel('Ex. (nm)');
    ylabel('Em. (nm)');
    ylabel(colorbar,FlUnit);
    title(['sample nr ' num2str(i)]);
    pause;
end

