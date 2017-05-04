% script create a 2x2 plot
% need parameter
function xy_simply(x,xbin,honlabel,y,ybin,vertlabel,macrocharge)
% honlabel = 'x (mm)';
% vertlabel = 'y (mm)';
charge = 'charge (nC)';
nbin = [xbin ybin];
f1 = figure;
f1.Position =[0 0 800 800];

% upper left
subplot(2,2,1)
[N,Xedges,Yedges] = histcounts2(x,y,nbin);
imagesc(Xedges,Yedges,N*macrocharge);
a1 = gca;
set(a1,'YDir','normal')

cb = colorbar;
 cb.Location = 'northoutside';
 cb.Label.String = 'Charge (nC)';
 cb.Units = 'pixels';
% cb.Position = [0,0,160,120];
 cb.AxisLocation = 'out';
 myColorMap = jet(256);
myColorMap(1,:) = 1;
colormap(myColorMap)
% upper right
subplot(2,2,2)
% h2 = histogram(y,'Orientation','horizontal');
a2 = gca;
[N,Yedges] = histcounts(y,ybin);
Ycenter = Yedges+0.5*(Yedges(2)-Yedges(1));
Ycenter(end) = []; 
stairs(Ycenter,N*macrocharge);
grid minor
% below left
subplot(2,2,3)
% h3 = histogram(x);
a3 = gca;
[N,Xedges] = histcounts(x,xbin);
Xcenter = Xedges+0.5*(Xedges(2)-Xedges(1));
Xcenter(end) = []; 
stairs(Xcenter,N*macrocharge);
grid minor
% below right



% set same limit
% set(a2, 'Xlim', get(a1, 'Ylim'));
% set(a3, 'Xlim', get(a1, 'Xlim'));
set(a1, 'Xlim', [min(x) max(x)]);

set([a1,a2,a3],'Box','on')

set(a2,'YAxisLocation','right')

a1.XLabel.String = honlabel;
a1.YLabel.String = vertlabel;

a2.XLabel.String = vertlabel;
a2.YLabel.String = charge;

a3.XLabel.String = honlabel;
a3.YLabel.String = charge;


% link axes
% linkaxes([a1,a2],'y');
% linkaxes([a1,a3],'x');
% edge color and binning method

%set(h4,'binMethod','auto');
% set view
view(a3,[180,90])

end
