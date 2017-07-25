function savedis( code,data)
% select path

[FileName,PathName,~] = uiputfile('*.txt','Save INPUT',pwd);
filename = fullfile(PathName,FileName);
switch code
    case 'Parmela'
        fid =  fopen(filename,'w');
        format = '%8.5E %8.5E %8.5E %8.5E %8.5f %8.5E \r\n';
        fprintf(fid,format,data');
        fclose(fid);
    case 'Astra'
        fid =  fopen(filename,'w');
        format = '%8.5E %8.5E %8.5E %8.5E %8.5E %8.5E %8.5E %8.5E %d %d\r\n';
        fprintf(fid,format,data');
        fclose(fid);
end

end

