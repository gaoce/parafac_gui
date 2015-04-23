function rotateXTickLabel(xTickLabels, deg)
%ROTATEXTICKLABEL Rotate the XTickLabels and adjust figure boundary to
%accomodate those texts

nXTickLabels = length(xTickLabels);
xTick = get(gca, 'XTick');

% get position of current xtick labels
% construct position of new xtick labels
xLabelPosition = get(get(gca,'xlabel'), 'position');
xLabelPositionY = xLabelPosition(2);
xLabelPositionY = repmat(xLabelPositionY, 1, nXTickLabels);

% Disable current xtick labels
set(gca,'xtick',[]);

% Set up new xtick labels and rotate
hnew = text(xTick, xLabelPositionY, xTickLabels);
set(hnew, 'rotation', deg, 'horizontalalignment', 'right');

% Some names contain underscores, shut down tex interpreter
set(hnew, 'Interpreter', 'None');

%% Adjust the axis property so all the labels are inside the figure
% Axis Position properties are in normalized units, convert hnew here too
set(hnew, 'Units', 'Normalized')

% Get minimum x and y position for those labels
xTickLabelPositions = get(hnew, 'Extent');
xExtent = zeros(nXTickLabels, 1);
yExtent = zeros(nXTickLabels, 1);
for i = 1:nXTickLabels
    xExtent(i) = xTickLabelPositions{i}(1);
    yExtent(i) = xTickLabelPositions{i}(2);
end
minXExtent = min(xExtent);
minYExtent = min(yExtent);

% Update gca Position
axisPosition = get(gca, 'Position');
if minXExtent < 0
    % Note the OuterPositions shrink two, so use only half minXExtent here
    axisPosition(1) = axisPosition(1) - minXExtent/2;
    axisPosition(3) = axisPosition(3) + minXExtent/2;
end

if minXExtent < 0
    axisPosition(2) = axisPosition(2) - minYExtent/2;
    axisPosition(4) = axisPosition(4) + minYExtent/2;
end

set(gca, 'Position', axisPosition);
end