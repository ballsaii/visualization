function output = test2(z0,z,By)
cond = find(abs(z)<=z0);
z1 = z(cond);
By1 = By(cond);
output = trapz(z1,abs(By1))/max(abs(By1));
end