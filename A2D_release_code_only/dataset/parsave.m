function parsave(path, file_name, file)

% feval(@()assignin('caller',file_name,file));
temp_struct.(file_name) = file;
save(path,'-struct','temp_struct', file_name, '-v7.3');
end