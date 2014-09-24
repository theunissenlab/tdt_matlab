function [stim_list,masker_list,subjects_list, Stims] = list_files(Stims)

stim_idx = 0;
mask_idx = 0;
subj_idx = 1;
stim_list = struct('name',{},'md5',{},'out_name',{},'out_md5',{});
subjects_list = struct('name',{},'cat',{},'calls_idx',{});
masker_list = stim_list;

for jj = 1:length(Stims)
    Stim = Stims(jj);
    
    for kk = 1:length(Stim.sets)
        set = Stim.sets(kk);
        
        % Check if we need further subdirectories
        if isfield(set,'maskers') && exist(fullfile(set.dir,'stim'))
            set_dir = fullfile(set.dir,'stim');
        else
            set_dir = set.dir;
        end
        
        % List stims
        n_stims = length(set.stims);
        Stim.sets(kk).stim_indices = stim_idx + (1:n_stims);
        sum_nb_calls = 0;
        Snb_calls = 0;
        for mm = 1:n_stims
            stim_idx = stim_idx + 1;
            stim.name = fullfile(set_dir,set.stims{mm});
            stim.md5 = '';
            stim.out_name = '';
            stim.out_md5 = '';
            stim_list(stim_idx) = stim;
            if jj == 4 && kk==2 %if we are dealing with Once call stim then construct a list of the subjects name, sex number of file...
                filename=char(set.stims{mm});
                subj.name = filename(1:10);
                subj.cat = filename(12:14);
                %subj.firstidx = stim_idx;
                Snb_calls = Snb_calls + 1;
                if subj_idx == 1;
                    subj.calls_idx = {};
                    subjects_list(subj_idx) = subj;
                    subj_idx = subj_idx + 1;
                
                elseif mm==n_stims
                    FirstIdx = stim_idx - (Snb_calls-1);
                    if ~strcmp(subjects_list(subj_idx-1).name, subj.name)
                        subjects_list(subj_idx-1).calls_idx = (FirstIdx : stim_idx-1);
                        Snb_calls = 1;
                        subj.calls_idx = ((FirstIdx+1) : stim_idx);
                        subjects_list(subj_idx) = subj;
                    else
                        subjects_list(subj_idx-1).calls_idx = (FirstIdx : stim_idx);
                    end
                        
                        
                elseif ~strcmp(subjects_list(subj_idx-1).name, subj.name)
                    %sum_nb_calls = sum_nb_calls + subjects_list(subj_idx).nb_calls;
                    FirstIdx = stim_idx - (Snb_calls-1);
                    subjects_list(subj_idx-1).calls_idx = (FirstIdx : stim_idx-1);
                    Snb_calls = 1;
                    subj.calls_idx = {};
                    subjects_list(subj_idx) = subj;
                    subj_idx = subj_idx + 1;
                end
            end
        end
            
        % List maskers if needed
        if isfield(set,'maskers')
            set_dir = fullfile(set.dir,'masker');
            n_maskers = length(set.maskers);
            Stim.sets(kk).mask_indices = mask_idx + (1:n_maskers);
            for mm = 1:n_maskers
                mask_idx = mask_idx + 1;
                masker.name = fullfile(set_dir,set.maskers{mm});
                masker.md5 = '';
                masker.out_name = '';
                masker.out_md5 = '';
                masker_list(mask_idx) = masker;
            end
        end
    end
    
    Stims(jj) = Stim;
end