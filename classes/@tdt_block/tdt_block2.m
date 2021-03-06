function t = tdt_block(varargin)
%% TDT_BLOCK Constructor function for tdt_block object
% b = tdt_block(session,blocknumber,starttime,protocol,channelmap,experimenter,blockname,tankname)
% b = tdt_block(blockname,tank)

% Class specification
fieldspec = {'name'         'class'         'notnull'   'default'};
classspec = {...
            'name'          'char'          true        '';...
            'tank'          'tank'          true        []...
    };
classspec = cell2struct(classspec,fieldspec,2);
nfields = length(classspec);

switch nargin

%% If no input arguments, create a default object
case 0
    for jj = 1:nfields
        
        % For some reason, calling 'int32' requires an argument even if
        % it's null
        if strncmp(classspec(jj).class,'int',3)
            t.(classspec(jj).name) = eval([classspec(jj).class,'([])']);
        else
            t.(classspec(jj).name) = eval(classspec(jj).class);
        end
    end
    
%% If single argument of class block, return it
case 1
   if (isa(varargin{1},'tdt_block'))
        t = varargin{1};
        return
   else
      error('Wrong argument type')
   end
   
%% If two inputs, use session input
case 2
    % Determine which inputs go where
    assigned = [classspec.notnull];
    n_notnull = sum([classspec.notnull]);
    n_extra = nargin-n_notnull;
    if n_extra < 0
        error('Not enough input arguments')
    elseif n_extra > 0
        % Assign earlier optional variables enough
        assigned(find(~assigned,extra,'first')) = true;
    end

    % Assign field values
    for jj = 1:nfields
        if assigned(jj)
            input_idx = sum(assigned(1:jj));
            val = varargin{input_idx};
            
            % Check input type
            if isa(val,classspec(jj).class)
                t.(classspec(jj).name) = val;
                
            % Recast if needed
            elseif isnumeric(val)
                warning('ClassDef:InputType',...
                    'Recasting input "%s" as class "%s"',...
                    classspec(jj).name,classspec(jj).class);
                t.(classspec(jj).name) = eval([classspec(jj).class,...
                    '(val);']);
            else
                error('ClassDef:InputType',...
                    'Input "%s" must be of class "%s"',...
                    classspec(jj).name,classspec(jj).class);
            end
        else
            t.(classspec(jj).name) = cast(classspec(jj).default,...
                classspec(jj).class);
        end
    end

%% Error for wrong number of inputs  
otherwise
   error('Wrong number of input arguments')
end

%% Create output object
t = class(t,'tdt_block');