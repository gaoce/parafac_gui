function plotIntensity(normEEM, outPath)

% locs = [4 201 3 111 25 201];

int1 = ones(normEEM.nSample,1);
int2 = ones(normEEM.nSample,1);
int3 = ones(normEEM.nSample,1);


for i = 1:normEEM.nSample
    int1(i) = normEEM.X(i,201, 4);
    int2(i) = normEEM.X(i,111, 3);
    int3(i) = normEEM.X(i,201,25);
end

maxIntensity = max([int1; int2; int3]);
fh = figure('Visible','off');

subplot(1,3,1);
bar(int1);
pos = get(gca,'Position');
pos([2,4]) = [0.3, 0.6];
set(gca, 'XTickLabel', normEEM.Sample, 'Position', pos);
rotateXLabels(gca,45);
title('Peak 1');
xlim([0 normEEM.nSample+1]);
ylim([0 maxIntensity]);

subplot(1,3,2);
bar(int2);
pos = get(gca,'Position');
pos([2,4]) = [0.3, 0.6];
set(gca, 'XTickLabel', normEEM.Sample, 'Position', pos);
rotateXLabels(gca,45);
title('Peak 2');
xlim([0 normEEM.nSample+1]);
ylim([0 maxIntensity]);

subplot(1,3,3);
bar(int3);
pos = get(gca,'Position');
pos([2,4]) = [0.3, 0.6];
set(gca, 'XTickLabel', normEEM.Sample, 'Position', pos);
rotateXLabels(gca,45);
title('Peak 3');
xlim([0 normEEM.nSample+1]);
ylim([0 maxIntensity]);

set(fh,'color','w','Position',[50 50 1000 500]);

export_fig([outPath,'/intensity.pdf']);
close(fh);

end