% DECONV   デコンボリューションと多項式の除算
% 
% [Q,R] = DECONV(B,A)は、ベクトルBをベクトルAで除算します。
% B = conv(A,Q) + Rとなるように、商がベクトルQに、剰余がベクトルRに
% 出力されます。
% 
% AとBが多項式の係数ベクトルの場合、デコンボリューションは、多項式の除算
% と等価です。BをAで除算した結果は、Qが商でRが剰余です。
%
% 入力 B, A に対するクラスのサポート:
%      float: double, single
%
% 参考  CONV, RESIDUE.


%   Copyright 1984-2004 The MathWorks, Inc.
