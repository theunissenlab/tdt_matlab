function [cellname,depth,stimset] = parse_blockname(blockname)

%========================================================================
% This function pulls the cell number, depth, and stimulus set from the
% block name input. Block name input is assumed to be in the form 'cell
% <cellnum> depth <depth> <stimset>'. It is designed to be insensitive to
% the case of the first letter of the strings 'cell' and 'depth', and to
% the presence or absence of spaces between the arguments.
%========================================================================

num_start = strfind(blockname,'ell') +3;
num_stop = strfind(blockname,'epth') -2;
cellname = (strtrim(blockname(num_start:num_stop)));

num_start = num_stop + 6;
last_part = strtrim(blockname(num_start:end));
[depth,stimset] = strtok(last_part);
stimset = strtrim(stimset);