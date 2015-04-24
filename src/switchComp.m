function switchComp(tagNames, status, hObject)
%SWITCH Switch gui component on or off

if nargin == 2
    hObject = gcf;
end

for i = 1:length(tagNames)
    obj = findobj(hObject, 'Tag', tagNames{i});
    
    % Check if this a valid query 
    assert(~isempty(obj), ['Cannot find the obj with tag: ', tagNames{i}]);
    
    set(obj, 'Enable', status);
end

end

