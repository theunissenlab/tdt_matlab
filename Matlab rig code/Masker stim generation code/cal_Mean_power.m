function [ Mpow, STDpow, Stims ] = cal_Mean_power( input_dir )
%Return the mean power of all vocalizations in the input directory
%   deal with parameters

if nargin < 1
    input_dir = pwd;
end

Flow = 250.0;
Fhigh = 12000.0;

%% Read in files from directory

Voc = struct;
Voc.name = 'Vocalization';
Voc.dir = fullfile(input_dir,Voc.name);

% Get list of wav files in this directory
%set = struct;
%set.dir = Voc.dir;
wavfiles = dir(fullfile(Voc.dir,'*.wav'));
%set.stims = {wavfiles.name};
Voc.set = {wavfiles.name};

% Put set into Srch struct
%Voc.sets = set;

%% Return sets
Stims = Voc;


%% Compile voc into lists
%[stim_list,Stims] = list_files_call(Stims);

%%Calculate mean power for each file
% Number of files
%nfiles = length(stim_list);
nfiles = length(Stims.set);

% Initialize vector for mean power
wav_power = zeros(1,nfiles);

for jj = 1:nfiles
        
    
    % Apply filt_power on each vocalization
    %infilename = stim_list(jj).name
    infilename = fullfile(Stims.dir, char(Stims.set(jj)));
    [y,Fin,bits] = wavread(infilename);
    power = filt_power(y,Fin,Flow,Fhigh);
    wav_power(jj) = power;
end

Mpow = mean(wav_power);
STDpow = std(wav_power);

end

