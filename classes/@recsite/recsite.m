function r = recsite(varargin)
%% RECSITE Constructor function for recsite object
% r = recsite(penetration,depth)
% r = recsite(subject,pen_number,depth)

%%
switch nargin
    
%% If no input arguments, create a default object
case 0
    r.penetration = penetration;
    r.depth = [];
    r = class(r,'recsite');

%% If single argument of class recsite, return it
case 1
   if (isa(varargin{1},'unit'))
      r = varargin{1};
   else
      error('Wrong argument type')
   end
   
%% Parse multiple inputs by creating penetration object
case {2,3}
    % Check that input argument "depth" is formatted correctly
    r.depth = varargin{end};
    if isnumeric(r.depth)
        if ~isreal(r.depth)
            error('Argument "depth" must be a real')
        end
    else
        error('Argument "depth" must be numeric');
    end
    
    % Create object using input penetration object
    if nargin == 2 
        if isa(varargin{1},'penetration')
            r.penetration = varargin{1};
        else
            error('Wrong argument type')
        end
        
    % Create penetration from inputs
    else
        r.penetration = penetration(varargin{2},varargin{3});
    end
    
    r = class(r,'recsite');
otherwise
   error('Wrong number of input arguments')
end