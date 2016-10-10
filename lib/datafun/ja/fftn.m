% FFTN   N次元高速フーリエ変換
% 
% FFTN(X) は、N次元配列XのN次元の離散フーリエ変換を出力します。
% X がベクトルの場合、出力は同じ向きのベクトルになります。
% 
% FFTN(X,SIZ) は、変換前に、変換後のサイズベクトルが SIZ になるように、
% X に 0 を加えます。SIZ の各要素が、X の対応した次元よりも小さい場合、
% X はその次元で打ち切られます。
%
% 参考 FFT, FFT2, FFTSHIFT, FFTW, IFFT, IFFT2, IFFTN.


%   Copyright 1984-2006 The MathWorks, Inc.
