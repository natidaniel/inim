function [gFx, gFy, gFz, wx, wy, wz] = read_imu_file(filename, dataLines)
%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    %dataLines = [2, Inf];
    dataLines = [1, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
%opts.VariableNames = ["gFx", "gFy", "gFz", "wx", "wy", "wz"];
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
% gFx = tbl.gFx;
% gFy = tbl.gFy;
% gFz = tbl.gFz;
% wx = tbl.wx;
% wy = tbl.wy;
% wz = tbl.wz;

gFx = tbl.VarName1;
gFy = tbl.VarName2;
gFz = tbl.VarName3;
wx = tbl.VarName4;
wy = tbl.VarName5;
wz = tbl.VarName6;
end