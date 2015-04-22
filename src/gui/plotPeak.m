function fh = plotPeak(normEEM, peakEm, peakEx, outPath)
%PLOTPEAK

intensity = ones(normEEM.nSample,1);

% the input peakEm and peakEx wavelength may not be in the data, we find
% the closest one
[~, locPeakEm] = min(abs(normEEM.Em - peakEm));
[~, locPeakEx] = min(abs(normEEM.Ex - peakEx));

realPeakEm = normEEM.Em(locPeakEm);
realPeakEx = normEEM.Ex(locPeakEx);

%
for i = 1:normEEM.nSample
    intensity(i) = normEEM.X(i, locPeakEm, locPeakEx);
end

% maxIntensity = max(intensity);
fh = figure('Visible','off');
% Location and size
set(fh,'color','w','Position',[50 50 600 600]);

% Get Plot object early on
plt = Plot();
    
bar(intensity);
pos = get(gca,'Position');
pos([2,4]) = [0.3, 0.6];

% XTick  
set(gca, 'XTickLabel', normEEM.Sample, 'Position', pos);
rotateXLabels(gca,45);
xlim([0 normEEM.nSample+1]);
title(['Em: ', num2str(realPeakEm), ', Ex: ', num2str(realPeakEx)]);
% ylim([0 maxIntensity]);
   
% Make it visible
movegui(fh, 'center');
set(fh, 'Visible', 'on');

% Export figure
fileName = sprintf('%s/intensity_Em_%d_Ex_%d.pdf', outPath, realPeakEm, realPeakEx);
plt.export(fileName);