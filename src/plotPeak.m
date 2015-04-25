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

fh = figure('Visible','off');
% Location and size
set(fh,'color','w','Position',[50 50 600 600]);

% Get Plot object early on
plt = Plot();

% Plot the bar chart
bar(intensity);

xlim([0 normEEM.nSample+1]);
rotateXTickLabel(normEEM.Sample, 45);
title(['Em: ', num2str(realPeakEm), ', Ex: ', num2str(realPeakEx)]);
% ylim([0 maxIntensity]);
   
% Make it visible
movegui(fh, 'center');
set(fh, 'Visible', 'on');

%% Export figure
datestr = clock;
baseFileName = sprintf('%s/intensity_%4d-%02d-%02d_%02d-%02d__Em_%d_Ex_%d', ...
    outPath, datestr(1:5), realPeakEm, realPeakEx);
plt.export([baseFileName, '.pdf']);

%% Export data file
fid = fopen([baseFileName, '.csv'], 'w');
% Format string of header line
headerFmt = ['Em,Ex,', repmat('%s,', 1, normEEM.nSample-1), '%s\n'];
contentFmt = ['%d,%d,', repmat('%f,', 1, normEEM.nSample-1), '%f\n'];
fprintf(fid, headerFmt, normEEM.Sample{:});
fprintf(fid, contentFmt, realPeakEm, realPeakEx, intensity(:));
fclose(fid);