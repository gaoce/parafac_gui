function plotContour(normEEM, FlUnit, outPath)
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

% CE GAO: the code is adopted from the above author, for inner group use
% only
% 2014-06-20

maxIntensity = max(normEEM.X(:));
for i=1:normEEM.nSample
    fh = figure();
    clf;
    set(fh,'Visible','off');
    contourf(normEEM.Ex,normEEM.Em,(squeeze(normEEM.X(i,:,:))));
    
    caxis([0 maxIntensity]);
    colorbar;
    ylabel(colorbar,FlUnit);
    
    xlabel('Ex. (nm)');
    ylabel('Em. (nm)');
        
    title(normEEM.Sample{i},'interpreter','none');
    set(fh, 'color','w', 'position', [50 50 800 500]);
    
    hold on;
    cent = FastPeakFind(squeeze(normEEM.X(i,:,:)),100);
    plot(normEEM.Ex(cent(1:2:end)),normEEM.Em(cent(2:2:end)),'rs');
    hold off;
    
    export_fig([outPath,'/', normEEM.Sample{i},'.pdf']);
    close(fh);
end
