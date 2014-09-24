function s = block_spikes(varargin)
%% BLOCK_SPIKE Constructor function for block_spike object
% s = spike(time,channel,sortcode,waveform)

% Class specification
classname = 'spike';
fieldspec = {'name'         'class'         'notnull'   'default'   'subscripts'};
classspec = {...
            'time'          'char'          true        '';...
            'channel'       'double'        true        1;...
            'sortcode'      'double'        false       0;...
            'waveform'      'double'        false       0,...
    };
classspec = cell2struct(classspec,fieldspec,2);
nfields = length(classspec);

switch nargin

%% If no input arguments, create a default object

case 0
    for jj = 1:nfields
        
        % For some reason, calling numeric constructors requires an argument even if
        % it's null
        if isnum_class(classspec(jj).class)
            s.(classspec(jj).name) = eval([classspec(jj).class,'([])']);
        else
            s.(classspec(jj).name) = eval(classspec(jj).class);
        end
    end
    
%% If single argument of class epoc, return it
case 1
   if (isa(varargin{1},classname))
        s = varargin{1};
        return
   else
      error('Wrong argument type')
   end
   
%% Use input session
case num2cell(2:nfields)
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
                s.(classspec(jj).name) = val;
                
            % Recast if needed
            elseif isnumeric(val)
                warning('ClassDef:InputType',...
                    'Recasting input "%s" as class "%s"',...
                    classspec(jj).name,classspec(jj).class);
                val = eval([classspec(jj).class,...
                    '(val);']);                
            else
                error('ClassDef:InputType',...
                    'Input "%s" should be of class "%s"',...
                    classspec(jj).name,classspec(jj).class);
            end
            
            % Distribute values to subscripts if needed
            if classspec(jj).subscripts
                val = num2cell(val);
                nvals = length(val);
                [e(1:nvals).(classspec(jj).name)] = deal(val{:});
            else
                s.(classspec(jj).name) = val;
            end
            
        else
            %val = repmat(classspec(jj).default,size(s.time));
            s.(classspec(jj).name) = cast(classspec(jj).default,...
                classspec(jj).class);
        end
    end
%%
otherwise
   error('Wrong number of input arguments')
end

%% Create output object
e = class(e,'epoc');