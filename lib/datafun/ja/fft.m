% FFT  離散フーリエ変換
% 
% FFT(X) は、ベクトル X の離散フーリエ変換 (DFT) を出力します。FFT は、
% 行列に対しては列単位で操作を行います。FFT は、N次元配列に対しては、
% 最初に 1 でない次元に対して操作を行います。
%
% FFT(X,N) は、N点のFFTを出力します。X の長さが N より小さい場合は、
% N になるまで後ろに 0 を加えます。X の長さが N より大きい場合は、
% X の N より長い部分は、打ち切られます。
%
% FFT(X,[],DIM) と FFT(X,N,DIM) は、次元 DIM 上で FFT 演算を適用します。
% 
% 長さ N の入力ベクトル x に対して、DFT は、つぎの要素をもつ長さ N の
% ベクトル X になります。
%
%                  N
%    X(k) =       sum  x(n)*exp(-j*2*pi*(k-1)*(n-1)/N)、1 < =  k < =  N.
%                 n = 1
% 
% 逆 DFT (IFFT により計算される) は、つぎの式で与えられます。
% 
%                  N
%    x(n) = (1/N) sum  X(k)*exp( j*2*pi*(k-1)*(n-1)/N)、1 < =  n < =  N.
%                 k = 1
% 
%
% 参考 FFT2, FFTN, FFTSHIFT, FFTW, IFFT, IFFT2, IFFTN.


%   Copyright 1984-2006 The MathWorks, Inc.
