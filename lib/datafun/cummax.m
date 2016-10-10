%CUMMAX Cumulative largest component.
%   Y = CUMMAX(X) computes the cumulative largest component of X along
%   the first non-singleton dimension of X. Y is the same size as X.
% 
%   Y = CUMMAX(X,DIM) cumulates along the dimension specified by DIM.
% 
%   Y = CUMMAX(___,DIRECTION) cumulates in the direction specified by
%   the string DIRECTION using any of the above syntaxes:
%     'forward' - (default) uses the forward direction, from beginning to end.
%     'reverse' -           uses the reverse direction, from end to beginning.
%
%   If X is complex, CUMMAX compares the magnitude of the elements of X.
%   In the case of equal magnitude elements, the phase angle is also used.
%
%   Example: If X = [0 4 3
%                    6 5 2]
%
%   cummax(X,1) is [0 4 3  and cummax(X,2) is [0 4 4
%                   6 5 3]                     6 6 6]
%
%   cummax(X,1,'reverse') is [6 5 3  and cummax(X,2,'reverse') is [4 4 3
%                             6 5 2]                               6 5 3]
%
%   See also CUMMIN, CUMSUM, CUMPROD, MAX, MIN.

%   Copyright 1984-2014 The MathWorks, Inc.

%   Built-in function.

