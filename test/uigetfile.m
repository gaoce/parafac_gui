function [filename, pathname, filterindex] = uigetfile(varargin)
%UIGETFILE a mock function for uigetfile

persistent FILENAME PATHNAME;

% If the function is primed?
flagPrime = 0;
for i = 1:nargin
    if strcmp(varargin{i}, 'expOut')
        FILENAME = varargin{i+1}{1};
        PATHNAME = varargin{i+1}{2};
        flagPrime = 1;
    end
end

% Expect to work
if flagPrime == 0
    filename = FILENAME;
    pathname = PATHNAME;
    filterindex = 1;
end

end

