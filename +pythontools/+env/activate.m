function activate(pathEnvs, envName)
%ACTIVATE Activate a python environment
%   pathEnvs: Path of the directory where the virtual environment is.

% Check existance of virtual environment
if ~exist(pathEnvs, 'dir')
    error('Path to environments doesn''t exist');
end

if ~exist(fullfile(pathEnvs, envName), 'dir')
    error('Python environment doesn''t exist');
end

% Get OS specific parameters
if isunix || ismac
    % Code to run on Linux or Mac platform
    pathPython = fullfile(pathEnvs, envName, 'bin', 'python');
elseif ispc
    % Code to run on Windows platform
    pathPython = fullfile(pathEnvs, envName, 'python.exe');
else
    error('Platform not supported');
end

% Select python interpreter
[~, pythonExecPath, isPythonLoaded] = pyversion;

if ~isPythonLoaded
    % Load python
    pyversion(pathPython);
    disp('Python environment loaded successfully')
else
    % Verify correct interpreter
    if ~strcmp(pythonExecPath, pathPython)
        error(['The following Python interpreter is already loaded: ' pythonExecPath '. To change the Python version, restart MATLAB, then call pyversion.']);
    else
        disp('Python environment already loaded')
    end
end

if ispc
    % Copy files for matplotlib
    % Get a list of all files and folders in this folder.
    files = dir(fullfile(pathEnvs, envName, 'tcl'));
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags); 
    targetFolder = fullfile(pathEnvs, envName, 'Lib');
    for k = 1 : length(subFolders)
      if startsWith(subFolders(k).name, 'tk') || startsWith(subFolders(k).name, 'tcl')
          % Copy the folder to the environment lib folder
          currentFolder = fullfile(subFolders(k).folder, subFolders(k).name);
          destFolder = fullfile(targetFolder, subFolders(k).name);
          if exist(currentFolder, 'dir') && ~exist(destFolder, 'dir')
            copyfile(currentFolder, destFolder);
          end
      end
    end
end

