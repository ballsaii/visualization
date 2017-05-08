function xxp= multi_phasespace( x,xp )
% usage
% multi_phasespace( x,xp ) x and xp are multi-cell containing sliced values
% return plot object
all =[];

for i =1:length(x)
xxp{i} =[all,x{i},xp{i}]
end

end

