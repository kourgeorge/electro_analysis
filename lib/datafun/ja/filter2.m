% FILTER2  2次元ディジタルフィルタ
%
% Y = FILTER2(B,X) は、2次元FIRフィルタ行列Bを使って、X内のデータを
% フィルタリングします。結果のYは、2次元コンボリューションを使って計算
% され、Xと同じサイズになります。 
%
% Y = FILTER2(B,X,'shape') は、'shape'で指定されるサイズで、2次元コンボ
% リューションによって計算されるYを出力します。
%     'same'  - Xと同じサイズになるように、コンボリューションの結果の中心部
%            	分を出力します(デフォルト)。
%     'valid' - ゼロを加えずに計算されたコンボリューションの結果のみを出力
%               します。size(Y) < size(X)となります。
%     'full'  - 完全な2次元コンボリューションの結果を出力します。
%               size(Y) > size(X) となります。
%
% FILTER2は、CONV2を使って、ほとんどの演算を行います。2次元コンボ
% リューションは、フィルタ行列の180度回転によるCONV2です。
%
% 入力 B, X に対するクラスのサポート:
%      float: double, single
%
% 参考 ： FILTER, CONV2.


%   Copyright 1984-2004 The MathWorks, Inc. 
