function file_list = write_wav_file_call(Outpath,file_list,subjects_list,...
                                     songfilt_args)

%% Write one .wav file for each wav file in file_list
% Includes resampling, rescaling, and writes index files as well.

%% Defaults & preprocessing
% create a txt files that keep tracks of ancient wav files and new wav
% files and the way they were compiled
Todaytime = fix(clock);
filenametxt = sprintf('WavTracker_%d%2d%2d_%2d%2d.txt', Todaytime(1), Todaytime(2), Todaytime(3),Todaytime(4),Todaytime(5));
filenametxt = regexprep(filenametxt, ' ','0');
fid_out = fopen(fullfile(Outpath, filenametxt), 'wt');
fprintf(fid_out, 'This file keep track of which wav files were used to construct output wav files (stims)\n');
% set the seed of rand
rand('state',sum(100*clock))

% Number of files
nfiles = length(file_list);

% Number of subjects
NInd = length(subjects_list);
NFInd = length(find(strcmp('F',[subjects_list.famstra])));
NSInd = length(find(strcmp('S',[subjects_list.famstra])));

% Exact sampling frequency for the TDT
%tdt25k = 24414.0625;
Fout = tdt25k;

% Directory to save the resampled, gated wavfiles
%wav_outdirF = 'wavfiles_Familiar_calls';
%wav_outdirS = 'wavfiles_Stranger_calls';
wav_outdir = 'wavfiles_calls';

% Apply 2ms cosine ramp to apply to each end of the stims
%ramp_dur = 10e-3;
ramp_dur_call= 2e-3;

% Directory for individual output files
%wav_pathF = fullfile(Outpath,wav_outdirF);
%fiatdir(wav_pathF);
%wav_pathS = fullfile(Outpath,wav_outdirS);
%fiatdir(wav_pathS);
wav_path = fullfile(Outpath,wav_outdir);
fiatdir(wav_path);


if nargin < 4
    songfilt_args.f_low = 250;
    songfilt_args.f_high = 12000;
    songfilt_args.db_att = 0;
end

%% Finds out the number of individuals and initializes a cell array for
%wav data of each individual and each call type. Filtered wave files will
%be placed in this structure before being compiled and written to files.

Calls_wav = struct;
Calls_wav.sets = struct ('name',{},'famstra',{},'sex',{},'age',{},'waves',{});


 for ii = 1:NInd
     fprintf('processing individual %d\n',ii);
     set = struct;
     set.name = subjects_list(ii).name;
     set.famstra = subjects_list(ii).famstra;
     set.sex = subjects_list(ii).sex;
     set.age = subjects_list(ii).age;
     set.waves = struct ('callname',{},'voc',{},'infilename',{});
     for jj = 1:11
         calltype = ['Ag', 'Be', 'DC', 'Di', 'LT', 'Ne', 'Ri', 'So', 'Te', 'Th','Wh'];
         wave = struct;
         wave.callname = calltype ((2*jj-1):(2*jj));
         wave.voc = cell(1,1);
         wave.infilename = cell(1,1);
         set.waves (jj) = wave;
     end
     Calls_wav.sets(ii) = set;
 end
 


