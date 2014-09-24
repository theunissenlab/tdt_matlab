function dlmfile(t,out_dir,spike_snippets,verbose,opensorter)

% Extract all spikes and epocs for a tank and save them

global ttank

%% Defaults and constants
if nargin < 5
    opensorter = 1;
end

if nargin < 4
    verbose = 0;
end

if nargin < 3
    spike_snippets = 0;
end

%% Retrieve info for all blocks
blocks = tdt_blocks(t);
nblocks = length(blocks);

%% Display tank name
disp(sprintf('%s:',t.name));

%% Save the block info
fiatdir([out_dir filesep]);
if verbose
    disp(sprintf('\tsaving block metadata file...'))
end
block_dlmfile(t,out_dir,false);
if verbose
    disp(sprintf('\t\tdone.'))
end

%% Retrieve the spikes and epocs for each block and save
for jj = 1:nblocks
    try
        b = blocks{jj};
        disp(sprintf('\t%s',b.name));
        
        % Retrieve and save spikes
        spikefilename = fullfile(out_dir,[b.name ' spikes.txt']);
        if exist(spikefilename,'file')
            delete(spikefilename);
        end
        if verbose
            disp(sprintf('\t\tExtracting spike data from tank server...'))
        end
        
        % Save spike snippets if they're present -- causes problems if not,
        % so default to not do it.
        if spike_snippets
            
            % Save spike arrival times
            if verbose
                disp(sprintf('\t\tSaving spike times to file %s...',spikefilename))
            end
            
            block_spikes = spikes(b);
            dlmfile(block_spikes,spikefilename);
            
            if verbose
                disp(sprintf('\t\t\tdone'))
            end
            
            % Save spike waveforms
            wavesfilename = fullfile(out_dir,[b{jj}.name ' waves.f32']);
            if exist(wavesfilename,'file')
                delete(wavesfilename);
            end
            
            if verbose
                disp(sprintf('\t\tSaving spike waveforms to file %s...',wavesfilename))
            end
            waveforms_file(block_spikes,wavesfilename)
            clear block_spikes
        
            if verbose
                disp(sprintf('\t\t\tdone'))
            end
            
            % Save OpenSorter spike sorts if requested
            if opensorter
                file_pattern = [b.name ' %s spikes.txt'];
                dlm_opensorter(b,out_dir,file_pattern)
            end
        end
        
        % Retrieve and save epocs
        if verbose
            disp(sprintf('\t\tExtracting epoc data from tank server...'))
        end
        block_epocs = all_epocs(blocks{jj});
        
        for kk = 1:length(block_epocs)
            epocfilename = fullfile(out_dir,...
                [blocks{jj}.name ' epoc ' block_epocs{kk}.name '.txt']);
            if exist(epocfilename,'file')
                delete(epocfilename);
            end
            
            if verbose
                disp(sprintf('\t\t\tsaving data for epoc ''%s'' to file %s',...
                             block_epocs{kk}.name,epocfilename))
            end
            dlmfile(block_epocs{kk},epocfilename);
        end
        if verbose
            disp(sprintf('\t\t\tdone'))
        end
        clear block_epocs
        
        % Retrieve and save streamed waveform data
        % Added 7/29/09 RCM
        ttank.ResetFilters
        if verbose
           disp(sprintf('\t\tProcessing streamed data...'))
        end
        block_streams = streams(blocks{jj});
        for kk = 1:length(block_streams)
            if verbose
                disp(sprintf('\t\t\tsaving stream %s...',block_streams{kk}.store_name))
            end
            all_to_file(block_streams{kk},out_dir);
        end
        if verbose
            disp(sprintf('\t\t\tdone'))
        end
        
    catch
        errstring = sprintf('Error extracting block %s %s:\n%s',...
            blocks{jj}.name,t.name,lasterr);
        disp(errstring);
    end
end