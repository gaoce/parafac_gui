function [CutData]=EEMCut(data,FirstOrderMissing,FirstOrderZeros,SecondOrderMissing,SecondOrderZeros,Pause)

%EEMCut removes data from unwanted regions of the EEMs and then
%plots to compare with original un-cut data.
%
%INPUT: [CutData]=EEMCut(data,FirstOrderMissing,FirstOrderZeros,SecondOrderMissing,SecondOrderZeros,Pause);
%
%data: identifies the data to be cut (e.g. OriginalData).
%FirstOrderMissing: Define upper boundry of First Order scatter signal.
%    E.g. 40 = Emission data at wavelength <Ex wavelength+40,
%              will be replaced with missing data (NaN)
%FirstOrderZeros: Define area for zeros to be inserted.
%    E.g 35 = Zeros inserted at Emission wavelengths that are <Ex wavelength-35.
%SecondOrderMissing: Same as for first order just for second order
%   scatter (if present). Otherwise set to NaN;
%SecondOrderZeros: Same as for first order just for second order
%   scatter (if present). Otherwise set to NaN;
%Pause: If set to 'Yes' the user will have to press a key to plot the next
%   graph. If set to 'No' the graphs will be plotted automatically. If set
%   to '' the cut will be preformed but the data will not be plotted.
%
%Example
%[CutData]=EEMCut(OriginalData,20,20,NaN,NaN,'No')

%Copyright (C) 2008- Colin A. Stedmon
%Department of Marine Ecology, National Environmental Research Institute,
%Aarhus University, Frederiksborgvej 399, Roskilde, Denmark.
%e-mail: cst@dmu.dk, Tel: +45 46301805


Cut1=[(-1*FirstOrderMissing) FirstOrderZeros];
Cut2=[(-1*SecondOrderMissing) SecondOrderZeros];

X=data.X;

in=[NaN 0];
for i=1:2
    if Cut1(i)~=NaN
        for j = 1:length(data.Ex)
            k = find(data.Em<(data.Ex(j)-Cut1(i)));
            X(:,k,j)=in(i);
        end
    end
    
    if Cut2(i)~=NaN
        for j = 1:length(data.Ex)
            k = find(data.Em>(data.Ex(j)*2+Cut2(i)));
            X(:,k,j)=in(i);
        end
    end
end


n=squeeze(isnan(X(1,:,:)));
i=find(sum(n)<size(X,2));
j=find(sum(n')<size(X,3));
CutData.X=X(:,j,i);
CutData.Em=data.Em(j);
CutData.Ex=data.Ex(i);
CutData.nEx=size(CutData.Ex,1); %identifys the number of Excitation wavelengths
CutData.nEm=size(CutData.Em,1);  %identifys the number of Emission wavelengths
CutData.nSample=size(CutData.X,1);



switch Pause
    case ('Yes')
        figure;
        for i=(1:1:data.nSample), pause
            if i<=data.nSample,
                subplot(2,2,1)
                contourf(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), colorbar
                title(['sample nr ' num2str(i)]),
                xlabel('Ex. (nm)')
                ylabel('Em. (nm)')
                subplot(2,2,2)
                contourf(CutData.Ex,CutData.Em,(squeeze(CutData.X(i,:,:)))), colorbar
                title('Cut')
                xlabel('Ex. (nm)')
                ylabel('Em. (nm)')
                subplot(2,2,3)
                surfc(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), axis tight
                shading interp
                view(-20,56)
                xlabel('Ex. (nm)')
                ylabel('Em. (nm)')
                subplot(2,2,4)
                surfc(CutData.Ex,CutData.Em,(squeeze(CutData.X(i,:,:)))), axis tight
                shading interp
                view(-20,56)
                xlabel('Ex. (nm)')
                ylabel('Em. (nm)')
            end
        end
end

switch Pause
    case ('No')
        figure;
        for i=(1:1:data.nSample), pause(0.1)
            if i<=data.nSample,
                subplot(2,2,1)
                contourf(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), colorbar
                title(['sample nr ' num2str(i)]),
                xlabel('Ex. (nm)')
                ylabel('Em. (nm)')
                subplot(2,2,2)
                contourf(CutData.Ex,CutData.Em,(squeeze(CutData.X(i,:,:)))), colorbar
                title('Cut')
                xlabel('Ex. (nm)')
                ylabel('Em. (nm)')
                subplot(2,2,3)
                surfc(data.Ex,data.Em,(squeeze(data.X(i,:,:)))), axis tight
                shading interp
                view(-20,56)
                xlabel('Ex. (nm)')
                ylabel('Em. (nm)')
                subplot(2,2,4)
                surfc(CutData.Ex,CutData.Em,(squeeze(CutData.X(i,:,:)))), axis tight
                shading interp
                view(-20,56)
                xlabel('Ex. (nm)')
                ylabel('Em. (nm)')
            end
        end
end


