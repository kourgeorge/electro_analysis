%GRADIENT  勾配近似
%
%   [FX,FY] = GRADIENT(F) は、行列 F の数値勾配を返します。FX は、x (水平) 方向
%   の差分 dF/dx に対応します。FY は、y (垂直) 方向の差分 dF/dy に対応します。
%   各方向の点の間隔を 1 と仮定します。F がベクトルの場合、DF = GRADIENT(F) は 
%   1 次元勾配です。
%
%   [FX,FY] = GRADIENT(F,H) は、H がスカラのとき、各方向での点の間隔として
%   使います。
%
%   [FX,FY] = GRADIENT(F,HX,HY) は、F が 2 次元の場合、HX と HY で指定された
%   間隔を使います。HX と HY は、座標間の間隔を指定するためのスカラや、点の
%   座標を指定するベクトルです。HX と HY がベクトルの場合、その長さは F の
%   対応する次元と一致しなければなりません。
%
%   [FX,FY,FZ] = GRADIENT(F) は、F が 3 次元配列のとき、F の数値勾配を返します。
%   FZ は、z 方向の差分 dF/dz に対応します。GRADIENT(F,H) は、H がスカラのとき、
%   各方向の点の間隔として使います。
%
%   [FX,FY,FZ] = GRADIENT(F,HX,HY,HZ) は、HX、HY、HZ で与えられた間隔を使います。
%
%   [FX,FY,FZ,...] = GRADIENT(F,...) は、F が N 次元のときと同様に拡張し、
%   N 個の出力と、2 個、または、N+1 個の入力で実行されなければなりません。
%
%   注意: 1 番目の出力 FX は、常に列と交差しながら F の 2 番目の次元に沿った
%   勾配になります。2 番目の出力 FY は、常に行と交差しながら F の 1 番目の
%   次元に沿った勾配になります。3 番目の出力 FZ とそれに続く出力に対して、
%   N 番目の出力は F の N 番目の次元に沿った勾配になります。
%
%   例:
%       [x,y] = meshgrid(-2:.2:2, -2:.2:2);
%       z = x .* exp(-x.^2 - y.^2);
%       [px,py] = gradient(z,.2,.2);
%       contour(z), hold on, quiver(px,py), hold off
%
%   入力 F に対するクラスサポート:
%      float: double, single
%
%   参考 DIFF, DEL2.


%   Copyright 1984-2007 The MathWorks, Inc.
