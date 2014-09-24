function [nstims,ntrials,msg,stim_indices,stim_epocs,silence_epocs] = ...
    get_blockdata(actxname,tankname,blockname,maxsweep);

% Connect to the server, select tank and block
block_access;

% Get epoc information
actxname.ClearEpocIndexing;      %Just to be safe
actxname.CreateEpocIndexing;     %Epoch indexing must be set before filtering
% sweep_epocs = actxname.GetEpocsV('Swep',0,0,maxsweep);     
stim_epocs = actxname.GetEpocsV('Frq+',0,0,maxsweep);
silence_epocs.pre = actxname.GetEpocsV('Pre+',0,0,maxsweep);
silence_epocs.post = actxname.GetEpocsV('Pos+',0,0,maxsweep);
msg = check_timestamps(stim_epocs,'Frq+');     %Check that epoc timestamps are sensible
msg = strvcat(msg,check_timestamps(silence_epocs.pre,'Pre+'));
msg = strvcat(msg,check_timestamps(silence_epocs.post,'Pos+'));
actxname.ReleaseServer;

% Compute the number of trials and stimuli
stim_numbers = stim_epocs(1,:);          %stim numbers are in first row of stim_epocs
[nstims,ntrials,stim_indices,msg1] = stim_trial_numbers(stim_numbers,0);
% [nstims,ntrials,stim_indices,msg2] = stim_trial_numbers(stim_epocs(1,:),0);

% Removed this block to streamline error handling RCM 2/27/06
%% Create an error message, giving msg1 priority
%if isempty(msg1)
%    if isempty(msg2)
%        msg = '';
%    else
%        msg = msg2;
%    end
%else
%    msg = msg1;
%end

msg = strvcat(msg,msg1);