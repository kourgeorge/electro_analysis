function draw_gaussians( vec1, vec2 )
%DRAW_GUASIANS Summary of this function goes here
%   Detailed explanation goes here

[muHat1,sigmaHat1] = normfit(vec1);
[muHat2,sigmaHat2] = normfit(vec2);

x = -max(max(vec1), max(vec2)):0.1:max(max(vec1), max(vec2));
y1 = gaussmf(x,[sigmaHat1 muHat1]);
y2 = gaussmf(x,[sigmaHat2 muHat2]);
figure
plot(x,y1)
hold on
plot(x,y2)
hold off

end

