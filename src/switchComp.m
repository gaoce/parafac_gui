function switchComp(tagNames, status, hObject)
%SWITCH Switch gui component on or off

if nargin == 2
    hObject = gcf;
end

data = guidata(hObject);

for i = 1:length(tagNames)
    tag = tagNames{i};
    % Check if this a valid query
    compHandle = findobj('Tag', tag);
    if isempty(compHandle)
        if isfield(data, tag)
            compHandle = data.(tag);
        else
            error(['Cannot find the obj with tag: ', tag]);
        end
    end
    
    set(compHandle, 'Enable', status);
end

end

