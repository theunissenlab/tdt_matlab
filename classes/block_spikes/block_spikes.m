function s = block_spikes(varargin)
%% BLOCK_SPIKE Constructor function for block_spike object
% e = epoc(block,epoc_name,starttime,endtime)

% Class specification
fieldspec = {'name'         'class'         'notnull'   'default'};
classspec = {...
            'tdt_block'     'tdt_block'     true        [];...
            'time'          'double'        true        '';...
            'channel'       'double'        true        1;...
            'sortcode'      'double'        true        0;...
            'waveform'      'double'        false       0,...
    };
classspec = cell2struct(classspec,fieldspec,2);
nfields = length(classspec);

global ttank

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
    
%% If single argument of class block_spikes, return it
case 1
    switch class(varargin{1})
    case 'block_spikes'
        s = varargin{1};
        return
        
%% If single argument of class 'tdt_block', get the spikes from the block
    case 'tdt_block'
        b = varargin{1};
        access(b);
        
        channel = 0;        % Get spikes from all channels
        sortcode = 0;       % Get spikes with any sortcode
        start_time = 0;     % Start at beginning of block
        stop_time = 0;      % Go to end of block

        nspikes = ttank.ReadEventsV(10000000,'Spik',channel,sortcode,start_time,...
            stop_time,'ALL');
        s.time = ttank.ParseEvInfoV(0,nspikes,6);
        s.sortcodes = ttank.ParseEvInfoV(0,nspikes,5);
        s.channels = ttank.ParseEvInfoV(0,nspikes,4);
        s.waveform = ttank.ParseEvV(0,nspikes);
        ttank.ReleaseServer;
    otherwise
        error('Wrong argument type')
    end

%%
otherwise
   error('Too many input arguments')
end

%% Create output object
s = class(s,'block_spikes');