#!/usr/local/bin/octave -q

% 参考：http://www.mathworks.co.jp/help/ja_JP/techdoc/creating_plots/f1-11215.html

1;	% this is script file

% arguments check
_argv = argv();
argn = length(_argv);
if argn < 1
  error("argument error\n[USAGE] $> <thisfilename> csv_file_path (options)");
end

%*****************************************
% データ読み込み
%*****************************************
csv_file = char(_argv(1));
data = dlmread(csv_file, ',', 1, 0);	% すべてのデータをバッファに格納（一行目はカラムテキスト）

x = 1:12;	% [X軸データ] 月：1,2...12月
temp_month_ave = data(:,1);	% 平均気温
precipitation = data(:,6);	% 降水量

clear data;	% バッファクリア

%*****************************************
% グラフ出力
%*****************************************
clf;
figure(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 棒グラフ：降水量（目盛：左側）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bar(x, precipitation);
hold on;	% 続いてグラフを重ね書き
ax(1) = gca;	%最初に作成した系列のハンドルを取得
set(ax(1), 'yaxislocation', 'left');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 折れ線グラフ：平均気温（目盛：右側）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 最初に作成した系列オブジェクトをコピーして次の系列に使用する（X軸：同じ、Y軸：右側の軸を使用）
ax(2) = axes('position', get(ax(1), 'position'), 'xaxislocation', 'bottom', 'yaxislocation', 'right');
plot(x, temp_month_ave, ax(2));
range_y = [min(temp_month_ave)-5 max(temp_month_ave)+5];
set(ax(2), 'yaxislocation', 'right', 'ylim', range_y);

% XLim: 棒グラフの表示が切れてしまうのでX軸の表示範囲は0～13とする
% XTick: X軸データラベルは1～12（月）のひと月ごと
set(ax, 'XLim', [0 13], 'XTick', 1:1:12);	% 毎月表示
%set(ax, 'XLim', [0 13], 'XTick', 1:2:12);	% スキップして表示

%*****************************************
% グラフタイトル、XY軸ラベル
%*****************************************
title('Weather information of Osaka 2011', 'Fontsize', 18);	% graph title
% xlabel("Month");	% 位置調整できないため下記のように手動でxlabelを貼る
lx = x(1) + (x(length(x)) - x(1)) / 2;
ly = range_y(1) - 2.5;	% 最後にプロットした系列の座標に追従
text(lx, ly, 'Month', 'Fontsize', 12, 'VerticalAlignment','top', 'HorizontalAlignment','center');
ylabel(ax(1), "Precipitation(mm)", 'Fontsize', 12);
ylabel(ax(2), "Temperature(C)", 'Fontsize', 12);

%*****************************************
% X軸のデータラベルに任意の文字列を表示
%*****************************************
% xticklabels: month name
months = ['Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; 'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec'];
% xticklabel's position
% (x, y) = (X軸プロット位置, 0)
y = range_y(1)*ones(1, length(months));
t = text(x, y, months(1:1:12, :));
% [テキスト位置調整] 水平位置：右合わせ、垂直位置：上合わせ、回転：45°
set(t, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Rotation',45);
% デフォルトのX軸データラベルを消す
set(ax, 'XTickLabel', '');
% 余白の調整
% [ratio] pos(1): left, pos(2): bottom, pos(3): width, pos(4): height
pos = [0.1 0.1 0.8 0.8];	% left right width height (image area ratio)
set(ax, 'position', pos);

% end

%*****************************************
% png形式画像ファイルに出力
%*****************************************
print('osaka2011.png', '-dpng');
exit(0);
