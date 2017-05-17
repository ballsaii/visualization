%% usage
% visualize a transverse profile supporting no multi-slice plot
close all;clear;clc

% load example
data = import_par(2);
% load('data.mat')

% sliced_data = slice_dist(data,'Emin','Emax',10);
projected_data = slice_dist(data,'Emin','Emax',1);
%%
x = fx(projected_data,1,1);
y = fx(projected_data,1,3);

% matlab structure
mainfig = figure;
mainfig.Position = [50,100,1500,400];

% subplot 1 
sub1 = subplot(1,3,1);
p1 = histogram2(fx(projected_data,1,1),fx(projected_data,1,3));
c1 = colorbar;
set(p1, 'BinMethod','scott','FaceColor','flat','EdgeColor','none');
colormap(sub1,linspecer(128));
view(2);

% subplot 2 for horizontal
sub2 = subplot(1,3,2);
p2 = histogram(fx(projected_data,1,1),'visible','on');
fittingstyle = '-.';
fittingcolor = 'red';
hold on;
% add fake legend

fakelegend(1) = plot(NaN,NaN,'LineStyle',fittingstyle,'Color',fittingcolor);

% fit centroid horizontal
loc_h = getcentroid(fx(projected_data,1,1),p2.NumBins,fittingstyle,fittingcolor);
%fakelg1 = legend(sub2,fakelegend(1),'horizontal dist.');

% add legend
lg1 = legend(sub2,[p2,fakelegend(1)],'horizontal dist','fitting dist');
hold off;

% subplot 3 for vertical
sub3 = subplot(1,3,3);
p3 = histogram(fx(projected_data,1,3),'visible','on');
fittingstyle = '-.';
fittingcolor = 'red';
hold on;
% add fake legend
fakelegend(2) = plot(NaN,NaN,'LineStyle',fittingstyle,'Color',fittingcolor);

% fit centroid horizontal
loc_v = getcentroid(fx(projected_data,1,3),p3.NumBins,fittingstyle,fittingcolor);
%fakelg1 = legend(sub2,fakelegend(1),'horizontal dist.');

% add legend
lg2 = legend(sub3,[p3,fakelegend(2)],'vertical dist','fitting dist');

hold off;
set([lg1,lg2],'Location','southeast','Orientation','horizontal');
set([p2,p3],'EdgeColor','black','EdgeAlpha',0.1,'DisplayStyle','bar','BinMethod','scott','LineWidth',0.5,'visible','on');

set(sub3,'ylim',get(sub2,'ylim'));
set([sub2,sub3],'XTick',get(sub1,'XTick'));

% add units to axes
xunit = 'horizontal position (mm)';
yunit = 'vertical position (mm)';
histunit = 'count';
sub1.XLabel.String = xunit;
sub1.YLabel.String = yunit;

sub2.XLabel.String = xunit;
sub2.YLabel.String = histunit;

sub3.XLabel.String = yunit;
sub3.YLabel.String = histunit;


% centroid_fit = fitdist()
function output = fx(sliced_data,i,j)
output = sliced_data{i}(:,j)*10;
end
%%



