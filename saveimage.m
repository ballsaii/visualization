function saveimage(f,path,file)
% usage save each axes to eps file
for i=1:length(f)
pathfile = fullfile(path,strjoin({file,num2str(i)},'_'));
print(f(i),pathfile,'-dpng','-r600')
end
end