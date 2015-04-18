function PlotEEMby4FixZ(startsample,data,FlUnit)

%PlotSurfby4FixZ Plots four EEMs one at a time as contour plots using a 
%fixed Z axis (which is determined automatically by calculating the min 
%and max fluorescence of the whole data set). 
%
%INPUT: PlotSurfby4FixZ(sample,data,FlUnit);
%
%sample : Define which sample or number of samples to plot
%           (e.g 25, or 1:5)
%data: identifies the data to be plotted 
%           (e.g. OriginalData or CutData).
%FlUnit: defines units for the Fl axis label 
%           (e.g. 'A.U.' or 'QSE' or 'Raman Units'...etc)
%
%Example
%PlotSurfby4FixZ(1,OriginalData,'R.U.')

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


xmin=min(data.Ex);
xmax=max(data.Ex);
ymin=min(data.Em);
ymax=max(data.Em);
zmin=min(reshape(data.X,(data.nSample*data.nEm*data.nEx),1));
zmax=max(reshape(data.X,(data.nSample*data.nEm*data.nEx),1));

figure,
for i=(startsample:4:data.nSample), pause
    if i<=data.nSample,
    subplot(2,2,1),
    surfc(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), 
    shading interp
    view(-20,56)
    xlabel('Ex. (nm)')
    ylabel('Em. (nm)')
    zlabel(FlUnit);
    axis([xmin xmax ymin ymax zmin zmax]);
    title(['sample nr ' num2str(i)]),
    end
    if (i+1)<=data.nSample,
    subplot(2,2,2),
    surfc(data.Ex,data.Em,(squeeze(data.X(i+1,:,:)))), 
    shading interp
    view(-20,56)
    xlabel('Ex. (nm)')
    ylabel('Em. (nm)')
    zlabel(FlUnit);
    axis([xmin xmax ymin ymax zmin zmax]);
    title(['sample nr ' num2str(i+1)]),
    end
    if (i+2)<=data.nSample,
    subplot(2,2,3),
    surfc(data.Ex,data.Em,(squeeze(data.X(i+2,:,:)))), 
    shading interp
    view(-20,56)
    xlabel('Ex. (nm)')
    ylabel('Em. (nm)')
    zlabel(FlUnit);
    axis([xmin xmax ymin ymax zmin zmax]);
    title(['sample nr ' num2str(i+2)]),
    end
    if (i+3)<=data.nSample,
    subplot(2,2,4),
    surfc(data.Ex,data.Em,(squeeze(data.X(i+3,:,:)))), 
    shading interp
    view(-20,56)
    xlabel('Ex. (nm)')
    ylabel('Em. (nm)')
    zlabel(FlUnit);
    axis([xmin xmax ymin ymax zmin zmax]);
    title(['sample nr ' num2str(i+3)]),
    end
    
end