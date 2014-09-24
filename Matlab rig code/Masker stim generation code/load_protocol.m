function [Outfiles,Stims,WARNING] = load_protocol(input_dir)


%% Construct output structures
Subject_name = input('What''s the subject name?', 's');

% Construct Outfiles struct. This structure contains the name of the output
% files that will be created and used by the code.
Outfiles.stimwav = fullfile(input_dir,'stim.wav');
Outfiles.maskwav = fullfile(input_dir,'mask.wav');
Outfiles.protocol = fullfile(input_dir,sprintf('protocol_%s.txt', Subject_name));
Outfiles.setnumbers = fullfile(input_dir,'setnumbers.txt');
Outfiles.wavpts = fullfile(input_dir,'wavpts.txt');
Outfiles.wavptsstart = fullfile(input_dir,'wavptsstart.txt');
Outfiles.nstims = fullfile(input_dir,'nStims.f32');
Outfiles.nsets = fullfile(input_dir,'nSets.f32');
Outfiles.nTotStimsCall = fullfile(input_dir, 'nTotStimsCall.f32');
Outfiles.searchseq = fullfile(input_dir,'srchseq.f32');
Outfiles.maskstimseq = fullfile(input_dir,'maskstimseq.f32');
Outfiles.maskseq = fullfile(input_dir,'maskseq.f32');
Outfiles.selseq = fullfile(input_dir,'selseq.f32');
Outfiles.callseq = fullfile(input_dir,'callseq.f32');

%% Read in files from srch

Srch = struct;
Srch.name = 'Srch';
Srch.dir = fullfile(input_dir,Srch.name);

% Get list of wav files in this directory
set = struct;
set.dir = Srch.dir;
wavfiles = dir(fullfile(Srch.dir,'*.wav'));
set.stims = {wavfiles.name};
Srch_exist=(~isempty(set.stims));

% Put set into Srch struct
Srch.sets = set;

%% Read in files from mask

Mask = struct;
Mask.name = 'Mask';
Mask.dir = fullfile(input_dir,Mask.name);
Mask.sets = struct('dir',{},'stims',{},'maskers',{});

% Get list of directory and find subdirectories
dirlist = dir(Mask.dir);
is_subdir = [dirlist.isdir] & ~strncmpi('.',{dirlist.name},1);
names = {dirlist(is_subdir).name};
n_subdir = length(names);
if n_subdir ~=0
    
    % Make subsets
    for jj = 1:n_subdir
        set.dir = fullfile(Mask.dir,names{jj});
    
        % Get stims
        stim_dir = fullfile(set.dir,'stim');
        wav_files = dir(fullfile(stim_dir,'*.wav'));
        set.stims = {wav_files.name};
        
        % Get maskers
        mask_dir = fullfile(set.dir,'masker');
        wav_files = dir(fullfile(mask_dir,'*.wav'));
        set.maskers = {wav_files.name};
    
        Mask.sets(jj) = set;
    end
    set = Mask.sets(1);
    Mask_exist = (~isempty(set.stims));
else
    Mask_exist = 0;
end

%% Read in files from selectivity

Sel = struct;
Sel.name = 'Sel';
Sel.dir = fullfile(input_dir,Sel.name);
Sel.sets = struct('name',{},'dir',{},'stims',{});

dirlist = dir(Sel.dir);
is_subdir = [dirlist.isdir] & ~strncmpi('.',{dirlist.name},1);
names = {dirlist(is_subdir).name};
n_subdir = length(names);

if n_subdir ~=0

    % Get always stims
    always = struct;
    always.name = 'always';
    always.dir = fullfile(Sel.dir,always.name);
    wav_files = dir(fullfile(always.dir,'*.wav'));
    always.stims = {wav_files.name};
    Sel_always_exist = (~isempty(always.stims));
    Sel_exist = Sel_always_exist;
    Sel.sets(1) = always;

    % Get sometimes stims
    sometimes = struct;
    sometimes.name = 'sometimes';
    sometimes.dir = fullfile(Sel.dir,sometimes.name);
    wav_files = dir(fullfile(sometimes.dir,'*.wav'));
    sometimes.stims = {wav_files.name};
    Sel_sometimes_exist = (~isempty(sometimes.stims));
    if Sel_sometimes_exist ~=0
        Sel.sets(2) = sometimes;
    end
else
    Sel_exist = 0;
end

%% Read in files from Call

Call = struct;
Call.name = 'Call';
Call.dir = fullfile(input_dir,Call.name);
Call.sets = struct('name',{},'dir',{},'stims',{});

dirlist = dir(Call.dir);
is_subdir = [dirlist.isdir] & ~strncmpi('.',{dirlist.name},1);
names = {dirlist(is_subdir).name};
n_subdir = length(names);

if n_subdir ~=0

    % Get processed call stims that will be presented to all recording
    % sites
    Process_calls_A = struct;
    Process_calls_A.name = 'wavfiles_calls_Always';
    Process_calls_A.dir = fullfile(Call.dir,Process_calls_A.name);
    wav_files = dir(fullfile(Process_calls_A.dir,'*.wav'));
    Process_calls_A.stims = {wav_files.name};
    Call_exist_A = (~isempty(Process_calls_A.stims));
    Call_exist = Call_exist_A;
    Call.sets(1) = Process_calls_A;

    % Get processed call stims that will be presented only once
    Process_calls_O = struct;
    Process_calls_O.name = 'wavfiles_calls_Once';
    Process_calls_O.dir = fullfile(Call.dir,Process_calls_O.name);
    wav_files = dir(fullfile(Process_calls_O.dir,'*.wav'));
    Process_calls_O.stims = {wav_files.name};
    Call_exist_O = (~isempty(Process_calls_O.stims));
    if Call_exist_O ~=0
        Call.sets(2) = Process_calls_O;
    end
else
    Call_exist = 0;
end
    

%% Return sets
WARNING=[Srch_exist,Mask_exist,Sel_exist,Call_exist,Sel_sometimes_exist];


if (Srch_exist==1) && (Mask_exist==1) && (Sel_exist==1) && (Call_exist==1)
    Stims = [Srch;Mask;Sel;Call];
end

