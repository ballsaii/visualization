function loc = getcentroid(x,N,linsty,color)
% usage 
% getcentroid(data,bin)

% set xlimit to fitting curve
xli = get(gca,'xlim');
xPlot = linspace(xli(1),xli(2),N);

% fit distribution
pd = fitdist(x,'kernel','kernel','normal','support','unbounded');
pdf_yPlot = pdf(pd,xPlot);

% find area of histogram to convert pdf to count
[count,edge] = histcounts(x,N);

center = edge+(edge(2)-edge(1))/2;
center(end) = [];
area = trapz(center,count);

% unnormalize
yPlot = pdf_yPlot * area;

% plot in the previuos axes
hold on;

plot(xPlot,yPlot,'Color',color,'LineStyle',linsty)

% find peak and its location
[pk,loc] = findpeaks(yPlot,xPlot,'MinPeakHeight',rms(yPlot));
loc = loc(find(pk==max(pk)))

% plot peak
plot(loc,pk*1.01,'MarkerFaceColor',color,'Marker','v','MarkerEdgeColor','none')

% label peak
labecentroid = sprintf('centroid = %5.3f',loc);
text(loc+0.10,pk*1.01,labecentroid,'Color',color);
end

