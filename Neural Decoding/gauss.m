function gaussFilter = gauss(sigma)
width = round((6*sigma - 1)/2);
support = (-width:width);
gaussFilter = exp( -(support).^2 ./ (2*sigma^2) );
gaussFilter = gaussFilter/ sum(gaussFilter);
end