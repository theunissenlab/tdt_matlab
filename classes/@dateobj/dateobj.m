function d = dateobj(varargin)
%% DATEOBJ Constructor function for dateobj object
% d = dateobj(day,month,year)

switch nargin

%% If no input arguments, create a default object
case 0
    indate = zeros(1,6);
    
%% If single argument of class time, return it
case 1
    if (isa(varargin{1},'dateobj'))
        d = varargin{1};
        return
        
%% If single argument of class str or numeric, treat it as a Matlab date
% Use the date portion as the date
    elseif ischar(varargin{1}) | isnumeric(varargin{1})
        indate = datevec(varargin{1});
    else
        error('Wrong input argument type');
    end
    
%% For 3 input arguments, treat it as a year-month-day spec
case 3
    indate = [varargin{:},zeros(1,3)];
    
%% For other numbers of arguments, fail    
otherwise
    error('Wrong number of input arguments')
end

%% Create output object

d.day = indate(3);
d.month = indate(2);
d.year = indate(1);
d = class(d,'dateobj');