function [g1, g2, g3, g4, g5, g6, g7, g8, g9, w1, w2, w3, w4, w5, w6, w7, w8, w9] = read_iss_gw_p_imu_file(filename, dataLines)
%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 18);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
%opts.VariableNames = ["gFx", "gFy", "gFz", "wx", "wy", "wz"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double","double", "double", "double", "double", "double", "double","double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
g1 = tbl.Var1;
g2 = tbl.Var2;
g3 = tbl.Var3;
g4 = tbl.Var4;
g5 = tbl.Var5;
g6 = tbl.Var6;
g7 = tbl.Var7;
g8 = tbl.Var8;
g9 = tbl.Var9;
w1 = tbl.Var10;
w2 = tbl.Var11;
w3 = tbl.Var12;
w4 = tbl.Var13;
w5 = tbl.Var14;
w6 = tbl.Var15;
w7 = tbl.Var16;
w8 = tbl.Var17;
w9 = tbl.Var18;
end