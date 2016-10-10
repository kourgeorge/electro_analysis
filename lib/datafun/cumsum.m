%CUMSUM Cumulative sum of elements.
%   Y = CUMSUM(X) computes the cumulative sum along the first non-singleton
%   dimension of X. Y is the same size as X.
% 
%   Y = CUMSUM(X,DIM) cumulates along the dimension specified by DIM.
% 
%   Y = CUMSUM(___,DIRECTION) cumulates in the direction specified by
%   the string DIRECTION using any of the above syntaxes:
%     'forward' - (default) uses the forward direction, from beginning to end.
%     'reverse' -           uses the reverse direction, from end to beginning.
%
%   Example: If X = [0 1 2
%                    3 4 5]
%
%   cumsum(X,1) is [0 1 2  and cumsum(X,2) is [0 1  3
%                   3 5 7]                     3 7 12]
%
%   cumsum(X,1,'reverse') is [3 5 7  and cumsum(X,2,'reverse') is [ 3 3 2
%                             3 4 5]                               12 9 5]
%
%   See also CUMPROD, CUMMIN, CUMMAX, SUM, PROD.

%   Copyright 1984-2014 The MathWorks, Inc.

%   Built-in function.

