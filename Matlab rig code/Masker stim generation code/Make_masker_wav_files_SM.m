function Make_masker_wav_files_SM(input_directory,n_rand_repeats,...
                               search_args,masker_args,selectivity_args,...
                               call_args,songfilt_args)
%% Warning: TDT will not support more than 5 sets for the protocol calls...
% if the reperoire of each individual is complete. The sum of the total...
%nb of calls in all the sets can not exceed 1000...
%That is to say :(Always calls * Nb sets + sum(Once calls))<1000.
%% Save wav files for masker/selectivity protocol

%% Set input defaults 
% ! Adapted to Solveig's protocol (filtration based on z.f audiogram, 8 trials per sequence for Call protocol)

if nargin < 7
    songfilt_args = struct('f_low',500,...
                           'f_high',12000,... 
                           'db_att',0);
end

if nargin < 6
   call_args = struct('n_trials',10);
end

if nargin < 5
    selectivity_args = struct('always_n_reps',1,...
                              'new_n_reps',1,...
                              'n_new',3,...
                              'n_trials',10);
end

if nargin < 4
    masker_args = struct('n_trials',8); % A RENTRER DIRECTEMENT DANS L'APPEL DE LA FONCTION !
end

if nargin < 3
    search_args = struct('n_trials',10); % N.b. this number is only for generating the random sequence
end

if nargin < 2
    n_rand_repeats = 10; % Passer � 10 ?
end

if nargin < 1
    input_directory = pwd;
end

%% Get protocol from input directory

% Find stim files and sets
[Outfiles,Stims,WARNING] = load_protocol(input_directory);
if (WARNING(1)==0)
    disp('WARNING: No files for Srch Protocol');
end
if (WARNING(2)==0)
    disp('WARNING: No files for Mask Protocol, Mask/1/stim can not be empty, put silence wav files if you do not need it');
end
if (WARNING(3)==0)
    disp('WARNING: No files for Selectivity Protocol, Sel/always can not be empty, put silence wav files if you do not need it');
end
if (WARNING(4)==0)
    disp('WARNING: No files for Call Protocol, Call/wavfiles_calls can not be empty, put silence wav files if you do not need it');
end

if length(Stims)<4
    return
end

%% Write combined wav files, points and duration files, and protocol

% Write stim.wav and mask.wav files, and points and duration files
[Stims, stim_list,masker_list, call_subjects_list] = make_wav_files_SM(Outfiles,Stims,songfilt_args);
%[stim_list,masker_list,call_subjects_list,Stims] = list_files(Stims);

%% Make sequence files

[n_stims_srch,n_sets_srch] = make_search_sequence(Outfiles,Stims(1),n_rand_repeats,search_args);
[n_stims_mask, n_sets_mask] = make_masker_sequence(Outfiles,Stims(2),n_rand_repeats,masker_args);
[n_stims_sel, n_sets_sel] = make_selectivity_sequence(Outfiles,Stims(3),n_rand_repeats,selectivity_args);
[n_stims_call,n_sets_call, n_totstims_call] = make_call_sequence(Outfiles,Stims(4),n_rand_repeats,call_args,call_subjects_list);

%% Write nstims file
n_stims = [n_stims_srch,n_stims_mask/n_sets_mask,n_stims_sel,n_stims_call]; % !!!! Changed May 10 2012
% n_stims_mask changed to n_stims_mask/n_sets_mask, otherwise doesn't work on TDT.
% THIS ONLY WORKS IF SAME NUMBER OR STIMS IN EACH SET!!!
n_sets = [n_sets_srch,n_sets_mask,n_sets_sel,n_sets_call];
write_n(Outfiles.nstims,n_stims);
write_n(Outfiles.nsets,n_sets);
if length(n_totstims_call)>1 %temporary solution to have the code work with only one set and up to 3 sets for the call protocol
    write_n(Outfiles.nTotStimsCall,[0, n_totstims_call(1), n_totstims_call(2)]);
else
    write_n(Outfiles.nTotStimsCall,[0, n_totstims_call]);
end
if (WARNING(3)==1) && (WARNING(5)==0)
    disp('WARNING: No files in Sometimes for Selectivity Protocol, Matlab and TDT run without them, using only Always files');
end


fprintf('The number of different stimuli used in each protocol is:\n Srch:%d\n Mask: %d\n Selectivity: %d\n Call: %d\t%d\t%d\t%d\t%d\t%d\n',n_stims_srch, n_stims_mask,n_stims_sel,n_stims_call);
fprintf('The number of different sets of stimuli in each protocol is: \n Srch:%d\n Mask: %d\n Selectivity: %d\n Call: %d\n',n_sets_srch,n_sets_mask,n_sets_sel,n_sets_call);
fprintf('DO NOT USE SET VALUES SUPERIOR TO THOSE SPECIFIED ABOVE IN OPEN EX!!!!\n');
fprintf('These values are written in nSets.f32 and nStims.f32\n');
fprintf('You can read the content of these files using the command readf32.m under Matlab\n');
