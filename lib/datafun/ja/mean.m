% MEAN   配列の平均値
% 
% X がベクトルの場合、MEAN(X) は X の要素の平均値を出力します。X が行列の
% 場合、MEAN(X) は各列の平均値を含む行ベクトルを出力します。X がN次元
% 配列の場合、MEAN(X) は、X の最初に 1 でない次元について平均値を出力します。
%
% MEAN(X,DIM) は、X の次元 DIM について、要素の平均値を出力します。
%
% 例:
% 
%   X = [0 1 2
%        3 4 5]
%
% の場合、mean(X,1) は [1.5 2.5 3.5] で、mean(X,2) は [1
%                                                      4] です。
%
% 入力 X のクラスサポート:
%      float: double, single
%
% 参考  MEDIAN, STD, MIN, MAX, VAR, COV, MODE.


%   Copyright 1984-2006 The MathWorks, Inc. 
