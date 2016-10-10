function y = median(x,dim)
%MEDIAN Median value.
%   For vectors, MEDIAN(a) is the median value of the elements in a.
%   For matrices, MEDIAN(A) is a row vector containing the median
%   value of each column.  For N-D arrays, MEDIAN(A) is the median
%   value of the elements along the first non-singleton dimension
%   of A.
%
%   MEDIAN(A,DIM) takes the median along the dimension DIM of A.
%
%   Example: If A = [1 2 4 4; 3 4 6 6; 5 6 8 8; 5 6 8 8];
%
%   then median(A) is [4 5 7 7] and median(A,2)
%   is [3 5 7 7].'
%
%   Class support for input A:
%      float: double, single
%      integer: uint8, int8, uint16, int16, uint32, int32, uint64, int64
%
%   See also MEAN, STD, MIN, MAX, VAR, COV, MODE.

%   Copyright 1984-2013 The MathWorks, Inc.

if isempty(x)
    if nargin == 1
        
        % The output size for [] is a special case when DIM is not given.
        if isequal(x,[])
            if isinteger(x)
                y = zeros('like',x);
            else
                y = nan('like',x);
            end
            return;
        end
        
        % Determine first nonsingleton dimension
        dim = find(size(x)~=1,1);
        
    end
    
    s = size(x);
    if dim <= length(s)
        s(dim) = 1;                  % Set size to 1 along dimension
    end
    if isinteger(x)
        y = zeros(s,'like',x);
    else
        y = nan(s,'like',x);
    end
    
elseif nargin == 1 && isvector(x)
    % If input is a vector, calculate single value of output.
    x = sort(x);
    nCompare = numel(x);
    half = floor(nCompare/2);
    y = x(half+1);
    if 2*half == nCompare        % Average if even number of elements
        y = meanof(x(half),y);
    end
    if isnan(x(nCompare))        % Check last index for NaN
        y = nan('like',x);
    end
else
    if nargin == 1              % Determine first nonsingleton dimension
        dim = find(size(x)~=1,1);
    end
    
    s = size(x);
    
    if dim > length(s)           % If dimension is too high, just return input.
        y = x;
        return
    end
    
    % Sort along given dimension
    x = sort(x,dim);
    
    nCompare = s(dim);           % Number of elements used to generate a median
    half = floor(nCompare/2);    % Midway point, used for median calculation
    
    if dim == 1
        % If calculating along columns, use vectorized method with column
        % indexing.  Reshape at end to appropriate dimension.
        y = x(half+1,:);
        if 2*half == nCompare
            y = meanof(x(half,:),y);
        end
        
        y(isnan(x(nCompare,:))) = NaN;   % Check last index for NaN
        
    elseif dim == 2 && length(s) == 2
        % If calculating along rows, use vectorized method only when possible.
        % This requires the input to be 2-dimensional.   Reshape at end.
        y = x(:,half+1);
        if 2*half == nCompare
            y = meanof(x(:,half),y);
        end
        
        y(isnan(x(:,nCompare))) = NaN;   % Check last index for NaN
        
    else
        % In all other cases, reshape first and then use vectorized method for
        % the median. Reshape again at the end to obtain appropriate size.
        cumSize = cumprod(s);
        total = cumSize(end);            % Equivalent to NUMEL(x)
        
        numConseq = cumSize(dim - 1);    % Number of consecutive indices
        increment = cumSize(dim);        % Gap between runs of indices
        
        squeezeds = [numConseq nCompare (total/increment)];
        x = reshape(x, squeezeds);
        y = x(:,half+1,:);
        if 2*half == nCompare
            y = meanof(x(:,half,:),y);
        end
        
        y(isnan(x(:,nCompare,:))) = NaN;   % Check last index for NaN
        
    end
    
    % Now reshape output.
    s(dim) = 1;
    y = reshape(y,s);
end

%============================

function c = meanof(a,b)
% MEANOF the mean of A and B with B > A
%    MEANOF calculates the mean of A and B. It uses different formula
%    in order to avoid overflow in floating point arithmetic.

if isinteger(a)
    % Swap integers such that ABS(B) > ABS(A), for correct rounding
    ind = b < 0;
    temp = a(ind);
    a(ind) = b(ind);
    b(ind) = temp;
end
c = a + (b-a)/2;
k = (sign(a) ~= sign(b)) | isinf(a) | isinf(b);
c(k) = (a(k)+b(k))/2;

