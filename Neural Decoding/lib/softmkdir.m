function softmkdir(dir)
%SOFTMKDIR Craetes a new folder only if does not exist.

if ~exist(dir, 'dir')
  mkdir(dir);
end

end

