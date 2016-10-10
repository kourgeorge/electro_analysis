% CUMPROD   累積積
% 
% X がベクトルの場合、CUMPROD(X) は X の要素の累積積を含むベクトルを
% 出力します。X が行列の場合、CUMPROD(X) は、各列に対する累積積を含む、
% X と同じサイズの行列を出力します。X がN次元配列の場合、CUMPROD(X) は
% 最初に 1 でない次元について機能します。
%
% CUMPROD(X,DIM) は、次元 DIM について機能します。
%
% 例: 
%    X = [0 1 2
%     　  3 4 5]
%
% の場合、cumprod(X,1) は、[0 1  2 で、cumprod(X,2) は、[0  0  0
%                           0 4 10]                      3 12 60] です。
%
% 参考  CUMSUM, SUM, PROD.


%   Copyright 1984-2006 The MathWorks, Inc.
