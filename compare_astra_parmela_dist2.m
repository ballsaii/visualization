% load dist
clear;clc;close all;
% Astra
% x[m],y[m],z[m],px[eV/c],py[eV/c],pz[eV/c],time[ns],charge[nC]
% Parmela
% x[cm],xp[mrad],y[cm],yp[mrad],Ek[MeV],time[ns],charge[nC]

astra = loaddistmat;
parmela = loaddistmat;
%%

% dist1
[x1,xp1,y1,yp1,phase1,Ek1] = astra2parmela(astra,2856);
time1 = astra.data(:,7);
charge1 = astra.data(:,8);
% dist2
x2 = parmela.data(:,1);
xp2 = parmela.data(:,2);
y2 = parmela.data(:,3);
yp2 = parmela.data(:,4);
time2 = parmela.data(:,5);
Ek2 = parmela.data(:,6);
charge2 = parmela.data(:,7);


limittime = max(time2-min(time2));

% filter
cond = find((time1-min(time1))<=limittime);
x1 = x1(cond);
y1 = y1(cond);
xp1 = xp1(cond);
yp1 = yp1(cond);
time1 = time1(cond);
charge1 = charge1(cond);
Ek1 = Ek1(cond);

% unit in mm mrad ps MeV
x1 = x1*10;
y1 = y1*10;
x2 = x2*10;
y2 = y2*10;
time1 = (time1-min(time1))*1000;
time2 = (time2-min(time2))*1000;

%%
% compare histogram
% 2D xy 
% plotden(x1,y1,charge1,100,100)
%%
% x[cm], y[cm], xp[mrad], yp[mrad], time[ns], Ek[MeV]
%
compare_hist(x1,x2)
xlim(gca,[-5 5])
xlabel('x(mm)')
ylabel('count')

compare_hist(y1,y2)
xlim(gca,[-5 5])
xlabel('y(mm)')
ylabel('count')

compare_hist(xp1,xp2)
xlim(gca,[-50 50])
xlabel('x''(mrad)')
ylabel('count')

compare_hist(yp1,yp2)
xlim(gca,[-50 50])
xlabel('y''(mrad)')
ylabel('count')
%
compare_hist(time1,time2)
xlim(gca,[0 175])
xlabel('rel. time (ps)')
ylabel('count')
%% compare scatter
% xxp, yyp, timeEk,
[a3,a4] = compare_scatter(x1,xp1,x2,xp2);
xlim([a3,a4],[-5 5])
ylim([a3,a4],[-500 500])
xlabel(a3,'x(mm)')
ylabel(a3,'x''(mrad)')
xlabel(a4,'x(mm)')
ylabel(a4,'x''(mrad)')
[a3,a4] = compare_scatter(y1,yp1,y2,yp2);
xlim([a3,a4],[-5 5])
ylim([a3,a4],[-500 500])
xlabel(a3,'y(mm)')
ylabel(a3,'y''(mrad)')
xlabel(a4,'y(mm)')
ylabel(a4,'y''(mrad)')
[a3,a4] = compare_scatter2(time1,Ek1,time2,Ek2);
xlim([a3,a4],[0 limittime*1000])
xlabel('rel.time(ps)')
ylabel('Ek(MeV)')
%%
% compare projected emittance
% data = [x[cm],xp[mrad],y[cm],y[mrad],time[ns],Ek[MeV]];
sdata{1} = [x1/10,xp1,y1/10,yp1,time1,Ek1];
sdata{2} = [x2/10,xp2,y2/10,yp2,time2,Ek2];

slice_Emin = {100};
project_Emin = {100};
numberslice = 10;

for i=1:2
sliced_data{i} = slice_dist(sdata{i},slice_Emin,'Emax',numberslice);
projected_data{i} = slice_dist(sdata{i},project_Emin,'Emax',1);

% calculate emit, normalized phasespace and phase ellipse
slice_emit{i} = get_emit(sliced_data{i});
projected_emit{i} = get_emit(projected_data{i});

transverse_phasespace{i} = normalized_phasespace(sliced_data{i},slice_emit{i});
% ellipse_x{i} = ellipse_phasespace(slice_emit{i},'x',200);
% ellipse_y{i} = ellipse_phasespace(slice_emit{i},'y',200);
end
%%
figure;
ax3 = axes;
slice_index{1} = 1:length(sliced_data{1});
slice_index{2} = 1:length(sliced_data{2});
sp1 = plot(ax3,slice_index{1},fliplr(cell2mat(slice_emit{1}.geo.x).*1E6),'Marker','*','LineStyle','-','LineWidth',1.5);
hold on;
sp2 = plot(ax3,slice_index{2},fliplr(cell2mat(slice_emit{2}.geo.x).*1E6),'Marker','d','LineStyle','--','LineWidth',1.5);
xlabel(ax3,'slice index (head to tail)');
ylabel(ax3,'geo. emittance (mm mrad)');
legend(ax3,'Astra','Parmela')
box on;
grid on;
grid minor;
%%

