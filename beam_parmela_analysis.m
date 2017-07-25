function beam_parmela_analysis(ii,project_Emin,slice_Emin,numerofslice) 
%% usage
% visualize beam analysis

% load example
[data,location] = import_par(ii);

% load 'data.mat'
%% Calculation

% sliced and projected dist. 
sliced_data = slice_dist(data,slice_Emin,'Emax',numerofslice);
projected_data = slice_dist(data,project_Emin,'Emax',1);

% calculate emit, normalized phasespace and phase ellipse
slice_emit = get_emit(sliced_data);
projected_emit = get_emit(projected_data);
x = projected_data{1}(:,1)*10; % unit in mm 
y = projected_data{1}(:,3)*10;
transverse_phasespace = normalized_phasespace(sliced_data,slice_emit);
ellipse_x = ellipse_phasespace(slice_emit,'x',200);
ellipse_y = ellipse_phasespace(slice_emit,'y',200);

% constant parameters
f0 = 2856;
Ibeam = 2.6;
number = 350000;
chargepermacro = chargemacro( Ibeam, number, f0);
%% Beam Profile

% figure
f0 = figure;
f0.Position = [50,100,1500,400];

% subplot 1 
sub1 = subplot(1,3,1);
p1 = histogram2(x,y);
c1 = colorbar;
set(p1, 'BinMethod','scott','FaceColor','flat','EdgeColor','none');
colormap(sub1,linspecer(128));
view(2);

% subplot 2 for horizontal
sub2 = subplot(1,3,2);
p2 = histogram(x,'visible','on','BinMethod','fd');
fittingstyle = '-.';
fittingcolor = 'red';
hold on;
% add fake legend

fakelegend(1) = plot(NaN,NaN,'LineStyle',fittingstyle,'Color',fittingcolor);

% fit centroid horizontal
loc_h = getcentroid(x,p2.NumBins,fittingstyle,fittingcolor);
%fakelg1 = legend(sub2,fakelegend(1),'horizontal dist.');

% add legend
lg1 = legend(sub2,[p2,fakelegend(1)],'horizontal dist','fitting dist');
hold off;

% subplot 3 for vertical
sub3 = subplot(1,3,3);
p3 = histogram(y,'visible','on','BinMethod','fd');
fittingstyle = '-.';
fittingcolor = 'red';
hold on;
% add fake legend
fakelegend(2) = plot(NaN,NaN,'LineStyle',fittingstyle,'Color',fittingcolor);

% fit centroid horizontal
loc_v = getcentroid(y,p3.NumBins,fittingstyle,fittingcolor);
%fakelg1 = legend(sub2,fakelegend(1),'horizontal dist.');

% add legend
lg2 = legend(sub3,[p3,fakelegend(2)],'vertical dist','fitting dist');

hold off;
set([lg1,lg2],'Location','southeast','Orientation','horizontal');
set([p2,p3],'EdgeColor','black','EdgeAlpha',0.1,'DisplayStyle','bar','LineWidth',0.5,'visible','on');

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

%% Transverse Phase Apace

% figure
f1 = figure;
f1.Position = [0,0,1500,600];
for i=1:8
    ax(i) = subplot(2,4,i);
end

% color line theme
clor = linspecer(length(sliced_data));

for i=1:length(sliced_data)
    scatter(ax(1),transverse_phasespace.geo.x.h{i}*1E3,transverse_phasespace.geo.x.v{i}*1E3,'.','MarkerEdgeColor',clor(i,:));
    hold(ax(1),'on');
    plot(ax(2),ellipse_x.geo.h{i}*1E3,ellipse_x.geo.v{i}*1E3,'-','Color',clor(i,:));
    hold(ax(2),'on');

    scatter(ax(3),transverse_phasespace.norm.x.h{i}*sqrt(1E3),transverse_phasespace.norm.x.v{i}*sqrt(1E3),'.','MarkerEdgeColor',clor(i,:));
    hold(ax(3),'on');
    plot(ax(4),ellipse_x.norm.h{i}*sqrt(1E3),ellipse_x.norm.v{i}*sqrt(1E3),'-','Color',clor(i,:));
    hold(ax(4),'on');

    scatter(ax(5),transverse_phasespace.geo.y.h{i}*1E3,transverse_phasespace.geo.y.v{i}*1E3,'.','MarkerEdgeColor',clor(i,:));
    hold(ax(5),'on');
    plot(ax(6),ellipse_y.geo.h{i}*1E3,ellipse_y.geo.v{i}*1E3,'-','Color',clor(i,:));
    hold(ax(6),'on');

    scatter(ax(7),transverse_phasespace.norm.y.h{i}*sqrt(1E3),transverse_phasespace.norm.y.v{i}*sqrt(1E3),'.','MarkerEdgeColor',clor(i,:));
    hold(ax(7),'on');
    plot(ax(8),ellipse_y.norm.h{i}*sqrt(1E3),ellipse_y.norm.v{i}*sqrt(1E3),'-','Color',clor(i,:));
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
    ax(i).XLabel.String = 'mm';
    ax(i).YLabel.String = 'mrad';
