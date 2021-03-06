function p = penetration(varargin)
%% PENETRATION Constructor function for penetration object
% p = penetration(subject,pen_number)

%%
switch nargin
    
%% If no input arguments, create a default object
case 0
    p.subject = subject;
    p.pen_number = [];
    p = class(p,'penetration');
    
%% If single argument of class penetration, return it
case 1
   if (isa(varargin{1},'penetration'))
      p = varargin{1};
   else
      error('Wrong argument type')
   end
   
%% Create object using specified values
case 2
    
    % Check that input 'subject' is formatted correctly
    if isa(varargin{1},'subject')
        p.subject = varargin{1};
    else
        error('Wrong argument type')
    end
    
    % Check that input 'pen_number' is formatted correctly
    p.pen_number = varargin{2};
    if isnumeric(p.pen_number)
        if isreal(p.pen_number)
            if p.pen_number < 0
                error('Argument "pen_number" must be positive or zero')
            end
        else
            error('Argument "pen_number" must be real')
        end
    else
        error('Argument "pen_number" must be numeric')
    end
    
    p = class(p,'penetration');
    
%%
otherwise
   error('Wrong number of input arguments')
end