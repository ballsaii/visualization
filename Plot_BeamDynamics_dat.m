clear;
clc;
% close all;

[FileName,PathName] = uigetfile('*.*','Select Outputfile from SC software');
FullName = fullfile(PathName,FileName);
AllData = load(FullName);

%% Final Value 
Z = AllData(:,1);
Xrms = AllData(:,4);
Yrms = AllData(:,5);
emitX = AllData(:,2);
emitY = AllData(:,3);
betaX = AllData(:,7);
betaY = AllData(:,8);
alphaX = AllData(:,9);
alphaY = AllData(:,10);

gammaX =( 1+alphaX.^2)./betaX;
phiX = atan(2*alphaX./(gammaX-betaX))/2;
gammaY =( 1+alphaY.^2)./betaY;
phiY = atan(2*alphaY./(gammaY-betaY))/2;
% Z_sizeX,sizeY Plot
figure;
FontSize = 16;
set(gcf, 'units','inch','position', [2 2 8 9],'color','w');
set(gcf, 'InvertHardCopy', 'off');

subplot(3,1,1)
plot(Z,Xrms,'r',Z,Yrms,'--b', 'LineWidth',2);
ylim([0,2.5]);
set(gca, 'FontSize',FontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
hold on;
Q3_pos = 0.326;
Q4_pos = 0.576;
Q5_pos = 1.371;
Q6_pos = 1.616;
Q7_pos = 2.903;
Q8_pos = 3.378;
Q9_pos = 4.931;
Q10_pos = 5.111;
% vline(Q3_pos,'-g','Q3');
% vline(Q4_pos,'-g','Q4');
% vline(Q5_pos,'-g','Q5');
% vline(Q6_pos,'-g','Q6');
% vline(Q7_pos,'-g','Q7');
% vline(Q8_pos,'-g','Q8');
% vline(Q9_pos,'-g','Q9');
% vline(Q10_pos,'-g','Q10');

% axis([0 +inf 0 +inf]);
hold off;
box on;
grid on;
xlabel('Z [m]');
ylabel('\sigma_x,\sigma_y [mm]' );
title(sprintf('%s \n Final value --> %.4f, %.4f',FileName,Xrms(end),Yrms(end)));
legend('\sigma_x','\sigma_y','Orientation','Horizontal','Location','best');

subplot(3,1,2)
plot(Z,emitX,'r',Z,emitY,'--b', 'LineWidth',2);        
set(gca, 'FontSize',FontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
% axis([0 +inf 0 +inf]);
box on;
grid on;
xlabel('Z [m]');
ylabel('\epsilon_x,\epsilon_y [mm mrad]' );
title(sprintf('Final value --> %.4f, %.4f',emitX(end),emitY(end)));
legend('\epsilon_x','\epsilon_y','Orientation','Horizontal','Location','best');

subplot(3,1,3)
plot(Z,betaX,'r',Z,betaY,'--b', 'LineWidth',2);     
set(gca, 'FontSize',FontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
% axis([0 +inf 0 +inf]);
box on;
grid on;
xlabel('Z [m]');
ylabel('\beta_x,\beta_y [m]' );
title(sprintf('Final value --> %.4f, %.4f',betaX(end),betaY(end)));
legend('\beta_x','\beta_y','Orientation','Horizontal','Location','best');

% subplot(5,1,4)
% plot(Z,alphaX,'r',Z,alphaY,'--b', 'LineWidth',2);        
% set(gca, 'FontSize',FontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
% % axis([0 +inf 0 +inf]);
% box on;
% grid on;
% xlabel('Z [m]');
% ylabel('\alpha_x,\alpha_y [mm]' );
% title(sprintf('Final value --> %.4f, %.4f',alphaX(end),alphaY(end)));
% legend('\alpha_x','\alpha_y','Orientation','Horizontal','Location','best');
% 
% subplot(5,1,5)
% plot(Z,phiX,'r',Z,phiY,'--b', 'LineWidth',2);        
% set(gca, 'FontSize',FontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
% % axis([0 +inf 0 +inf]);
% box on;
% grid on;
% xlabel('Z [m]');
% ylabel('\phi_x,\phi_y [mm]' );
% title(sprintf('Final value --> %.4f, %.4f',phiX(end),phiY(end)));
% legend('\phi_x','\phi_y','Orientation','Horizontal','Location','best');

