function [ pow ] = filt_power( song, fs, f_low, f_high)
%% Filters and calculate mean power in non silence regions of vocalization.


% Deal with arguments and parameters
if isempty(song)
    error('Missing or empty song array'); 
end
if isempty(fs)
    error('Missing or empty song array'); 
end

if isempty(f_low)
    f_low = 250.0;
end

if isempty(f_high)
    f_high = 8000.0;
end


% Figure out length of filter
nframes = length(song);
if ( nframes > 3*512 ) 
    nfilt = 512;
elseif ( nframes > 3*64 ) 
    nfilt = 64;
    
elseif ( nframes > 3*16 ) 
    nfilt = 16;
else
    error('Song data is too short for filtering');
end

% Generate filter and filter song
song_filter = fir1(nfilt,[f_low*2.0/fs, f_high*2.0/fs]);
new_song = filtfilt(song_filter, 1, song);

% Rescale file to get maximum dynamic range 

max_song = max(new_song);
min_song = min(new_song);
range = max(-min_song,max_song)/10.0;

pow =0.0;
nclip = 0;
for i = 2:nframes-1 
    val = new_song(i);
    if ( val > range & val > new_song(i-1) & val > new_song(i+1) )
        nclip=nclip+1;
        pow = pow + val*val;
    end
    if ( val < -range & val < new_song(i-1) & val < new_song(i+1) )
        nclip=nclip+1;
        pow = pow+val*val;
    end
end

pow = sqrt(pow/nclip);


% End of function filt_power.m

end

