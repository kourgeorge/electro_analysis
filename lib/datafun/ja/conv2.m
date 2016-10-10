%CONV2  2 次元のコンボリューション
%
%   C = CONV2(A, B) は、行列 A と B の 2 次元のコンボリューションを行います。
%   [ma,na] = size(A), [mb,nb] = size(B), [mc,nc] = size(C) の場合、
%   mc = max([ma+mb-1,ma,mb]) と nc = max([na+nb-1,na,nb]) になります。
%
%   C = CONV2(H1, H2, A) は、まずベクトル H1 を使って行の方向に、次にベクトル 
%   H2 を使って列の方向に A のコンボリューションを行います。
%   n1 = length(H1) と n2 = length(H2) の場合、mc = max([ma+n1-1,ma,n1]) と 
%   nc = max([na+n2-1,na,n2]) になります。
%
%   C = CONV2(..., SHAPE) は、以下の SHAPE で指定されるサイズを持つ 2 次元
%   コンボリューションの小さい区分を返します。
%     'full'  - (デフォルト) 2 次元コンボリューションのすべての結果を返します。
%     'same'   - Aと同じサイズで結果の中心部分を返します。
%     'valid' - エッジに 0 を加えずに計算されたコンボリューションの部分のみを
%               返します。
%               size(C) = max([ma-max(0,mb-1),na-max(0,nb-1)],0).
%
%   参考 CONV, CONVN, FILTER2 および Signal Processing Toolbox の XCORR2.


%   Copyright 1984-2009 The MathWorks, Inc.
