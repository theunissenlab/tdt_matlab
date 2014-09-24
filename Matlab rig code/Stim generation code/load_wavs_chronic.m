function [pts,StimSet_nStims] = load_wavs_chronic(Stims,nStimSets, Outfile)

% Read in wav data from Stims data structure

wavfile=[];
pts = [];
StimSet_nStims =[];

% Read each wav, get the length of each wav,
% and put all the waves together one after the other in one file.
% the sampling frequency has already been changed to the rate
% used by the TDT program (24414.0625 Hz) and the RMS level was already
% harmonized between vocalization types
for jj = 1:nStimSets
    for kk=1:Stims(jj).nfiles
        [y,Fs,bits] = wavread(fullfile(Stims(jj).dir,Stims(jj).files(kk).name));
        pts = [pts,size(y,1)];
        wavfile=cat(1,wavfile,y);
        fprintf(1,'%s\n', Stims(jj).files(kk).name)
    end
    StimSet_nStims = [StimSet_nStims,Stims(jj).nfiles];
end

% Append duplicate entries to StimSet_nStims so that it has entries for
% duplicated protocols to fill the buffer
n_duplicate_stimsets = 4-nStimSets;
StimSet_nStims = [StimSet_nStims,repmat(StimSet_nStims(2),1,n_duplicate_stimsets)];

%In the TDT program the buffer for the combined wav file
%must be at least as big as wavsize
wavsize=size(wavfile,1);
fprintf('\r Size of the combined wav file is %u \n \r', wavsize);

%Write the combined wav file and clear up some memory
wavwrite(wavfile,Fs,bits,Outfile.wav);
clear wavfile y;