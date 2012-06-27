function [data,avg_data,numpoints] = initializeData(params)
%initialize the data structures. Data should be a structure with one
%element for each scan (except for "show" methods where it should be only
%the most recent value. avg_data should represent an average of all data
%collected.

data = struct('x',[],'y',[]);
numpoints = 0;
switch lower(params.method)
  case 'show labmax'
    data.x = 1;
    data.y = 0;
    avg_data = data;
  case 'labmax noncolinear ac'
    tstart = params.start;
    tend = params.end;
    tstep = params.resolution;
    trange = tend-tstart;
    n_points = trange/tstep + 1;
    time = [tstart:tstep:tend];
    y = nan(size(time));

    %let the inititial size of data be the greater of scan_max and 1, so
    %that if scan_max = -1, the data array will have one element.
    n_elements = max([params.scan_max 1]);
    for i = 1:n_elements
      data(i).x = time;
      data(i).y = y;
    end
    avg_data = data(1);
  case 'labmax ac overlapped'
    tstart = params.start;
    tend = params.end;
    tstep = params.speed/5000;
    trange = tend-tstart;
    time = [tstart:tstep:tend];
    y = nan(size(time));
    numpoints = trange/tstep+1;
    n_scans = max([params.scan_max 1]);
    for i = 1:n_scans
      data(i).x = time;
      data(i).y = y;
    end
    avg_data = data(1);
  otherwise
    error('SGRLAB:methodUnknown','unknown method');
end
