function compare_hist( x1,x2 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

f1=figure;
a = axes;
p1 = histogram(x1);
hold on;
p2 = histogram(x2);
set([p1,p2],'DisplayStyle','stairs','Normalization','count')
set(p1,'LineStyle','-','EdgeColor','r','LineWidth',1.5);
set(p2,'LineStyle','-.','EdgeColor','b','LineWidth',1.5);
legend off
hold on;
fakelegend(1) = plot(NaN,NaN,'LineStyle','-','Color','r','LineWidth',1.5);
hold on;
fakelegend(2) = plot(NaN,NaN,'LineStyle','-.','Color','b','LineWidth',1.5);
lg1 = legend(a,[fakelegend(1),fakelegend(2)],'Astra','Parmela');
box on;
grid on;
grid minor;
end

