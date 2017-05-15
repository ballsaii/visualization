function saveimage(h,path,file)
% usage save each axes to eps file

f = figure;
ax = axes;
new_handle = copyobj(h,ax);
% pathfile = fullfile(path,file);
% print(h,pathfile,'-dpng','-r600')
end