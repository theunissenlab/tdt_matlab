function [Stims,stim_list, subjects_list] = Make_wav_files_call(Outpath,Stims,...
                                                        songfilt_args)
                                                        
% Defaults for songfilt arguments
if nargin < 3
    songfilt_args.f_low = 250;
    songfilt_args.f_high = 12000;
    songfilt_args.db_att = 0;
end

%% Compile stims into lists. This function uses the file lists of the
% structure Stims to create a new list of all the stims contained in the
% two sets (stim_list), save the indices of the stims in this stim_list under
% Stims.sets(x).stim_indices and create a list of emitters (subjects_list) with their
% attributes (familiar/stranger, sexe and age).
[stim_list, subjects_list, Stims] = list_files_call(Stims);

%% Write lists to wav files and make sequences of three calls for tet, DC, Thuck...
% LTC, for each individual in each directory Familiar and stranger
stim_list = write_wav_file_call(Outpath,stim_list, subjects_list,...
                           songfilt_args);

