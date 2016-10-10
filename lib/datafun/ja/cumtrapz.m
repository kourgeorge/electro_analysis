% CUMTRAPZ   累積台形数値積分
% 
% Z = CUMTRAPZ(Y) は、(単位間隔での) 台形積分法を使って、Y の累積積分の
% 近似を計算します。単位間隔でない積分を計算するためには、間隔の増分を 
% Z に掛けてください。
%
% Y がベクトルの場合、CUMTRAPZ(Y) は Y の累積積分を含むベクトルを出力
% します。Y が行列の場合、CUMTRAPZ(Y) は、各列での累積積分を要素にもつ、
% X と同じ大きさの行列を出力します。Y がN次元配列の場合、CUMTRAPZ(Y) は
% 最初に 1 でない次元について機能します。
%
% Z = CUMTRAPZ(X,Y) は、台形積分を使って、X に対する Y の累積積分を計算
% します。X と Y は、同じ長さのベクトル、または、X は列ベクトルで、Y は
% 最初に 1 でない次元が length(X) である配列でなければなりません。
% CUMTRAPZ は、この次元について機能します。
%
% Z = CUMTRAPZ(X,Y,DIM)、または、CUMTRAPZ(Y,DIM) は、Y の中の DIM で
% 指定された Y の次元について積分を行います。X の長さは、size(Y,DIM) と
% 同じでなければなりません。
%
% 例:
% 
%   Y = [0 1 2
%        3 4 5]
%
% の場合、cumtrapz(Y,1) は [0   0   0     で、cumtrapz(Y,2) は [0 0.5 2  
%                           1.5 2.5 3.5]                        0 3.5 8];
% です。
% 
% 入力 X, Y に対するクラスのサポート:
%      float: double, single
%
% 
% 参考  CUMSUM, TRAPZ, QUAD, QUADV.


%   Copyright 1984-2006 The MathWorks, Inc. 
