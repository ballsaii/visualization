%% usage
% visualize a transverse profile supporting multi-slice plot

% load example
load 'data.mat';
sliced_data = slice_dist(data,'Emin','Emax',10);
projected_data = slice_dist(data,'Emin','Emax',1);
%%
x = fx(projected_data,1,1);
y = fx(projected_data,1,3);

% matlab structure
mainfig = figure;
mainfig.Position = [50,100,1000,400];

% subplot 1 
sub1 = subplot(1,2,1);
p1 = histogram2(fx(projected_data,1,1),fx(projected_data,1,3));
c1 = colorbar;
set(p1, 'BinMethod','scott','FaceColor','flat','EdgeColor','none');
colormap(sub1,linspecer(128));
view(2);

% subplot 2
sub2 = subplot(1,2,2);
p2 = histogram(fx(projected_data,1,1));
hold on;
p3 = histogram(fx(projected_data,1,3));
set([p2,p3],'EdgeColor','none','DisplayStyle','stairs','BinMethod','scott')
set(p3,'LineStyle','--');
hold on;
fakelegend = zeros(2, 1);
fakelegendcolor = linspecer(2);
fakelegend(1) = plot(NaN,NaN,'LineStyle','-','Color',fakelegendcolor(1,:));
fakelegend(2) = plot(NaN,NaN,'LineStyle','--','Color',fakelegendcolor(2,:));
fakelg = legend(fakelegend,'horizontal','vertical');
set(fakelg,'Box','off','Location','best')

% fit centroid
[xc,yc] = getcentroid(p2)


% centroid_fit = fitdist()
function output = fx(sliced_data,i,j)
output = sliced_data{i}(:,j);
end
%%