end

for i=[3,4,7,8]
    ax(i).XLabel.String = 'mm^{1/2}';
    ax(i).YLabel.String = 'mm^{1/2}';
end

%% Longitudinal Phase Space

% figure
f2 = figure;
f2.Position = [50,100,1500,400];

% load
projected_phase = projected_data{1}(:,5);
projected_time = phase2time(projected_phase,2856)*1E3; % unit in ps
projected_Ek = projected_data{1}(:,6); % unit in MeV
for i=1:length(sliced_data)
sliced_phase{i} = sliced_data{i}(:,5);
sliced_time{i} = phase2time(sliced_phase{i},2856)*1E3; % unit in ps
sliced_Ek{i} = sliced_data{i}(:,6); % unit in MeV
end

% plot
for j=1:6
    ax2(j) = subplot(2,3,j);
end
clor = linspecer(length(sliced_data));

% plot
    lp1 = scatter(ax2(1),projected_time,projected_Ek,'.','MarkerEdgeColor','black');
    lp2 = histogram(ax2(2),projected_time,'FaceColor','black');
    lp3 = histogram(ax2(3),projected_Ek,'FaceColor','black');

for i=1:length(sliced_data)
    lp4 = scatter(ax2(4),sliced_time{i},sliced_Ek{i},'.','MarkerEdgeColor',clor(i,:));
    hold(ax2(4),'on');
    lp5 = histogram(ax2(5),sliced_time{i},'FaceColor',clor(i,:));
    hold(ax2(5),'on');
    lp6 = histogram(ax2(6),sliced_Ek{i},'FaceColor',clor(i,:));
    hold(ax2(6),'on');
    set([lp5,lp6],'EdgeColor','black','EdgeAlpha',0.1,'DisplayStyle','bar','BinMethod','scott','LineWidth',0.5,'visible','on');

end

set([lp2,lp3],'EdgeColor','black','EdgeAlpha',0.1,'DisplayStyle','bar','BinMethod','scott','LineWidth',0.5,'visible','on');

% set axes
set(ax2(4),'Xlim',get(ax2(1),'Xlim'),'Ylim',get(ax2(1),'Ylim'));
set(ax2(5),'Xlim',get(ax2(2),'Xlim'));
set(ax2(6),'Xlim',get(ax2(3),'Xlim'));

% x y label
xlabel(ax2(1),'time (ps)');
ylabel(ax2(1),'Ek (MeV)');

xlabel(ax2(2),'time (ps)');
ylabel(ax2(2),'count');

xlabel(ax2(3),'Energy (MeV)');
ylabel(ax2(3),'count');

xlabel(ax2(4),'time (ps)');
ylabel(ax2(4),'Ek (MeV)');

xlabel(ax2(5),'time (ps)');
ylabel(ax2(5),'count');

xlabel(ax2(6),'Energy (MeV)');
ylabel(ax2(6),'count');
%% Sliced Emittance
% figure
f3 = figure;
f3.Position = [50,100,800,600];

% plot
for j=1:6
    ax3(j) = subplot(2,3,j);
end
clor = linspecer(length(sliced_data));

    slice_index = 1:length(sliced_data);
    
    yyaxis(ax3(1),'left')
    
    sp1 = plot(ax3(1),slice_index,cell2mat(slice_emit.geo.x).*1E6,'Marker','*','LineStyle','-');
    ylabel(ax3(1),'geometric emittance (mm mrad)');
    yyaxis(ax3(1),'right')
    sp2 = plot(ax3(1),slice_index,cell2mat(slice_emit.norm.x).*1E6,'Marker','+','LineStyle','-');
    ylabel(ax3(1),'normalized emittance (mm mrad)');
    
    yyaxis(ax3(2),'left')
    sp3 = plot(ax3(2),slice_index,cell2mat(slice_emit.geo.y).*1E6,'Marker','*','LineStyle','-');
    ylabel(ax3(2),'geometric emittance (mm mrad)');
    yyaxis(ax3(2),'right')
    sp4 = plot(ax3(2),slice_index,cell2mat(slice_emit.norm.y).*1E6,'Marker','+','LineStyle','-');
    ylabel(ax3(2),'normalized emittance (mm mrad)');
    
    yyaxis(ax3(3),'left')
    sp5 = plot(ax3(3),slice_index,cell2mat(slice_emit.geo.xy).*1E6,'Marker','*','LineStyle','-');
    ylabel(ax3(3),'geometric emittance (mm mrad)');
    yyaxis(ax3(3),'right')
    sp6 = plot(ax3(3),slice_index,cell2mat(slice_emit.norm.xy).*1E6,'Marker','+','LineStyle','-');
    ylabel(ax3(3),'normalized emittance (mm mrad)');

    spb1 = bar(ax3(4),slice_index,cell2mat(slice_emit.slice.macroparticle).*chargepermacro*1E9);
    ylabel(ax3(4),'charge (nC)');
    
    sp7 = plot(ax3(5),slice_index,cellfun(@std,sliced_Ek),'Marker','*','LineStyle','-');
    ylabel(ax3(5),'\sigma_{E_{k}} (MeV))');
    
    sp8 = plot(ax3(6),slice_index,cellfun(@mean,sliced_Ek),'Marker','+','LineStyle','-');
    ylabel(ax3(6),'mean energy (MeV)');
    
    % x label
    for i =[1,2,3,4,5,6]
    ax3(i).XLabel.String = 'Slice index';
    end
    
