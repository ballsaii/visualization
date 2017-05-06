function [ x, y ] = getcentroid( hist )
% usage 

% create x and y
x = (hist.BinEdges(1:end-1) + hist.BinWidth);
y = hist.Values;

[x,y] = prepareCurveData(x,y);

% Set up fittype and options.
ft = fittype( 'smoothingspline' );

% Fit model to data.
[fitresult, gof] = fit(x,y,ft,'Normalize','on');
plot(fitresult)
end

