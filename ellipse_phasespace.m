function ellipse_phasespace( emit )
% usage
% ellipse_phasespace(emit)
% ellipse equation,  gamma*x^2 + 2*alpha*x*xp + beta*xp^2 = emit

% load
alpha = emit.Twiss.alpha.form0.x;
beta = emit.Twiss.beta.form0.x;
emit = emit.geo.x;


% for each slice
for i=1:length(alpha)

gamma{i} = (1+alpha{i}.^2)/beta{i};

x = sym('x');
xp = sym('xp');

h = ezplot(gamma{i}*(x.^2) + 2*alpha{i}*x*xp + beta{i}*(xp.^2)==emit{i});
hold on;
% fplot(@(x,xp) gamma*(x.^2) + 2*alpha*x*xp + beta*(xp.^2)-emit )
end

% set(h,'Xlim',max(get('X')))

end

