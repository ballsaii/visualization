function output = loaddistmat()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[file,path] = uigetfile('*.mat','choose mat file',pwd);
loadfile = fullfile(path,file);
load(loadfile)
output = matdata;
end

