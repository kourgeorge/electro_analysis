function plotRaster( Raster, Psth, titleString, cut )
%PLOTRASTER Summary of this function goes here
%   Detailed explanation goes here

figure;
subplot(2,1,1)
bar(linspace(cut(1),cut(2),length(Psth)),Psth,'k');
axis tight
box off
grid off;
subplot(2,1,2)
spy(Raster,'k.');
set(gca,'XTick', linspace(0,size(Raster,2),11),'XTickLabel',{num2str(cut(1)),'','','','','0','','','','',num2str(cut(2))});

axis normal

suptitle(titleString);
end


