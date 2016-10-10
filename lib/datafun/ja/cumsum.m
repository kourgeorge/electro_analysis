% CUMSUM   累積和
% 
% X がベクトルの場合、CUMSUM(X) は X の要素の累積和を含むベクトルを出力
% します。X が行列の場合、CUMSUM(X) は各列に対する累積和を含む、X と同じ
% サイズの行列を出力します。X がN次元配列の場合、CUMSUM(X) は最初に 
% 1 でない次元について機能します。
%
% CUMSUM(X,DIM) は、次元 DIM について機能します。
%
% 例:
% 
% X = [0 1 2
%      3 4 5]
%
% の場合、cumsum(X,1) は [0 1 2  で cumsum(X,2) は [0 1  3  です。
%                         3 5 7]                    3 7 12]
% 
% 参考  CUMPROD, SUM, PROD.


%   Copyright 1984-2006 The MathWorks, Inc.
