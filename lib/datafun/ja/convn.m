%CONVN  N 次元のコンボリューション
%
%   C = CONVN(A、B) は、行列 A と B の N 次元のコンボリューションを行います。
%   nak = size(A,k) と nbk = size(B,k) の場合、size(C,k) = max([nak+nbk-1,nak,nbk]) 
%   になります。
%
%   C = CONVN(A, B, 'shape') は、C のサイズを制御します。
%     'full'   - (デフォルト) N 次元コンボリューションのすべての結果を返します。
%     'same'   - Aと同じサイズで結果の中心部分を返します。
%     'valid'  - 配列に 0 を加えずに計算されたコンボリューションの部分のみを
%                計算します。
%                size(C,k) = max([nak-max(0,nbk-1)],0).
%
%   入力 A, B に対するクラスサポート:
%      float: double, single
%
%   参考 CONV, CONV2.


%   Copyright 1984-2009 The MathWorks, Inc. 
