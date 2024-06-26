% DEL2   離散ラプラシアン
% 
%   L = DEL2(U) は、U が行列のとき、離散の近似 
%   0.25*del^2 u = (d^2u/dx^2 + d^2u/dy^2)/4
%   を出力します。行列 L は、U の要素とその隣接する4個の平均との差と
%   等しい要素をもつ、Uと同じ大きさの行列です。
%
%   L = DEL2(U) は、U がN次元配列のとき、n が ndims(u) である (del^2 u)/2/n 
%   の近似を出力します。
%
%   L = DEL2(U,H) は、H がスカラのとき、各方向での点間隔として H を使います
%   (H = 1 がデフォルト)。
% 
%   L = DEL2(U,HX,HY) は、U が2次元のとき、HX と HY で指定した間隔を
%   使います。HX がスカラの場合、x 方向の点の間隔を与えます。HX が
%   ベクトルの場合、長さは SIZE(U,2) で、点の x 座標を指定します。
%   同様に、HY がスカラの場合、y 方向の点の間隔を与えます。HY が
%   ベクトルの場合、長さは SIZE(U,1) で、点の y 座標を指定します。
%
%   L = DEL2(U,HX,HY,HZ,...) は、U がN次元配列のとき、HX、HY、HZ 等で
%   与えられた間隔を使います。
%
%   U のクラスサポート:
%      float: double, single
%
% 参考  GRADIENT, DIFF.


%   Copyright 1984-2006 The MathWorks, Inc. 
