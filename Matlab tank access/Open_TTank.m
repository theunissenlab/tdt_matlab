% This script gets us ready to use the tankserver

% Create the ActiveX control
ttank = actxcontrol('TTank.X');
global ttank

% Default values for clientname and servername
if ~exist('servername')
    servername = 'Local';
end
if ~exist('clientname')
    clientname = 'Myclient';
end

global servername clientname