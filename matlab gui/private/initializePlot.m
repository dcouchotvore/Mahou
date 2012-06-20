function h = initializePlot(handles,params,data,avg_data)
%set up the plots on the gui screen based on the method chosen, link the x
%and y data to the plots, and return a handle array to the plots that are
%active so they can be refreshed later.


switch lower(params.method)
  case 'show labmax'
    h = bar(handles.axes1,data.x,data.y);
    ylim([0 1.1]); %this is hard coded now but should be updated
    set(h,'XDataSource','data.x','YDataSource','data.y');
    
  case 'labmax noncolinear ac'
    %works
%    h = plot(handles.axes1,avg_data.x,avg_data.y);
%    set(h,'XDataSource','avg_data.x','YDataSource','avg_data.y');

    %works
%    h = plot(handles.axes1,data(1).x,data(1).y);
%    set(h,'XDataSource','data(end).x','YDataSource','data(end).y');

    h(1) = plot(handles.axes1,data(1).x,data(1).y,'o');
    hold on
    h(2) = plot(handles.axes1,avg_data.x,avg_data.y);
    hold off
    set(h(1),'XDataSource','data(i_scan).x','YDataSource','data(i_scan).y');
    set(h(2),'XDataSource','avg_data.x','YDataSource','avg_data.y');
    
  case 'labmax ac overlapped'
    h(1) = plot(handles.axes1,data(1).x,data(1).y,'o');
    hold on
%    h(2) = plot(handles.axes1,avg_data.x,avg_data.y);
    hold off
    set(h(1),'XDataSource','data(1).x','YDataSource','data(1).y');
%    set(h(2),'XDataSource','avg_data.x','YDataSource','avg_data.y');
     
  otherwise
    error('SGRLAB:methodUnknown','unknown method');
end
    
