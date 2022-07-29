%%
clear;clc
%% init
RootDirectory = '/home/maintenance/projects/Unseen Mode 2/IMUImages/PAMAP_ISS';
AnkleDirectory = '/home/maintenance/projects/Unseen Mode 2/IMUImages/PAMAP_ISS/Ankle';
ChestDirectory = '/home/maintenance/projects/Unseen Mode 2/IMUImages/PAMAP_ISS/Chest';
HandDirectory = '/home/maintenance/projects/Unseen Mode 2/IMUImages/PAMAP_ISS/Hand';

SavetoDisk = 'TRUE';
ISS = 'FALSE'; % use only acc
ISS_GW = 'TRUE'; % use both acc and gyro

%% create database
imds = dir(AnkleDirectory);
img_dirs = {imds.name};
filenames_split = split({img_dirs{1,3:end}},"."); filenames = {filenames_split{1,1:end,1}};
num_files = length(filenames);

%%
for f = 1:num_files %disable parfor for debug and set num_files to 1
    % read data
    [gFx_a, gFy_a, gFz_a, wx_a, wy_a, wz_a] = read_imu_file(AnkleDirectory + "/" + filenames{1,f}, [2, Inf]);
    gFx_a = gFx_a(~isnan(gFx_a)); gFy_a = gFy_a(~isnan(gFy_a)); gFz_a = gFz_a(~isnan(gFz_a));
    wx_a = wx_a(~isnan(wx_a)); wy_a = wy_a(~isnan(wy_a)); wz_a = wz_a(~isnan(wz_a));
    
    [gFx_c, gFy_c, gFz_c, wx_c, wy_c, wz_c] = read_imu_file(ChestDirectory + "/" + filenames{1,f}, [2, Inf]);
    gFx_c = gFx_c(~isnan(gFx_c)); gFy_c = gFy_c(~isnan(gFy_c)); gFz_c = gFz_c(~isnan(gFz_c));
    wx_c = wx_c(~isnan(wx_c)); wy_c = wy_c(~isnan(wy_c)); wz_c = wz_c(~isnan(wz_c));
    
    [gFx_h, gFy_h, gFz_h, wx_h, wy_h, wz_h] = read_imu_file(HandDirectory + "/" + filenames{1,f}, [2, Inf]);
    gFx_h = gFx_h(~isnan(gFx_h)); gFy_h = gFy_h(~isnan(gFy_h)); gFz_h = gFz_h(~isnan(gFz_h));
    wx_h = wx_h(~isnan(wx_h)); wy_h = wy_h(~isnan(wy_h)); wz_h = wz_h(~isnan(wz_h));

    data_size_a = min([length(gFx_a),length(gFy_a),length(gFz_a),length(wx_a),length(wy_a),length(wz_a)]);
    data_size_c = min([length(gFx_c),length(gFy_c),length(gFz_c),length(wx_c),length(wy_c),length(wz_c)]);
    data_size_h = min([length(gFx_h),length(gFy_h),length(gFz_h),length(wx_h),length(wy_h),length(wz_h)]);
    min_s = min([data_size_a,data_size_c,data_size_h]);

    gFx_a = gFx_a(1:min_s,:); 
    gFy_a = gFy_a(1:min_s,:);
    gFz_a = gFz_a(1:min_s,:);
    wx_a = wx_a(1:min_s,:);
    wy_a = wy_a(1:min_s,:);
    wz_a = wz_a(1:min_s,:);

    gFx_c = gFx_c(1:min_s,:); 
    gFy_c = gFy_c(1:min_s,:);
    gFz_c = gFz_c(1:min_s,:);
    wx_c = wx_c(1:min_s,:);
    wy_c = wy_c(1:min_s,:);
    wz_c = wz_c(1:min_s,:);

    gFx_h = gFx_h(1:min_s,:); 
    gFy_h = gFy_h(1:min_s,:);
    gFz_h = gFz_h(1:min_s,:);
    wx_h = wx_h(1:min_s,:);
    wy_h = wy_h(1:min_s,:);
    wz_h = wz_h(1:min_s,:);

    if strcmp(ISS,'TRUE') 
        F = [gFx_a, gFy_a, gFz_a, gFx_c, gFy_c, gFz_c, gFx_h, gFy_h, gFz_h];  
    end

    if strcmp(ISS_GW,'TRUE')
        F = [gFx_a, gFy_a, gFz_a, gFx_c, gFy_c, gFz_c, gFx_h, gFy_h, gFz_h, wx_a, wy_a, wz_a, wx_c, wy_c, wz_c, wx_h, wy_h, wz_h];  
    end

    % seperate to Train and Test
    % Train
    FTrain = F(1:round(min_s * 0.7),:);
    % Test
    FTest = F((round(min_s * 0.7)+1):end,:);
    
    % save Files
    if strcmp(SavetoDisk,'TRUE')
        xlswrite(sprintf('%s/Train/%s.csv', RootDirectory,[filenames{1,f}]),FTrain)
        xlswrite(sprintf('%s/Test/%s.csv', RootDirectory,[filenames{1,f}]),FTest)
    end
end
