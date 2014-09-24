function [content]=readf32(filename)
%READF32 read .f32 file and return its content
fid = fopen(filename);
content = fread(fid,'int32');
fclose(fid);

end

