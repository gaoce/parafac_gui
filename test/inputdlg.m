function answer = inputdlg(varargin)
%INPUTDLG mock function for inputdlg

persistent ANSWER;

% If the function is primed?
flagPrime = 0;
for i = 1:nargin
    if strcmp(varargin{i}, 'expOut')
        ANSWER = varargin{i+1};
        flagPrime = 1;
    end
end

if flagPrime == 0
    answer = ANSWER;
end

end

