%CUMMIN Cumulative smallest component.
%   Y = CUMMIN(X) computes the cumulative smallest component of X along
%   the first non-singleton dimension of X. Y is the same size as X.
% 
%   Y = CUMMIN(X,DIM) cumulates along the dimension specified by DIM.
% 
%   Y = CUMMIN(___,DIRECTION) cumulates in the direction specified by
%   the string DIRECTION using any of the above syntaxes:
%     'forward' - (default) uses the forward direction, from beginning to end.
%     'reverse' -           uses the reverse direction, from end to beginning.
%
%   If X is complex, CUMMIN compares the magnitude of the elements of X.
%   In the case of equal magnitude elements, the phase angle is also used.
%
%   Example: If X = [0 4 3
%                    6 5 2]
%
%   cummin(X,1) is [0 4 3  and cummin(X,2) is [0 0 0
%                   0 4 2]                     6 5 2]
%
%   cummin(X,1,'reverse') is [0 4 2  and cummin(X,2,'reverse') is [0 3 3
%                             6 5 2]                               2 2 2]
%
%   See also CUMMAX, CUMSUM, CUMPROD, MIN, MAX.

%   Copyright 1984-2014 The MathWorks, Inc.

%   Built-in function.

