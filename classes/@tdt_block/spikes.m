function s = spikes(b,sort_name)
%% Get spikes from a tdt_block object by querying tank server

global ttank

access(b);

ttank.ResetGlobals;
ttank.ResetFilters;

% Set sort name if any
if nargin >1
    ttank.SetUseSortName(sort_name);
end

channel = 0;        % Get spikes from all channels
sortcode = 0;       % Get spikes with any sortcode
start_time = 0;     % Start at beginning of block
stop_time = 0;      % Go to end of block

possible_spike_stores = {'Spik','Snip','EA__'};
nspikes = 0;
for jj = 1:length(possible_spike_stores)
	nspikes = ttank.ReadEventsV(10000000,possible_spike_stores{jj},...
		channel,sortcode,start_time,stop_time,'ALL');
	if nspikes > 0
		s.time = ttank.ParseEvInfoV(0,nspikes,6);
		s.sortcodes = ttank.ParseEvInfoV(0,nspikes,5);
		s.channels = ttank.ParseEvInfoV(0,nspikes,4);
		s.waveform = ttank.ParseEvV(0,nspikes);
		s = spike(s.time,s.channels,s.sortcodes,s.waveform);
        ttank.ResetGlobals;
        ttank.ResetFilters;
		ttank.ReleaseServer;
		return
	end
end

%added so that we can still export days without ephys recordings (and thus
%without spikes--RG3
s.time = 0;
s.sortcodes=0;
s.channels=0;
s.waveform=0;
s=spike(s.time,s.channels,s.sortcodes,s.waveform);
disp('No spike stores found');
% error('No spike stores found')