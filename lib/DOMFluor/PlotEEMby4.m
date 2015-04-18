function PlotEEMby4(startsample,data,FlUnit)

%PlotEEMby4 Plots four EEMs one at a time as contour plots. 
%
%INPUT: PlotEEMby4(sample,data,FlUnit);
%
%sample : Define which sample or number of samples to plot
%           (e.g 25, or 1:5)
%data: identifies the data to be plotted 
%           (e.g. OriginalData or CutData).
%FlUnit: defines units for the Fl axis label 
%           (e.g. 'A.U.' or 'QSE' or 'Raman Units'...etc)
%
%Example
%PlotEEMby4(1,OriginalData,'R.U.')

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


figure,
for i=(startsample:4:data.nSample), pause
    if i<=data.nSample,
    subplot(2,2,1),
    contourf(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), colorbar
    xlabel('Ex. (nm)')
    ylabel('Em. (nm)')
    ylabel(colorbar,FlUnit);
    title(['sample nr ' num2str(i)]),
    end
    
    if (i+1)<=data.nSample,
    subplot(2,2,2),
    contourf(data.Ex,data.Em,(squeeze(data.X(i+1,:,:)))), colorbar
    xlabel('Ex. (nm)')
    ylabel('Em. (nm)')
    ylabel(colorbar,FlUnit);
    title(['sample nr ' num2str(i+1)]),
    end

    if (i+2)<=data.nSample,
    subplot(2,2,3),
    contourf(data.Ex,data.Em,(squeeze(data.X(i+2,:,:)))), colorbar
    xlabel('Ex. (nm)')
    ylabel('Em. (nm)')
    ylabel(colorbar,FlUnit);
    title(['sample nr ' num2str(i+2)]),
    end
    
    if (i+3)<=data.nSample,
    subplot(2,2,4),
    contourf(data.Ex,data.Em,(squeeze(data.X(i+3,:,:)))), colorbar
    xlabel('Ex. (nm)')
    ylabel('Em. (nm)')
    ylabel(colorbar,FlUnit);
    title(['sample nr ' num2str(i+3)]),
    end
end