function spikes_out = epoc_spikes(spikes_in,epocs_in)

spikes_out = cell(1,epocs_in.number);

all_spiketimes = [spikes_in(:).time];

for jj = 1:epocs_in.number
    late_enough = all_spiketimes >= epocs_in(jj).starttime;
    early_enough = all_spiketimes <= epocs_in(jj).endtime;
    spikes_out{jj} = spike(spikes_in(late_enough & early_enough));
end