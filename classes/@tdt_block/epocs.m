function e = epocs(b,epoc_name)

% Retrieve all epoc names for a block

global ttank

% Values to index from the TDT epoc data output
value = 1;
starttime = 2;
endtime = 3;

start_time = 0;     %Start at beginning of block
stop_time = 0;      %Go to end of block
max_epocs = 100000; %This should be enough to get all epocs

% Get data for requested epoc
access(b);
epoc_data = ttank.GetEpocsV(epoc_name,start_time,stop_time,...
    max_epocs);
e = epoc(b,epoc_name,epoc_data(value,:),epoc_data(starttime,:),...
    epoc_data(endtime,:));
ttank.ReleaseServer;