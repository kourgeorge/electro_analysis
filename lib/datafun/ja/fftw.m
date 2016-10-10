% FFTW   FFTWライブラリランタイムアルゴリズムチューニングコントロール
%        とのインタフェース
% 
% MATLABの FFT、IFFT、FFT2、IFFT2、FFTN、IFFTN 関数は、FFTW と呼ばれる
% ライブラリを使います。FFTW ライブラリは、特定の大きさと次元のFFTを
% 計算するための最速の計算手法を実験的に決定する能力をもっています。
% FFTW 関数は、このランタイムアルゴリズムチューニングへのインタフェースを
% 提供します。
%
% FFTW('planner', METHOD) は、FFT、IFFT、FFT2、IFFT2、FFTN、IFFTN への
% 呼び出しで使用するFFTW計画手法を設定します。METHOD は、'estimate', 
% 'measure', 'patient' および、'exhaustive' か 'hybrid' の文字列のいずれか
% 1つです。計画手法が 'estimate' の場合、FFTW ライブラリは高速の
% ヒューリスティックに基づくアルゴリズムを選択します。結果のアルゴリズムは
% 時々最適です。'measure' を指定すると、FFTW ライブラリは、与えられた
% 大きさの FFT を計算するために多くの異なるアルゴリズムを試します。
% ライブラリは、次回同じ大きさのFFTを計算するときに再利用できるように
% 内部の "wisdom" データベースに結果のキャッシュに格納します。'patient' と
% 'exhaustive' の手法は、計算時間が非常に長くなることを除けば 'measure' と
% 似ています。計画手法が 'hybrid' の場合、MATLABは8192以下のFFTの次元で
% 'measure' 法を使用し、より大きな次元に対して 'estimate' 法を使用します。
% デフォルトの計画手法は、'hybrid' です。
%
% METHOD = FFTW('planner') は、カレントの計画手法を出力します。
%
% STR = FFTW('wisdom') は、FFTWライブラリの内部的なwisdomデータベースを
% 文字列として出力します。文字列は保存することができ、その後で、つぎの
% シンタックスを使って、あとのMATLABセッションに再利用することができます。
%
% FFTW('wisdom',STR) は、FFTWライブラリの内部的なwisdom データベース内に
% 文字列として表された FFTW wisdom を読み込みます。FFTW('wisdom','')、
% または FFTW('wisdom',[]) は、内部的なwisdomデータベースをクリアします。
%
% FFTW ライブラリに関する情報は、http://www.fftw.org を参照してください。
%
% 参考 FFT, FFT2, FFTN, IFFT, IFFT2, IFFTN, FFTSHIFT.


%   Copyright 1984-2004 The MathWorks, Inc.
