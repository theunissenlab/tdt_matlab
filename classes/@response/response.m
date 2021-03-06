function r = response(varargin)
%% RESPONSE Constructor function for response object
% r = response(responder,presentation)

switch nargin

%% If no input arguments, create a default object
case 0
   r.responder = responder;
   r.presentation = presentation;
   r = class(r,'response');
   
%% If single argument of class asset, return it
case 1
   if (isa(varargin{1},'response'))
      r = varargin{1};
   else
      error('Wrong argument type')
   end 
   
%% Create object using specified values
case 2
    
    % Check that input 'unit' is formulated properly
    if isa(varargin{1},'responder')
        r.responder = varargin{1};
    else
        error('Wrong argument type')
    end
    
    % Check that input 'presentation' is formulated properly
    if isa(varargin{2},'presentation')
        r.presentation = varargin{2};
    else
        error('Wrong argument type')
    end
    
    r = class(r,'response');
    
%%
otherwise
   error('Wrong number of input arguments')
end