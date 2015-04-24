function switchComp(tagNames, status, hObject)
%SWITCH Switch gui component on or off

if nargin == 2
    hObject = gcf;
end

data = guidata(hObject);

for i = 1:length(tagNames)
    % Check if this a valid query 
    assert(isfield(data, tagNames{i}), ...
        ['Cannot find the obj with tag: ', tagNames{i}]);
    
    set(data.(tagNames{i}), 'Enable', status);
end

end