for j=1:6
    grid(ax3(j),'on');
    grid(ax3(j),'minor');
    ax3(j).FontSize = 10;
    ax3(j).FontWeight = 'bold';
    ax3(j).LineWidth = 1.5;
    ax3(j).XTick = slice_index;
    lg2(j) = legend('show');
    lg2(j).Interpreter = 'tex';
    lg2(j).FontSize = 12;
    lg2(j).Box = 'off';
end
    
    lg2(1) = legend(ax3(1),'\epsilon_x','\epsilon_{Nx}');
    lg2(2) = legend(ax3(2),'\epsilon_y','\epsilon_{Ny}');
    lg2(3) = legend(ax3(3),'\epsilon_{xy}','\epsilon_{Nxy}');
    legend(ax3(4),'off');legend(ax3(5),'off');legend(ax3(6),'off');
    
    loca2 = fileparts(location);
    savefile = fullfile(loca2,'stat.mat');
    save(savefile)
%% Beam statistic
clc
% load
xp = projected_data{1}(:,2); % unit in mrad
yp = projected_data{1}(:,4); % unit in mrad
% already load x y projected_Ek projected_time

% mean value
meanvalue = mean([x,xp,y,yp,projected_time,projected_Ek]);
rmsvalue = rms([x,xp,y,yp,projected_time,projected_Ek]);
fprintf('==========================\n');
fprintf('mean x = %5.3f mm\n',meanvalue(1));
fprintf('mean xp = %5.3f mradf\n',meanvalue(2));
fprintf('mean y = %5.3f mm\n',meanvalue(3));
fprintf('mean yp = %5.3f mrad\n',meanvalue(4));
fprintf('mean time = %5.3E ns\n',meanvalue(5));
fprintf('mean Ek = %5.3f MeV\n',meanvalue(6));
fprintf('=============\n');
fprintf('rms x = %5.3f mm\n',rmsvalue(1));
fprintf('rms xp = %5.3f mrad\n',rmsvalue(2));
fprintf('rms y = %5.3f mm\n',rmsvalue(3));
fprintf('rms yp = %5.3f mrad\n',rmsvalue(4));
fprintf('rms time = %5.3E ns\n',rmsvalue(5));
fprintf('rms Ek = %5.3f MeV\n',rmsvalue(6));
fprintf('max Ek = %5.3f MeV\n',max(projected_Ek));
fprintf('=============\n');
fprintf('centroid x = %5.3f mm\n',loc_h);
fprintf('centroid y = %5.3f mm\n',loc_v);
fprintf('=============\n');
fprintf('bunch charge = %5.3E nC \n',projected_emit.slice.macroparticle{1}.* chargepermacro*1E9);
fprintf('=============\n');
% prjected emittance
fprintf('geo emit x = %5.3f mm mrad \n',projected_emit.geo.x{1}.*1E6);
fprintf('geo emit y = %5.3f mm mrad \n',projected_emit.geo.y{1}.*1E6);
fprintf('geo emit xy = %5.3f mm mrad \n',projected_emit.geo.xy{1}.*1E6);
fprintf('=============\n');
fprintf('norm emit x = %5.3f mm mrad \n',projected_emit.norm.x{1}.*1E6);
fprintf('norm emit y = %5.3f mm mrad \n',projected_emit.norm.y{1}.*1E6);
fprintf('norm emit xy = %5.3f mm mrad \n',projected_emit.norm.xy{1}.*1E6);
fprintf('==========================\n');
parmela_loca = sprintf('parmela target = %s',location);
disp(parmela_loca)
fprintf('projected by energy = %i\n',cell2mat(project_Emin));
fprintf('sliced by energy = %i and number slice = %i\n',cell2mat(slice_Emin),numerofslice);
fprintf('==========================\n');
fprintf('==========================\n');
end















