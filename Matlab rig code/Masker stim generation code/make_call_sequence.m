function [n_call,n_sets,n_totCalls] = make_call_sequence(Outfiles,Call,n_rand_repeats,args,call_subjects_list)

%%Find out sex and age of subjects
% Sex, age and status of subjects are contained in filenames.

%%Find out how many complete sets of stim I can have with each set
%%containing the repertoire of 2 familiar male (MAF), 2 fam female (FAF), 1 stra Male (MAS),
%%1 stra Female (FAS), 2 chick male (MCS), 2 chick female (FCS).
%% Always individual: BlaBla0506(MAF), WhiBlu4917(FAF), LblBlu2028(MCS), LblBlu1630(FCS)

%%Select at random one individual from each category and create random
%%sequences from their call indices. Loop through the maximum number of
%%possible sets. Do not use twice the same individual.

%%write sequence for call files
l_sets = length(Call.sets);
if l_sets>1
    fid_OnceName=fopen('OnceEmitterNames.txt','w');
    fprintf(fid_OnceName,'SetNb\tOnceEmitter\tNbStim\n');
    Always = Call.sets(1);
    Categ = zeros(length(call_subjects_list), 6); %initializing the Matrix that recap the number of MAF FAF MAS FAS MCS and FCS emitters
    for ss = 1:length(call_subjects_list)% I have to figure out how many MAF FAF MAS FAS MCS and FCS I have in this set
        catg = call_subjects_list(ss).cat;
        if strcmp(catg, 'MAF')
            Categ(ss,1) = 1;
        elseif strcmp(catg, 'FAF')
            Categ(ss,2) = 1;
        elseif strcmp(catg, 'MAS')
            Categ(ss,3) = 1;
        elseif strcmp(catg, 'FAS')
            Categ(ss,4) = 1;
        elseif strcmp(catg, 'MCS')
            Categ(ss,5) = 1;
        elseif strcmp(catg,'FCS')
            Categ(ss,6)=1;
        end
    end
    n_sets = min(sum(Categ));
    set_seqs = cell(1,n_sets);
    n_call = zeros(1,n_sets);
    MAFlist = randperm(sum(Categ(:,1)));
    FAFlist = randperm(sum(Categ(:,2)));
    MASlist = randperm(sum(Categ(:,3)));
    FASlist = randperm(sum(Categ(:,4)));
    MCSlist = randperm(sum(Categ(:,5)));
    FCSlist = randperm(sum(Categ(:,6)));
    
    
    for set_idx = 1:n_sets
        % Get indices for MAF stims
        MAFIdx = find(Categ(:,1));
        MAFIndices = call_subjects_list(MAFIdx(MAFlist(set_idx))).calls_idx;
        MAFName = call_subjects_list(MAFIdx(MAFlist(set_idx))).name;
        fprintf(fid_OnceName,'%d\t%s\t%d\n', set_idx, MAFName, length(MAFIndices));
        
        %Get indices for FAF stims
        FAFIdx = find(Categ(:,2));
        FAFIndices = call_subjects_list(FAFIdx(FAFlist(set_idx))).calls_idx;
        FAFName = call_subjects_list(FAFIdx(FAFlist(set_idx))).name;
        fprintf(fid_OnceName,'%d\t%s\t%d\n', set_idx, FAFName, length(FAFIndices));
        
        %Get indices for MAS stims
        MASIdx = find(Categ(:,3));
        MASIndices = call_subjects_list(MASIdx(MASlist(set_idx))).calls_idx;
        MASName = call_subjects_list(MASIdx(MASlist(set_idx))).name;
        fprintf(fid_OnceName,'%d\t%s\t%d\n', set_idx, MASName, length(MASIndices));
        
        %Get indices for FAS stims
        FASIdx = find(Categ(:,4));
        FASIndices = call_subjects_list(FASIdx(FASlist(set_idx))).calls_idx;
        FASName = call_subjects_list(FASIdx(FASlist(set_idx))).name;
        fprintf(fid_OnceName,'%d\t%s\t%d\n', set_idx, FASName, length(FASIndices));
        
        %Get indices for MCS stims
        MCSIdx = find(Categ(:,5));
        MCSIndices = call_subjects_list(MCSIdx(MCSlist(set_idx))).calls_idx;
        MCSName = call_subjects_list(MCSIdx(MCSlist(set_idx))).name;
        fprintf(fid_OnceName,'%d\t%s\t%d\n', set_idx, MCSName, length(MCSIndices));
        
        %Get indices for FCS stims
        FCSIdx = find(Categ(:,6));
        FCSIndices = call_subjects_list(FCSIdx(FCSlist(set_idx))).calls_idx;
        FCSName = call_subjects_list(FCSIdx(FCSlist(set_idx))).name;
        fprintf(fid_OnceName,'%d\t%s\t%d\n', set_idx, FCSName, length(FCSIndices));
        
        %Combine Once and always indices
        indices = [Always.stim_indices,MAFIndices, FAFIndices, MASIndices,FASIndices,MCSIndices,FCSIndices];

        % Make random sequences for this
        set_seqs{set_idx} = random_sequence(indices,args.n_trials,n_rand_repeats);
        n_call(set_idx) = length(indices);
        
    end
    sequence = horzcat(set_seqs{:});
    fclose(fid_OnceName);
else
    Always = Call.sets(1);
    sequence = random_sequence(Always.stim_indices,args.n_trials,n_rand_repeats);
    n_call = length(Always.stim_indices);
    n_sets = l_sets;
end
n_totCalls = cumsum(n_call);
%% Write to file

fid = fopen(Outfiles.callseq,'w');
fwrite(fid,sequence,'int32');
fclose(fid);

