function new_song = simplefilt(song, fs, f_low, f_high, db_att)
% filters a sound signal between f_low and f_high, without normalizing

% Deal with arguments and parameters
if isempty(song)
    error('Missing or empty song array'); 
end
if isempty(fs)
    error('Missing or empty song array'); 
end

if isempty(f_low)
    f_low = 500.0;
end

if isempty(f_high)
    f_high = 8000.0;
end

if isempty(db_att)
    db_att = 0;
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
    error('Signal is too short for filtering');
end

% Generate filter and filter song
song_filter = fir1(nfilt,[f_low*2.0/fs, f_high*2.0/fs]);
new_song = filtfilt(song_filter, 1, song);
end


