function switchComp(tagNames, status)
%SWITCH Switch gui component on or off 

for i = 1:length(tagNames)
    obj = findobj('Tag', tagNames{i});
    
    % Check if this a valid query 
    assert(~isempty(obj), ['Cannot find the obj with tag: ', tagNames{i}]);
    
    set(obj, 'Enable', status);
end

end

