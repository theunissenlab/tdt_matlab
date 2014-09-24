% Script to update blocks so that they have the right date/time data

Open_TTank;
servername = 'Local';
[tanknames,ntanks] = get_tanknames(ttank,servername);
out_root = 'C:\Documents and Settings\Channing\My Documents\Grad School\Theunissen lab\datafiles';
tanks = cell(1,ntanks);
blocks = cell(size(tanks));

for jj = 1:ntanks
    tanks{jj} = tank(tanknames{jj}.name,servername);
    try
        blocks{jj} = tdt_blocks(tanks{jj});
    catch
        errstring = sprintf('Error extracting tank %s:\n%s',...
            tanks{jj}.name,lasterr);
        disp(errstring);
    end
end

blocks = [blocks{:}];
outfile = fullfile(out_root,'blocks_update_051208');
save(outfile,'blocks');