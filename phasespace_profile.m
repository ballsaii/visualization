%% usage
% visualize a phase space profile supporting multi-slice plot
close all;clear;clc

% load example
load 'data.mat';

% slice dist
sliced_data = slice_dist(data,'Emin','Emax',10);
% projected_data = slice_dist(data,'Emin','Emax',1);

% calculate emit, normalized phasespace and phase ellipse
slice_emit = get_emit(sliced_data);
transverse_phasespace = normalized_phasespace(sliced_data,slice_emit);
ellipse_x = ellipse_phasespace(slice_emit,'x',200);
ellipse_y = ellipse_phasespace(slice_emit,'y',200);

%

% matlab structure
mainfig = figure;
mainfig.Position = [50,100,1500,400];
