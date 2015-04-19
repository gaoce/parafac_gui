function plotPeak(normEEM, peakEm, peakEx, outPath)
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

bar(intensity);
pos = get(gca,'Position');
pos([2,4]) = [0.3, 0.6];

% XTick  
set(gca, 'XTickLabel', normEEM.Sample, 'Position', pos);
rotateXLabels(gca,45);
title('Peak 1');
xlim([0 normEEM.nSample+1]);
% ylim([0 maxIntensity]);

set(fh,'color','w','Position',[50 50 1000 500]);

fileName = sprintf('%s/intensity_Em_%d_Ex_%d.pdf', outPath, realPeakEm, realPeakEx);
export_fig(fileName);
close(fh);