phasecut = 180;
x = data(:,1)*10;
xp = data(:,2);
y = data(:,3)*10;
yp = data(:,4);
phase = data(:,5);
Ek = data(:,6);

cond = find(phase<phasecut);

x = x(cond);
xp = xp(cond);
y = y(cond);
yp = yp(cond);
phase = phase(cond);
Ek = Ek(cond);

figure;scatter(phase,Ek,'.');
figure;scatter(x,xp,'.');xlim([-5 5]);ylim([-500 500]);
figure;scatter(y,yp,'.');xlim([-5 5]);ylim([-500 500]);

