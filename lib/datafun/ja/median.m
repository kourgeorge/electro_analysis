% MEDIAN   配列の中央値
% 
% X がベクトルの場合、MEDIAN(X) は X の要素の中央値を出力します。
% X が行列の場合、MEDIAN(X) は各列の中央値を含む行ベクトルを出力します。
% X がN次元配列の場合、MEDIAN(X) は X の最初に 1 でない次元の要素について
% 中央値を出力します。
%
% MEDIAN(X,DIM) は、X の次元 DIM について中央値を計算します。
%
% 例: X = [0 1 2
%          3 4 5]
%
% の場合、median(X,1) は [1.5 2.5 3.5] で、median(X,2) は [1  です。
%                                                          4]
%
% 入力 X のクラスサポート:
%      float: double, single
%
% 参考  MEAN, STD, MIN, MAX, VAR, COV, MODE.


%   Copyright 1984-2006 The MathWorks, Inc.
