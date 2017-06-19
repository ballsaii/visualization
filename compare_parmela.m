%% First
clear;close all;clc;

%%
id = inputdlg({'Number of macroparticle:',...
            'Cathode current (I):',...
            'Frequency(MHz):',...
            'ne:',...
            'ref phase:'},'Parmela distribution 1', [1 50]);      
id2 = inputdlg({'Number of macroparticle:',...
            'Cathode current (I):',...
            'Frequency(MHz):',...
            'ne:',...
            'ref phase:'},'Parmela distribution 2', [1 50]);   
% load
[data1,location1] = import_par(str2num(id{4}));
[data2,location2] = import_par(str2num(id2{4}));

%% cal        
Nmacro_particle1 = str2num(id{1});
Icathode1 = str2num(id{2});
f01 = str2num(id{3});
ref_phase1 = str2num(id{5});
chargepermacro1 = Icathode1/(f01*Nmacro_particle1*1E6); % unit in C

x1 = data1(:,1); % unit in cm
xp1 = data1(:,2); % unit in mrad
y1 = data1(:,3); % unit in cm
yp1 = data1(:,4); % unit in mrad
time_ref1 = phase2time(ref_phase1,f01)*1E3; % unit in ps
time1 = phase2time(data1(:,5),f01)*1000+time_ref1; % unit in ps
Ek1 = data1(:,6); % unit in MeV

x1=10*x1; % unit in mm
y1=10*y1; % unit in mm

%
Nmacro_particle2 = str2num(id2{1});
Icathode2 = str2num(id2{2});
f02 = str2num(id2{3});
ref_phase2 = str2num(id2{5});
chargepermacro1 = Icathode2/(f02*Nmacro_particle1*1E6); % unit in C

x2 = data2(:,1); % unit in cm
xp2 = data2(:,2); % unit in mrad
y2 = data2(:,3); % unit in cm
yp2 = data2(:,4); % unit in mrad
time_ref2 = phase2time(ref_phase2,f02)*1E3; % unit in ps
time2 = phase2time(data2(:,5),f02)*1000+time_ref2; % unit in ps
Ek2 = data2(:,6); % unit in MeV

x2=10*x2; % unit in mm
y2=10*y2; % unit in mm


%% hist x and y, x' and y' 

% x
f1 = figure;
p1 = histogram(x1);
hold on;
p2 = histogram(x2);
set([p1,p2],'BinMethod','fd')
hold off;
a1 = gca;
a1.XLabel.String = 'horizontal beam size (mm)';
a1.YLabel.String = 'counts';
a1.XLim = [-4.5 4.5];
lg(1) = legend(a1,'INPUT9','INPUT40');

%y
f2 = figure;
p3 = histogram(y1);
hold on;
p4 = histogram(y2);
set([p3,p4],'BinMethod','fd')
hold off;
a2 = gca;
a2.XLabel.String = 'vertical beam size (mm)';
a2.YLabel.String = 'counts';
a2.XLim = [-4.5 4.5];
lg(2) = legend(a2,'INPUT9','INPUT40');
%%
% xp
f3 = figure;
p5 = histogram(xp1,200);
hold on;
p6 = histogram(xp2,200);
% set([p5,p6],'BinMethod','fd')
hold off;
a3 = gca;
a3.XLabel.String = 'horizontal divergence (mrad)';
a3.YLabel.String = 'counts';
a3.XLim = [-50 50];
lg(3) = legend(a3,'INPUT9','INPUT40');

%yp
f4 = figure;
p7 = histogram(yp1);
hold on;
p8 = histogram(yp2);
% set([p7,p8],'BinMethod','fd')
hold off;
a4 = gca;
a4.XLabel.String = 'vertical divergence (mrad)';
a4.YLabel.String = 'counts';
a4.XLim = [-50 50];
lg(4) = legend(a4,'INPUT9','INPUT40');
%%
% time
f5 = figure;
p9 = histogram(time1);
hold on;
p10 = histogram(time2);
set([p9,p10],'BinMethod','fd')

hold off;
a5 = gca;
a5.XLabel.String = 'time (ps)';
a5.YLabel.String = 'counts';
% a5.XLim = [-50 50];
lg(5) = legend(a5,'INPUT9','INPUT40');

% Ek
f6 = figure;
p11 = histogram(Ek1);
hold on;
p12 = histogram(Ek2);
set([p11,p12],'BinMethod','fd')
hold off;
a6 = gca;
a6.XLabel.String = 'Ek (MeV)';
a6.YLabel.String = 'counts';
% a4.XLim = [-50 50];
lg(6) = legend(a6,'INPUT9','INPUT40');

set([p1,p3,p5,p7,p9,p11],'FaceAlpha',0.6)
set([p2,p4,p6,p8,p10,p12],'FaceAlpha',0.6)
set(lg(1:6),'Location','northwest')
%% print 

