function [xn,xpn,yn,ypn]=normalize_phasespace(dist,emit)
% usage get dist to get x,xp or y,yp convert to normalized phase space
% emit is the structure get from get_emit
% xn = x/sqrt(beta)
% xpn = (x*alpha + xp*beta)/sqrt(beta)
i=1;
while i<=length(dist)
    % x
    x = dist{i}(:,1);
    xp = dist{i}(:,2);
    beta = sqrt(emit.Twiss.beta.form0.x{i});
    alpha = emit.Twiss.alpha.form0.x{i};
    xn{i} = x./sqrt(beta);
    xpn{i} = (x.*alpha + xp.*beta)./sqrt(beta);
    
    % y
    y = dist{i}(:,3);
    yp = dist{i}(:,4);
    beta = sqrt(emit.Twiss.beta.form0.y{i});
    alpha = emit.Twiss.alpha.form0.y{i};
    yn{i} = y./sqrt(beta);
    ypn{i} = (y.*alpha + yp.*beta)./sqrt(beta);
    
    % update loop
    i = i + 1;

end

