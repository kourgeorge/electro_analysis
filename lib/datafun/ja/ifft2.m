%IFFT2  2 次元逆離散フーリエ変換
%
%   IFFT2(F) は、行列 F の 2 次元逆離散フーリエ変換を返します。F がベクトルの
%   場合、結果は同じ向きになります。
%
%   IFFT2(F,MROWS,NCOLS) は、MROWS 行 NCOLS 列のサイズにするよう変換の前に 
%   F に 0 を加えます。
%
%   IFFT2(..., 'symmetric') では、IFFT2 の出力が純粋に実数になるように、
%   2 次元の共役対称として F を扱います。丸め誤差のため、F が厳密に共役対称で
%   ない場合、このオプションは有効です。この対称性に関する特定の数学的な定義
%   については、リファレンスページを参照してください。
%
%   IFFT2(..., 'nonsymmetric') では、IFFT2 は、F の対称性について何も
%   仮定しません。
%
%   入力 F に対するクラスサポート:
%      float: double, single
%
%   参考 FFT, FFT2, FFTN, FFTSHIFT, FFTW, IFFT, IFFTN.


%   Copyright 1984-2007 The MathWorks, Inc. 