meanvalue{1} = mean([x1,xp1,y1,yp1,time1,Ek1]);
meanvalue{2} = mean([x2,xp2,y2,yp2,time2,Ek2]);
rmsvalue{1} = rms([x1,xp1,y1,yp1,time1,Ek1]);
rmsvalue{2} = rms([x2,xp2,y2,yp2,time2,Ek2]);
maxvalue{1} = max(Ek1);
maxvalue{2} = max(Ek2);
stat = struct('mean',meanvalue,'rms',rmsvalue,'max',maxvalue);
beampara = struct('stat',stat,'projected_emit',projected_emit);


% %% print
[file,path]=uiputfile('*.txt','Save statistic file',pwd);
filepath = fullfile(path,file);
fileworkspace =  fullfile(path,'work.mat');
save(fileworkspace);

fid = fopen(filepath,'w');

% mean value
fprintf('saving statistic file ...\n');
fprintf(fid,'mean x = %5.3f %5.3f mm\n',meanvalue{1}(1),meanvalue{2}(1));
fprintf(fid,'mean xp = %5.3f %5.3f mrad\n',meanvalue{1}(2),meanvalue{2}(2));
fprintf(fid,'mean y = %5.3f %5.3f mm\n',meanvalue{1}(3),meanvalue{2}(3));
fprintf(fid,'mean yp  = %5.3f %5.3f mrad\n',meanvalue{1}(4),meanvalue{2}(4));
fprintf(fid,'mean time = %5.3f %5.3f ns\n',meanvalue{1}(5),meanvalue{2}(5));
fprintf(fid,'mean Ek = = %5.3f %5.3f MeV\n',meanvalue{1}(6),meanvalue{2}(6));
fprintf(fid,'=============\n');
fprintf(fid,'rms x = %5.3f %5.3f mm\n',rmsvalue{1}(1),rmsvalue{2}(1));
fprintf(fid,'rms xp = %5.3f %5.3f mrad\n',rmsvalue{1}(2),rmsvalue{2}(2));
fprintf(fid,'rms y = %5.3f %5.3f mm\n',rmsvalue{1}(3),rmsvalue{2}(3));
fprintf(fid,'rms yp  = %5.3f %5.3f mrad\n',rmsvalue{1}(4),rmsvalue{2}(4));
fprintf(fid,'rms time = %5.3f %5.3f ns\n',rmsvalue{1}(5),rmsvalue{2}(5));
fprintf(fid,'rms Ek = = %5.3f %5.3f MeV\n',rmsvalue{1}(6),rmsvalue{2}(6));
fprintf(fid,'max Ek = %5.3f %5.3f MeV\n',maxvalue{1},maxvalue{2});
fprintf(fid,'=============\n');
fprintf(fid,'bunch charge = %5.3E %5.3E nC\n',sum(charge1),sum(charge2));
fprintf(fid,'=============\n');
% projected emittance
fprintf(fid,'geo emit x = %5.3f %5.3f mm mrad\n',projected_emit{1}.geo.x{1}.*1E6,projected_emit{2}.geo.x{1}.*1E6);
fprintf(fid,'geo emit y = %5.3f %5.3f mm mrad\n',projected_emit{1}.geo.y{1}.*1E6,projected_emit{2}.geo.y{1}.*1E6);
fprintf(fid,'geo emit xy = %5.3f %5.3f mm mrad\n',projected_emit{1}.geo.xy{1}.*1E6,projected_emit{2}.geo.xy{1}.*1E6);
fprintf(fid,'=============\n');
fprintf(fid,'norm emit x = %5.3f %5.3f mm mrad\n',projected_emit{1}.norm.x{1}.*1E6,projected_emit{1}.norm.x{1}.*1E6);
fprintf(fid,'norm emit y = %5.3f %5.3f mm mrad\n',projected_emit{1}.norm.y{1}.*1E6,projected_emit{1}.norm.y{1}.*1E6);
fprintf(fid,'norm emit xy = %5.3f %5.3f mm mrad\n',projected_emit{1}.norm.xy{1}.*1E6,projected_emit{1}.norm.xy{1}.*1E6);
fprintf(fid,'==========================\n');
fprintf(fid,'parmela target = %s',path);
fprintf(fid,'projected by energy = %i\n',cell2mat(project_Emin));
fprintf(fid,'sliced by energy = %i and number slice = %i\n',cell2mat(slice_Emin),numberslice);
fprintf(fid,'==========================\n');
fprintf(fid,'==========================\n');

fclose(fid);
fprintf('... done');



