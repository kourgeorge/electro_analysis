%CONV  コンボリューションと多項式の乗算
%
%   C = CONV(A、B) は、ベクトル A と B のコンボリューションを行います。
%   結果のベクトルは、長さ MAX([LENGTH(A)+LENGTH(B)-1,LENGTH(A),LENGTH(B)]) 
%   になります。A と B が多項式の係数のベクトルの場合、コンボリューションは 
%   2 つの多項式の乗算と同じ演算です。
%
%   C = CONV(A, B, SHAPE) は、以下の SHAPE で指定されるサイズを持つ
%   コンボリューションの小さい区分を返します。
%     'full'  - (デフォルト) コンボリューションのすべての結果を返します。
%     'same'   - Aと同じサイズで結果の中心部分を返します。
%     'valid' - エッジに 0 を加えずに計算されたコンボリューションの部分のみを
%               返します。
%               LENGTH(C)is MAX(LENGTH(A)-MAX(0,LENGTH(B)-1),0).
%
%   入力 A, B に対するクラスサポート:
%      float: double, single
%
%   参考 DECONV, CONV2, CONVN, FILTER, Signal Processing Toolbox の XCORR, 
%        CONVMTX.


%   Copyright 1984-2009 The MathWorks, Inc.
