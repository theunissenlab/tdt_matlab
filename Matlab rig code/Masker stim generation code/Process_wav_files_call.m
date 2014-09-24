function Process_wav_files_call(input_directory,songfilt_args)
                               
%% Create combination of .wav files to obtain triplets or unique...
% vocalization in each output .wav file depending on the vocalization type
% (song, distress call, distance call...). Each song, distress calls, Aggressive
% calls and begging seuquences will be just filtered, smoothed at the
% begining and end and renamed under a new .wav file. For thuck calls,
% distance calls, tet calls, nest calls and whines the program make
% triplets of calls within each category after filtering and smoothing each
% element.
% Warning: the code rely on the name of the file to find out the
% vocalization category and the emitter name, and on a Birds_list.txt file to find out the sex,...
% age and status (familiar/stranger) of each emitter. Your input files have...
% to be named as follows: ColColXXXX_YYMMDD-TY*.wav with Col the band color...
% of your bird, XX the band numbers, YYMMDD the date of recording for
% instance and TY the type of vocalization (Ag: Aggressive call, Be:
% Begging, DC: Distance call, Di: Distress call, LT: Long Tonal call, Ne:
% Nest call, So: Song, Te: tet call, Th: Thuck call, Wh: Whines).

%% Set input defaults

if nargin < 2
    songfilt_args = struct('f_low',250,...
                           'f_high',12000,...
                           'db_att',0);
end

if nargin < 1
    input_directory = pwd;
end

%% Get protocol from input directory

% Find stim files and sets. Create a structure that contains 2 sets (Stims.sets), one
% for vocalizations from stranger birds (Stims.sets(2)) and another for vocalizations from
% familiar birds (Stims.sets(1)). Each set list the file names in stims
% (eg. Stims.sets(1).stims).
[Outpath,Stims] = load_protocol_call(input_directory);

%% Write combined wav files

% Write wav files for all calls, either individual or triple calls file
% depending on the type of call
[Stims,stim_list, subjects_list] = Make_wav_files_call(Outpath,Stims,songfilt_args);
display(stim_list);
display(subjects_list);
