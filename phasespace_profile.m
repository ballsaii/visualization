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
%% Back up for complete phase space
% matlab structure for x phasespace
mainfig = figure;
mainfig.Position = [0,0,1200,600];
mainfig.PaperType = 'A4';
mainfig.PaperOrientation = 'landscape';

sub(1) = subplot(2,4,1);
sub(2) = subplot(2,4,2);
sub(3) = subplot(2,4,3);
sub(4) = subplot(2,4,4);

% color line theme
clor = linspecer(length(sliced_data));


for i=1:length(sliced_data)
scatter(sub(1),transverse_phasespace.geo.x.h{i},transverse_phasespace.geo.x.v{i},'.','MarkerEdgeColor',clor(i,:));
hold(sub(1),'on');
plot(sub(2),ellipse_x.geo.h{i},ellipse_x.geo.v{i},'-','Color',clor(i,:));
hold(sub(2),'on');

scatter(sub(3),-transverse_phasespace.norm.x.h{i},transverse_phasespace.norm.x.v{i},'.','MarkerEdgeColor',clor(i,:));
hold(sub(3),'on');
plot(sub(4),ellipse_x.norm.h{i},ellipse_x.norm.v{i},'-','Color',clor(i,:));
hold(sub(4),'on');

end


sub(5) = subplot(2,4,5);
sub(6) = subplot(2,4,6);
sub(7) = subplot(2,4,7);
sub(8) = subplot(2,4,8);

for i=1:length(sliced_data)
scatter(sub(5),transverse_phasespace.geo.y.h{i},transverse_phasespace.geo.y.v{i},'.','MarkerEdgeColor',clor(i,:));
hold(sub(5),'on');
 plot(sub(6),ellipse_y.geo.h{i},ellipse_y.geo.v{i},'-','Color',clor(i,:));
hold(sub(6),'on');

scatter(sub(7),-transverse_phasespace.norm.y.h{i},transverse_phasespace.norm.y.v{i},'.','MarkerEdgeColor',clor(i,:));
hold(sub(7),'on');
plot(sub(8),ellipse_y.norm.h{i},ellipse_y.norm.v{i},'-','Color',clor(i,:));
hold(sub(8),'on');

    % add legend
    textlg{i} = sprintf('%d',i);
end

% set box for all
set(sub,'box','on')


% set grid and minor grid for all
for j=1:length(sub)
grid(sub(j),'on');
grid(sub(j),'minor');
end

lgpst = get(sub(8),'Position');
lg = legend(sub(8),textlg);
oldlgpst =lg.Position;
lg.Position = [lgpst(1)*1.22 oldlgpst(2) oldlgpst(3) oldlgpst(4)];
lg.Title.String = 'slice index';
lg.Box = 'off';

% set xlabel and ylabel



saved_folder = uigetdir(pwd,'Save images in folder');
saveimage(sub(1),saved_folder,'phase_space_x.png')