%% Read in all file
for jj = 1:nfiles
        
    % Prefix for individual output files
    infilename = file_list(jj).name;
    [path,filename,fileext] = fileparts(infilename);
    call_type = filename(19:20); %define call type either Ag,Be,DC,Di,LT,Ne,Ri,So,Te,Th or Wh)

    
    % Apply songfilt_call to vocalization (Notes: the wave is first
    % converted from stereo to mono; songfilt_call normalizes the sound
    % pressure level within each vocalization category but keeps
    % differences of sound levels between vocalization categories.
    [y,Fin,bits] = wavread(infilename);
    if length(y(1,:))>1
        y = (y(:,1) + y(:,2))/2; %convert stereo to mono
    end
    y = songfilt_call(y,Fin,songfilt_args.f_low,songfilt_args.f_high,...
                 songfilt_args.db_att, call_type);

    
    %display name
    disp(infilename);

    
    % Resample
    [p,q] = rat(Fout/Fin,0.0000001);
    y = resample(y,p,q);        %Resample to TDT sampling rate (24.4140625kHz)

    % Equalize
    %y = y-mean(y);              %Subtract mean
    %rmslev = std(y);            %Compute RMS level
    %y = 0.05*y/rmslev;          %Rescale so RMS is 0.05 of max (i.e. 1)

    % Apply 2ms cosine ramp to each end
    y = cosramp(y,ramp_dur_call * Fout);

    % Alert if there is any clipping
    maxnew = max(y);
    minnew = min(y);
    if maxnew > 1.0 || minnew < -1.0
        disp(sprintf('Clipping: Max = %5.2f Min = %5.2f  \r',...
            maxnew,minnew));
    end
    
    
    
    % Write individual stims to Calls_wav structure, classsified according..
    % to birds name and types of calls in file_list
    %direc = regexp(path, '/' , 'split');
    %directory = direc{end};
    %if strcmp(directory , 'Familiar')
        for ii=1:NInd
            set = Calls_wav.sets(ii);
            if filename(1:10) == set.name
                for kk=1:length(set.waves)
                    wave = set.waves(kk);
                    
                    if call_type == wave.callname
                        if isempty(wave.voc{1})
                            n=0;
                        else
                           n=length(wave.voc);
                        end
                       wave.voc{n+1}=y;
                       wave.infilename{n+1} = filename;
                      
                    end
                 
                    set.waves(kk)=wave;
                 end  
            end
            Calls_wav.sets(ii)=set;
         end
            
    %end
        
end

%% Write individual vocalization (Ag, Be, Di, So, Ri) to individual wav
%%files and compile other vocalizations (te, DC, LT, Th,Wh) by groups of three
%%in wav files.

fprintf(fid_out, 'new wav file stim -> ancient wav files used and interval in sec between files when compiled\n');
NN=0;
randpath = fullfile(toolboxdir('matlab'),'randfun');
addpath(randpath);
    for ii=1:NInd
        set =  Calls_wav.sets(ii);
        IndName = set.name;
        IndStat = cell2mat(set.famstra);
        IndAge = cell2mat(set.age);
        IndSex = cell2mat(set.sex);
        for jj=1:length(set.waves)
            wave = set.waves(jj);
            if strcmp(wave.callname,'So') || strcmp(wave.callname,'Ag') ||...
                    strcmp(wave.callname,'Be') || strcmp(wave.callname,'Di') ||...
                    strcmp(wave.callname,'Ri')
                typecall=wave.callname;
                voc=wave.voc;
                wavein = wave.infilename;
                nvoc=length(voc(1,:));
                if nvoc>1
                    for kk=1:nvoc
                        wavoutname = sprintf('%s_%s%s%s_%s_%d.wav',IndName,IndSex,IndAge,IndStat,typecall,(kk-1));
                        wav_outfile = fullfile(wav_path,wavoutname);
                        wavwrite(voc{kk},Fout,bits,wav_outfile);
                        NN=NN+1;
                        file_list(NN).out_name = wav_outfile;
                        fprintf(fid_out, '\n%s -> %s\n', wavoutname, wavein{kk});
                    end
                end
            else
                typecall=wave.callname;
                voc=wave.voc;
                wavein = wave.infilename;
                nvoc=length(voc(1,:));
                if nvoc>1
                    idx = floor((nvoc)/3);
                    randlist = randperm(nvoc);
                    for set_idx = 1:idx
                        order = randlist((set_idx-1)*3 + (1:3));
                        Le = Fout*2.5 - length(voc{order(1)}) - length(voc{order(2)}) - length(voc{order(3)});
                        S1=floor(rand*Le/3);
                        S2=floor(rand*Le/3);
                        S3= floor(Le-S2-S1);
                        IC1=zeros(S1,1);
                        IC2=zeros(S2,1);
                        IC3=zeros(S3,1);
                        callseries=[voc{order(1)};IC1;voc{order(2)};IC2;voc{order(3)};IC3];
                        wavoutname = sprintf('%s_%s%s%s_%s_%d-%d-%d.wav',IndName,IndSex,IndAge,IndStat,typecall,order(1),order(2),order(3));
                        wav_outfile = fullfile(wav_path,wavoutname);
                        wavwrite(callseries,Fout,bits,wav_outfile);
                        fprintf(fid_out, '\n%s -> %s %f %s %f %s %f\n', wavoutname, wavein{order(1)}, S1/Fout, wavein{order(2)}, S2/Fout, wavein{order(3)}, S3/Fout);
                        NN=NN+1;
                        file_list(NN).out_name = wav_outfile;
                    end
                end
            end
        end
    end

%    if STRCMP (directory , 'Stranger')
%        wav_outfile = fullfile(wav_pathS,sprintf('%s_pr.wav',file_prefix));
%        wavwrite(y,Fout,bits,wav_outfile);
%        file_list(jj).out_nameS = wav_outfile;
%    end
    
fclose(fid_out);
end


