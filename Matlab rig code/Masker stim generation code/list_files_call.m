function [stim_list,subjects_list,Stims] = list_files_call(Stims)
%% This function uses the file lists of the structure Stims to create
% a new list of all the stims contained in the two sets (stim_list), save
% the indices of the stims in this stim_list under
% Stims.sets(x).stim_indices and create a list of emitters (subjects_list) with their
% attributes (familiar/stranger, sexe and age).

stim_idx = 0;
subj_idx = 0;
stim_list = struct('name',{},'out_name',{});
subjects_list = struct('name',{},'famstra',{},'sex',{},'age',{});
fid = fopen('Birds_list.txt');
BL = textscan(fid, '%s%s%s%s');
fclose(fid);

for jj = 1:length(Stims)
    Stim = Stims(jj);
    
    for kk = 1:length(Stim.sets)
        set = Stim.sets(kk);
        
        % List stims
        n_stims = length(set.stims);
        Stim.sets(kk).stim_indices = stim_idx + (1:n_stims);
        for mm = 1:n_stims
            stim_idx = stim_idx + 1;
            
            stim.name = fullfile(set.dir,set.stims{mm});
            stim.out_name = '';
            stim_list(stim_idx) = stim;
            filename=char(set.stims{mm});
            subj.name = filename(1:10)
            IDX = find(strcmp(BL{1},subj.name));
            subj.famstra = BL{4}(IDX);
            subj.sex = BL{2}(IDX);
            subj.age = BL{3}(IDX);
            if subj_idx == 0
                subj_idx = subj_idx + 1;
                subjects_list(subj_idx) = subj;
            else
                if ~strcmp(subjects_list(subj_idx).name, subj.name)
                    subj_idx = subj_idx + 1;
                    subjects_list(subj_idx) = subj;
                end
            end
        end
            
        
    end
    
    Stims(jj) = Stim;
end