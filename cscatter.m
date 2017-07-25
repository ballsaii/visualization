function f=cscatter( s )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i=1:length(s.h)
scatter(s.h{i},s.v{i},'.')
hold on;
end
end

