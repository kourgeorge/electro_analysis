% PROD   配列の要素の積
% 
%  X がベクトルの場合、PROD(X) は X の要素の積を出力します。
%  X が行列の場合、PROD(X) は各列の積を行ベクトルとして出力します。
%  X がN次元配列の場合、PROD(X) は最初に 1 でない次元について積を出力します。
%
%  PROD(X,DIM) は、次元 DIM について積を出力します。
%
%  例: X = [0 1 2
%           3 4 5]
%
%  の場合、prod(X,1) は [0 4 10] で、prod(X,2) は [0  です。
%                                                 60]
%
% 参考  SUM, CUMPROD, DIFF.


%   Copyright 1984-2006 The MathWorks, Inc.
