% TRAPZ  台形数値積分
% 
% Z = TRAPZ(Y) は、台形積分法 (単位間隔で) を使って、Y の積分近似を計算
% します。単位間隔ではないデータの積分を行うには、間隔の増分を Z に掛けて
% ください。
%
% Y がベクトルの場合、TRAPZ(Y) は Y の積分です。Y が行列の場合、TRAPZ(Y) は、
% 各列での積分を要素とする行ベクトルです。Y がN次元配列の場合、TRAPZ(Y) は
% 最初に 1 でない次元で積分を行います。
%
% Z = TRAPZ(X,Y) は、台形積分法を使って X について Y の積分を計算します。
% X と Y が同じ長さのベクトルであるか、X は列ベクトルで、Y は最初の 1 でない
% 次元が length(X) である配列でなければなりません。TRAPZ は、この次元で
% 実行します。
%
% Z = TRAPZ(X,Y,DIM) または TRAPZ(Y,DIM) は、Y の次元 DIM で積分を行います。
% X の長さは、size(Y,DIM) と同じでなければなりません。
%
% 例: Y = [0 1 2
%          3 4 5]
%
% の場合、trapz(Y,1) は、[1.5 2.5 3.5] で、trapz(Y,2) は [2   です。
%                                                         8]
%
% 入力 X, Y のクラスサポート:
%      float: double, single
%
% 参考  SUM, CUMSUM, CUMTRAPZ, QUAD.


%   Copyright 1984-2006 The MathWorks, Inc.
