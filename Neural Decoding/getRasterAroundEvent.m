function RasterInfo  = getRasterAroundEvent(EventTimes, st, cut, binsize)
%RASTERLABELSCREATOR Given the event times as the spike data, creates
%raster around the event times. The binned raster is the count of of spikes
%in the binsize [ms] interval, with 50 ms strides 
%   Detailed explanation goes here


%binneddotd = sparse(size(EventTimes,1),length(cut(1)*1000:binsize:cut(2)*1000)); % for psth
dotd=sparse(size(EventTimes,1),length(cut(1)*1000:cut(2)*1000));

for r=1:size(EventTimes,1)
    TE=EventTimes(r);
    trange=TE+cut ;
    inxsp=st>trange(1)&st<=trange(2);
    s=st(inxsp);
    dotd(r,max(1,floor((s-trange(1))*1000)))=1;
    
end

binneddotd(r,:) = hist(s,trange(1):binsize/1000:trange(2));
BinnedRaster = sum(full(binneddotd))/size(binneddotd,1)*(1000/binsize);
RasterInfo.Raster = full(dotd);
RasterInfo.BinnedRaster = full(binneddotd)*(1000/binsize); % convert to HZ

% RasterInfo = full(dotd);

%binpst = sum(full(binneddotd))/size(binneddotd,1);
%binpst = filtfilt(gauss(1),1,binpst);

end

