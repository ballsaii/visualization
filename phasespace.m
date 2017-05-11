function [xn,xpn,yn,ypn]=phasespace(dist,emit)
% usage get dist to get x,xp or y,yp convert to normalized phase space
% emit is the structure get from get_emit
% xn = x/sqrt(beta)
% xpn = (x*alpha + xp*beta)/sqrt(beta)
% unit xn and xpn in sqrt(mm) 
i=1;
while i<=length(dist)
    % x
    x = dist{i}(:,1)*10; % unit in mm
    xp = dist{i}(:,2)*1E-3; % unit in rad
    beta = sqrt(emit.Twiss.beta.form0.x{i}); % unit in mm
    alpha = emit.Twiss.alpha.form0.x{i}; % unit in 1
    xn{i} = x./sqrt(beta);
    xpn{i} = (x.*alpha + xp.*beta)./sqrt(beta);
    
    % y
    y = dist{i}(:,3)*10; % unit in mm
    yp = dist{i}(:,4)*1E-3; % unit in rad
    beta = sqrt(emit.Twiss.beta.form0.y{i});
    alpha = emit.Twiss.alpha.form0.y{i};
    yn{i} = y./sqrt(beta);
    ypn{i} = (y.*alpha + yp.*beta)./sqrt(beta);
    
    % update loop
    i = i + 1;

end

