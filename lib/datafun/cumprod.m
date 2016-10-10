%CUMPROD Cumulative product of elements.
%   Y = CUMPROD(X) computes the cumulative product along the first non-singleton
%   dimension of X. Y is the same size as X.
%
%   Y = CUMPROD(X,DIM) cumulates along the dimension specified by DIM.
% 
%   Y = CUMPROD(___,DIRECTION) cumulates in the direction specified by
%   the string DIRECTION using any of the above syntaxes:
%     'forward' - (default) uses the forward direction, from beginning to end.
%     'reverse' -           uses the reverse direction, from end to beginning.
%
%   Example: If X = [0 1 2
%                    3 4 5]
%
%   cumprod(X,1) is [0 1  2  and cumprod(X,2) is [0  0  0
%                    0 4 10]                      3 12 60]
%
%   cumprod(X,1,'reverse') is [0 4 10  and cumprod(X,2,'reverse') is [ 0  2 2
%                              3 4  5]                                60 20 5]
%
%   See also CUMSUM, CUMMIN, CUMMAX, SUM, PROD.

%   Copyright 1984-2014 The MathWorks, Inc.

%   Built-in function.

