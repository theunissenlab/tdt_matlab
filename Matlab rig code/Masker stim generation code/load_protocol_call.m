function [Outpath,Stims] = load_protocol_call(input_dir)
%% Find stim files and sets. Create a structure that contains 2 sets (Stims.sets), one
% for vocalizations from stranger birds (Stims.sets(2)) and another for vocalizations from
% familiar birds (Stims.sets(1)). Each set list the file names in stims
% (eg. Stims.sets(1).stims).

%% Read in files from calls

Call = struct;
Call.name = 'Call';
Call.dir = fullfile(input_dir,Call.name);
Outpath = Call.dir;
Call.sets = struct('name',{},'dir',{},'stims',{});

% Get familiar stims
familiar = struct;
familiar.name = 'Familiar';
familiar.dir = fullfile(Call.dir,familiar.name);
wav_files = dir(fullfile(familiar.dir,'*.wav'));
familiar.stims = {wav_files.name};
Call.sets(1) = familiar;


% Get stranger stims
stranger = struct;
stranger.name = 'Stranger';
stranger.dir = fullfile(Call.dir,stranger.name);
wav_files = dir(fullfile(stranger.dir,'*.wav'));
stranger.stims = {wav_files.name};
Call.sets(2) = stranger;


%% Return sets
Stims = Call;
