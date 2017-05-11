function ellipse_phasespace( emit,axiss )
% usage
% ellipse_phasespace(emit)
% ellipse equation,  gamma*x^2 + 2*alpha*x*xp + beta*xp^2 = emit
% general form of ellipse ax^2+2bxy+cy^2+2dx+2fy+g=0

% load
switch axiss
    case 'x'
        alpha = emit.Twiss.alpha.form0.x;
        beta = emit.Twiss.beta.form0.x;
        gamma = emit.Twiss.gamma.form0.x;
        emit = emit.geo.x;
        h_label = 'x (mm)';
        v_label = 'x'' (mrad)';
        h1_label = 'x_{N} (mm^{1/2})';
        v1_label = 'x_{N}'' (mm^{1/2})';
    case 'y'
        alpha = emit.Twiss.alpha.form0.x;
        beta = emit.Twiss.beta.form0.x;
        gamma = emit.Twiss.gamma.form0.x;
        emit = emit.geo.x;
        h_label = 'y (mm)';
        v_label = 'y'' (mrad)';
        h1_label = 'y_{N} (mm^{1/2})';
        v1_label = 'y_{N}'' (mm^{1/2})';
end

f1 = figure;
% general ellipse phase space
sub1 = subplot(1,2,1);
% normalized ellipse phase space
sub2 = subplot(1,2,2);
% color lines
cline = linspecer(length(alpha));
% for each slice
for i=1:length(alpha)

    % test load Twiss to coefficient in general form
%     a = 9;
%     b = -1;
%     c = 1;
%     d = 0;
%     f = 0;
%     g = -9;

    a = gamma{i};
    b = alpha{i};
    c = beta{i};
    d = 0;
    f = 0;
    g = -emit{i};
    % center
    x0 = 0; % since d and f = 0
    xp0 = 0;
    
    % semi-axis lengths
    semi_axis_a = sqrt(2*(a*(f^2)+c*(d^2)+g*(b^2)-2*b*d*f-a*c*g)/...
        (((b^2)-a*c)*(sqrt(((a-c)^2)+4*(b^2))-(a+c))));
    
    semi_axis_b = sqrt(2*(a*(f^2)+c*(d^2)+g*(b^2)-2*b*d*f-a*c*g)/...
        ((b^2-a*c)*(-sqrt(((a-c)^2)+4*(b^2))-(a+c))));
    
    % angle
%     w = atan((2*b)/(a-c))/2; % unit in rad
    if a<c
        w = 1/2*(acot((a-c)/(2*b)));
    elseif a>c
        w = 1/2*(acot((a-c)/(2*b)))+pi/2;
    end
    % calculate ellipse
%     syms t

    t = linspace(0,2*pi,100);
    % phase space
    x = x0+(semi_axis_a*cos(t)*cos(w)-semi_axis_b*sin(t)*sin(w));
    xp = xp0+(semi_axis_a*cos(t)*sin(w)+semi_axis_b*sin(t)*cos(w));
    
    % normalized phase space
    x1 = x./sqrt(beta{i});
    xp1 = (x.*alpha{i} + xp.*beta{i})./sqrt(beta{i});
    
    % plot ellipse
    plot(sub1,x,xp,'Color',cline(i,:));
    hold(sub1,'on');
    plot(sub2,x1,xp1,'Color',cline(i,:));
    hold(sub2,'on');
    
    % add legend
    textlg{i} = sprintf('slice index = %d',i);
    
    axis equal
end
sub1.XLabel.String = h_label;
sub1.YLabel.String = v_label;
sub2.XLabel.String = h1_label;
sub2.YLabel.String = v1_label;


legend(textlg,'Location','eastoutside');
%   test with ezplot
%     figure;
% for i=1:1
%     x1 = sym('x1');
%     xp1 = sym('xp1');
%     ezplot(a*(x1.^2) + 2*b*x1*xp1 + c*(xp1.^2)+g);
%     hold on;
%     axis equal
% end
end

