%% usage
% visualize a phase space profile supporting multi-slice plot
close all;clear;clc

% load example
load 'data.mat';

% slice dist
sliced_data = slice_dist(data,{80},'Emax',5);
% projected_data = slice_dist(data,'Emin','Emax',1);

% calculate emit, normalized phasespace and phase ellipse
slice_emit = get_emit(sliced_data);
transverse_phasespace = normalized_phasespace(sliced_data,slice_emit);
ellipse_x = ellipse_phasespace(slice_emit,'x',200);
ellipse_y = ellipse_phasespace(slice_emit,'y',200);
close all;
%
typeplot = 'all';
%% Back up for complete phase space
% matlab structure for x phasespace

switch typeplot
    case 'ind'
        sub(1) = figure; ax(1) = axes;
        sub(2) = figure; ax(2) = axes;
        sub(3) = figure; ax(3) = axes;
        sub(4) = figure; ax(4) = axes;
        sub(5) = figure; ax(5) = axes;
        sub(6) = figure; ax(6) = axes;
        sub(7) = figure; ax(7) = axes;
        sub(8) = figure; ax(8) = axes;
        filename = 'phase_space_ind';
    case 'all'
        sub = figure;
        sub.Position = [0,0,1500,600];
        for i=1:8
        ax(i) = subplot(2,4,i);
        end
        filename = 'overview';
        
end
% color line theme
clor = linspecer(length(sliced_data));

for i=1:length(sliced_data)
scatter(ax(1),transverse_phasespace.geo.x.h{i},transverse_phasespace.geo.x.v{i},'.','MarkerEdgeColor',clor(i,:));
hold(ax(1),'on');
plot(ax(2),ellipse_x.geo.h{i},ellipse_x.geo.v{i},'-','Color',clor(i,:));
hold(ax(2),'on');

scatter(ax(3),-transverse_phasespace.norm.x.h{i},transverse_phasespace.norm.x.v{i},'.','MarkerEdgeColor',clor(i,:));
hold(ax(3),'on');
plot(ax(4),ellipse_x.norm.h{i},ellipse_x.norm.v{i},'-','Color',clor(i,:));
hold(ax(4),'on');

end



for i=1:length(sliced_data)
scatter(ax(5),transverse_phasespace.geo.y.h{i},transverse_phasespace.geo.y.v{i},'.','MarkerEdgeColor',clor(i,:));
hold(ax(5),'on');
plot(ax(6),ellipse_y.geo.h{i},ellipse_y.geo.v{i},'-','Color',clor(i,:));
hold(ax(6),'on');

scatter(ax(7),-transverse_phasespace.norm.y.h{i},transverse_phasespace.norm.y.v{i},'.','MarkerEdgeColor',clor(i,:));
hold(ax(7),'on');
plot(ax(8),ellipse_y.norm.h{i},ellipse_y.norm.v{i},'-','Color',clor(i,:));
hold(ax(8),'on');

    % add legend
    textlg{i} = sprintf('%d',i);
end

% set box for all
set(ax,'box','on')

% set grid and minor grid for all
for j=1:8
grid(ax(j),'on');
grid(ax(j),'minor');
lg(j) = legend(ax(j),textlg);
lg(j).Title.String = 'slice index';
lg(j).Location = 'eastoutside';
lg(j).Box = 'off';
ax(j).FontSize = 12;
ax(j).FontWeight = 'bold';
ax(j).LineWidth = 1.2;
end

% set xlabel and ylabel
for i=[1,2,5,6]
ax(i).XLabel.String = 'm';
ax(i).YLabel.String = 'rad';
end

for i=[3,4,7,8]
ax(i).XLabel.String = 'm^{1/2}';
ax(i).YLabel.String = 'm^{1/2}';
end


% saved_folder = uigetdir(pwd,'Save images in folder');
% saveimage(sub,saved_folder,filename)

