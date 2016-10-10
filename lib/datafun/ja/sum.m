%   SUM 要素の和
%
% S = SUM(X) は、ベクトル X の要素の和を出力します。
% X がベクトルの場合、S は、各列の和からなる行ベクトルです。
% X がN次元配列の場合、SUM(X) は、最初の 1 でない次元で操作します。
% X が浮動小数点、つまり、倍精度または単精度の場合、そのクラス
% のまま足し合わされます。すなわち、S は、X と同じクラスになります。
% X が浮動小数点数でない場合、S は、倍精度で足し合わされ、S は倍精度
% のクラスをもちます。
%
% S = SUM(X,DIM) は、次元DIMの和を求めます。
%
% S = SUM(X,'double') と S = SUM(X,DIM,'double') は、倍精度で
% 和を求めます。S は、X が単精度であっても、倍精度クラスを
% もちます。
%
% S = SUM(X,'native') と S = SUM(X,DIM,'native') は、オリジナルの
% クラスのまま和を求め、S は、X と同じクラスをもちます。
%
% 例:
%   X = [0 1 2
%        3 4 5]
%
% の場合、sum(X,1) は [3 5 7] で、sum(X,2) は [3
%                                             12];です。
% 
% X = int8(1:20) の場合、sum(X) は、倍精度 で和を求め、
% 結果は、double(210) です。一方、sum(X,'native') は、int8 で
% 和を求めますが、オーバーフローし、int8(127) まで飽和します。
%
% 参考 PROD, CUMSUM, DIFF, ACCUMARRAY, ISFLOAT.


%   Copyright 1984-2006 The MathWorks, Inc.
