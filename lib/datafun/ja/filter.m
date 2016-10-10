%FILTER  1 次元デジタルフィルタ
%
%   Y = FILTER(B,A,X) は、ベクトル A と B で表わされるフィルタを使って、
%   ベクトル X 内のデータをフィルタリングし、フィルタ出力 Y を生成します。
%   フィルタは、標準の差分方程式の "直接型 II 転置" 構造として実現されます。
%
%   a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%                         - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
%
%   a(1) が 1 でない場合、FILTER は a(1) を使ってフィルタ係数を正規化します。
%
%   FILTER は、最初の非シングルトン次元に適用されます。言い換えると、次元 
%   1 は 列ベクトルと意味のある行列に対応し、次元 2 は行ベクトルに対応します。
%
%   [Y,Zf] = FILTER(B,A,X,Zi) は、Zi と Zf でフィルタ遅延の初期条件と最終
%   条件を与えます。Zi は、MAX(LENGTH(A),LENGTH(B))-1 の長さのベクトル、または、
%   行の長さが MAX(LENGTH(A),LENGTH(B))-1 の次元で、残りの次元が X と一致する
%   配列です。
%
%   FILTER(B,A,X,[],DIM) または FILTER(B,A,X,Zi,DIM) は、次元 DIM に対して
%   機能します。
%
%   参考 FILTER2 および Signal Processing Toolbox の FILTFILT, FILTIC.


%   Copyright 1984-2008 The MathWorks, Inc.
