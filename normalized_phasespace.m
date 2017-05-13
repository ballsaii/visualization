function output = normalized_phasespace(dist,emit)
% usage get dist to get x,xp or y,yp convert to normalized phase space
% emit is the structure get from get_emit
% output.[geo,norm],[h,v]

% xn = x/sqrt(beta) unit in mm^{1/2}
% xpn = (x*alpha + xp*beta)/sqrt(beta) unit in mm^{1/2}
% unit xn and xpn in sqrt(mm) 

i=1;
while i<=length(dist)
    % x
    x{i} = dist{i}(:,1)*10; % unit in mm
    xp{i} = dist{i}(:,2)*1E-3; % unit in rad
    beta = sqrt(emit.Twiss.beta.form0.x{i}); % unit in mm
    alpha = emit.Twiss.alpha.form0.x{i}; % unit in 1
    xn{i} = x{i}./sqrt(beta); % unit in mm^{1/2}
    xpn{i} = (x{i}.*alpha + xp{i}.*beta)./sqrt(beta); % unit in 
    
    % y
    y{i} = dist{i}(:,3)*10; % unit in mm
    yp{i} = dist{i}(:,4)*1E-3; % unit in rad
    beta = sqrt(emit.Twiss.beta.form0.y{i});
    alpha = emit.Twiss.alpha.form0.y{i};
    yn{i} = y{i}./sqrt(beta);
    ypn{i} = (y{i}.*alpha + yp{i}.*beta)./sqrt(beta);
    
    % update loop
    i = i + 1;

end

    output.geo.x = struct('h',{x},'v',{xp});
    output.geo.y = struct('h',{y},'v',{yp});
    
    output.norm = struct('h',{xn},'v',{xpn});
    output.norm = struct('h',{yn},'v',{ypn});

