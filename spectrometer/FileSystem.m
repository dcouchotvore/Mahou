classdef FileSystem < handle

  properties (SetAccess = private)
    DateString;
    DatePath;
    FileIndex;
  end
  
  %hold the instance as a persistent variable
  methods (Static)
    function singleObj = getInstance
      persistent localObj
      if isempty(localObj) || ~isvalid(localObj)
        localObj = FileSystem;
      end
      singleObj = localObj;
    end
  end

  methods (Access = private)

   function obj = FileSystem
      obj.updateParameters;
    end
  end
  
  methods (Access = public)
    
    function Save(obj, data)
      path = sprintf('%s/%3.3d.mat', obj.DatePath, obj.FileIndex);
      save(path, 'data');
      obj.updateParameters;
    end
    
    function SaveTemp(obj, data, counter)
      path = sprintf('C:/data/%s/temp/%3.3d-%4.4d.mat', obj.DateString, obj.FileIndex, counter);
      save(path, 'data');
    end
    
  end
 
  methods (Access = private)
    
    % Note problem: if an exception occurs after some temp files are
    % written but before final files, there will be orphan files.
    % in the temp folder.
    function updateParameters(obj)
      
      % Verify that root data directory structure exists.
      
      if ~exist('C:/data', 'file')
        mkdir('C:/data')
      end
      
      % Verify that folder for today exists

      obj.DateString = datestr(now, 'yyyy-mm-dd');
      obj.DatePath = ['C:/data/' obj.DateString];
      if ~exist(obj.DatePath, 'file')
        mkdir(obj.DatePath);
      end
      dateTmpPath = [obj.DatePath 'temp/'];
      if ~exist(dateTmpPath, 'file')
        mkdir(dateTmpPath);
      end
 
      % Get next file index (run number)
      
      files = dir(obj.DatePath);
      files = {files.name};
      matches = regexp(files, '(\d+)\.mat', 'tokens');
      matches = matches(~cellfun('isempty',matches));
      
      if isempty(matches)
        obj.FileIndex = 1;
      else
        
        % As to what is going on here.  regexp returns a cell array of
        % cells containing strings, and it was a bit of a bitch to figure
        % out how to get them out of there without resorting to a clumsy
        % for loop.  the cat function indexes each item of the cell array
        % and puts the contents into a string array.  The following line
        % converts them to integers, finds the maximum, and adds one for
        % the next run.
        values = cat(2, matches{1,:});
        values = cat(2, values{1,:});
        obj.FileIndex = max(str2double(values))+1;
      end
      
    end
    
  end
end
