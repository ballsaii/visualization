%% usage
% visualize a phase space profile supporting multi-slice plot
close all;clear;clc
% load example
load 'data.mat';
sliced_data = slice_dist(data,'Emin','Emax',10);
% projected_data = slice_dist(data,'Emin','Emax',1);
%%
% unit mm
x = fx(sliced_data,1)*10; 
% unit in mrad
xp = fx(sliced_data,2);

% matlab structure
mainfig = figure;
mainfig.Position = [50,100,1500,400];




function output = fx(sliced_data,j)
    for i=1:length(sliced_data)
        output{i} = sliced_data{i}(:,j);
    end
end