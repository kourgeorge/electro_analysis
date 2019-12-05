function manipulated_st = manipulate_st( st , artificial_spikes_times)
%MANIPULATE Manipulate st to check the model validity.
%   This function manipulate the spike times by shuffling the times between spikes
%   and then adding spikes in specific locations and then rebuilds the soike times.
%   This manipulation maintains the otginal diff between spikes but
%   scrambles it and add spikes to predicfined locations.

mu = 0.1;
sigma = 0.2;

diff_st = diff(st);
perm = randperm(length(st)-1);
diff_st = diff_st(perm);
st = cumsum([st(1) diff_st]);

for k=1:length(artificial_spikes_times)
    a_spikes = randn([1,1])*sigma+mu+artificial_spikes_times(k);
    st = [st, a_spikes];
end

st = sort(st);

manipulated_st = st;

end

