%%

clear;clc
%% init
RootDirectory = '/IMUImages';
%SLR: TrainDirectory = '/Data/TrainFiles';
%HAR: TrainDirectory = '/IMUImages/NewDataSets/HAR/TrainHAR';
%PAR: TrainDirectory = '/IMUImages/NewDataSets/PAR/TestPAR';
%TrainDirectory = '/IMUImages/PAMAP_ISS/ISS_GW/Test';
TrainDirectory = '/IMUImages/NewDataSets/TransformerData/Train';
SavetoDisk = 'TRUE';
MUL_GW = 'TRUE'; % our method
ISS = 'FALSE'; % use only acc
ISS_GW = 'FALSE'; % use both acc and gyro
ISS_P = 'FALSE'; % use only acc
ISS_GW_P = 'FALSE'; % use both acc and gyro
PCA_MUL_GW = 'FALSE';
%% create database
imds = dir(TrainDirectory);
img_dirs = {imds.name};
filenames_split = split({img_dirs{1,3:end}},"."); filenames = {filenames_split{1,1:end,1}};
num_files = length(filenames);
%% IMU2Images init parameters
gF_weight = 1;
w_wieght = 1;
%% model net requires the Deep Learning Toolbox Model
net_input_size = 224; %448,1000
%net = resnet50; %vgg16,resnet101
%% generate images
% release: use parfor, debug: for
for f = 1:num_files %disable parfor for debug and set num_files to 1
    if ~strcmp(ISS_P,'TRUE') && ~strcmp(ISS_GW_P,'TRUE')
        % read data
        [gFx, gFy, gFz, wx, wy, wz] = read_imu_file(TrainDirectory + "/" + filenames{1,f}, [2, Inf]);
        gFx = gFx(~isnan(gFx)); gFy = gFy(~isnan(gFy)); gFz = gFz(~isnan(gFz));
        wx = wx(~isnan(wx)); wy = wy(~isnan(wy)); wz = wz(~isnan(wz));
        data_size = min([length(gFx),length(gFy),length(gFz),length(wx),length(wy),length(wz)]);
        gFx = gF_weight * gFx(1:data_size); gFy = gF_weight * gFy(1:data_size); gFz = gF_weight * gFz(1:data_size);
        wx = w_wieght * wx(1:data_size); wy = w_wieght * wy(1:data_size); wz = w_wieght * wz(1:data_size);
        number_of_images_per_input = floor(data_size/net_input_size);
    else
        if strcmp(ISS_P,'TRUE')
            [g1, g2, g3, g4, g5, g6, g7, g8, g9] = read_iss_p_imu_file(TrainDirectory + "/" + filenames{1,f}, [1, Inf]);
            data_size = length(g1);
            number_of_images_per_input = floor(data_size/net_input_size);
        end
        if strcmp(ISS_GW_P,'TRUE')
            [g1, g2, g3, g4, g5, g6, g7, g8, g9, w1, w2, w3, w4, w5, w6, w7, w8, w9] = read_iss_gw_p_imu_file(TrainDirectory + "/" + filenames{1,f}, [1, Inf]);
            data_size = length(g1);
            number_of_images_per_input = floor(data_size/net_input_size);
        end
    end
    
    % create output dict
    cd data/
    mkdir([filenames{1,f}])
    cd ../
    
    if strcmp(ISS,'TRUE') || strcmp(ISS_GW,'TRUE')
            gFx = 255*(gFx - min(gFx(:)))/(max(gFx(:)) - min(gFx(:)));
            gFy = 255*(gFy - min(gFy(:)))/(max(gFy(:)) - min(gFy(:)));
            gFz = 255*(gFz - min(gFz(:)))/(max(gFz(:)) - min(gFz(:)));
            Rgx = floor(gFx);Ggx = floor(100*(gFx-floor(gFx))); Bgx = floor(100*(gFx *100 - floor(gFx*100)));
            Rgy = floor(gFy);Ggy = floor(100*(gFy-floor(gFy))); Bgy = floor(100*(gFy *100 - floor(gFy*100)));
            Rgz = floor(gFz);Ggz = floor(100*(gFz-floor(gFz))); Bgz = floor(100*(gFz *100 - floor(gFz*100)));
            Rwx = floor(wx);Gwx = floor(100*(wx-floor(wx))); Bwx = floor(100*(wx *100 - floor(wx*100)));
            Rwy = floor(wy);Gwy = floor(100*(wy-floor(wy))); Bwy = floor(100*(wy *100 - floor(wy*100)));
            Rwz = floor(wz);Gwz = floor(100*(wz-floor(wz))); Bwz = floor(100*(wz *100 - floor(wz*100)));
    end
    
    if strcmp(ISS_P,'TRUE') 
            g1 = 255*(g1 - min(g1(:)))/(max(g1(:)) - min(g1(:)));
            g2 = 255*(g2 - min(g2(:)))/(max(g2(:)) - min(g2(:)));
            g3 = 255*(g3 - min(g3(:)))/(max(g3(:)) - min(g3(:)));
            g4 = 255*(g4 - min(g4(:)))/(max(g4(:)) - min(g4(:)));
            g5 = 255*(g5 - min(g5(:)))/(max(g5(:)) - min(g5(:)));
            g6 = 255*(g6 - min(g6(:)))/(max(g6(:)) - min(g6(:)));
            g7 = 255*(g7 - min(g7(:)))/(max(g7(:)) - min(g7(:)));
            g8 = 255*(g8 - min(g8(:)))/(max(g8(:)) - min(g8(:)));
            g9 = 255*(g9 - min(g9(:)))/(max(g9(:)) - min(g9(:)));     
            Rg1 = floor(g1);Gg1 = floor(100*(g1-floor(g1))); Bg1 = floor(100*(g1 *100 - floor(g1*100)));
            Rg2 = floor(g2);Gg2 = floor(100*(g2-floor(g2))); Bg2 = floor(100*(g2 *100 - floor(g2*100)));
            Rg3 = floor(g3);Gg3 = floor(100*(g3-floor(g3))); Bg3 = floor(100*(g3 *100 - floor(g3*100)));
            Rg4 = floor(g4);Gg4 = floor(100*(g4-floor(g4))); Bg4 = floor(100*(g4 *100 - floor(g4*100)));
            Rg5 = floor(g5);Gg5 = floor(100*(g5-floor(g5))); Bg5 = floor(100*(g5 *100 - floor(g5*100)));
            Rg6 = floor(g6);Gg6 = floor(100*(g6-floor(g6))); Bg6 = floor(100*(g6 *100 - floor(g6*100)));
            Rg7 = floor(g7);Gg7 = floor(100*(g7-floor(g7))); Bg7 = floor(100*(g7 *100 - floor(g7*100)));
            Rg8 = floor(g8);Gg8 = floor(100*(g8-floor(g8))); Bg8 = floor(100*(g8 *100 - floor(g8*100)));
            Rg9 = floor(g9);Gg9 = floor(100*(g9-floor(g9))); Bg9 = floor(100*(g9 *100 - floor(g9*100)));
            
    end 
    if strcmp(ISS_GW_P,'TRUE')
            g1 = 255*(g1 - min(g1(:)))/(max(g1(:)) - min(g1(:)));
            g2 = 255*(g2 - min(g2(:)))/(max(g2(:)) - min(g2(:)));
            g3 = 255*(g3 - min(g3(:)))/(max(g3(:)) - min(g3(:)));
            g4 = 255*(g4 - min(g4(:)))/(max(g4(:)) - min(g4(:)));
            g5 = 255*(g5 - min(g5(:)))/(max(g5(:)) - min(g5(:)));
            g6 = 255*(g6 - min(g6(:)))/(max(g6(:)) - min(g6(:)));
            g7 = 255*(g7 - min(g7(:)))/(max(g7(:)) - min(g7(:)));
            g8 = 255*(g8 - min(g8(:)))/(max(g8(:)) - min(g8(:)));
            g9 = 255*(g9 - min(g9(:)))/(max(g9(:)) - min(g9(:)));
            
            Rg1 = floor(g1);Gg1 = floor(100*(g1-floor(g1))); Bg1 = floor(100*(g1 *100 - floor(g1*100)));
            Rg2 = floor(g2);Gg2 = floor(100*(g2-floor(g2))); Bg2 = floor(100*(g2 *100 - floor(g2*100)));
            Rg3 = floor(g3);Gg3 = floor(100*(g3-floor(g3))); Bg3 = floor(100*(g3 *100 - floor(g3*100)));
            Rg4 = floor(g4);Gg4 = floor(100*(g4-floor(g4))); Bg4 = floor(100*(g4 *100 - floor(g4*100)));
            Rg5 = floor(g5);Gg5 = floor(100*(g5-floor(g5))); Bg5 = floor(100*(g5 *100 - floor(g5*100)));
            Rg6 = floor(g6);Gg6 = floor(100*(g6-floor(g6))); Bg6 = floor(100*(g6 *100 - floor(g6*100)));
            Rg7 = floor(g7);Gg7 = floor(100*(g7-floor(g7))); Bg7 = floor(100*(g7 *100 - floor(g7*100)));
            Rg8 = floor(g8);Gg8 = floor(100*(g8-floor(g8))); Bg8 = floor(100*(g8 *100 - floor(g8*100)));
            Rg9 = floor(g9);Gg9 = floor(100*(g9-floor(g9))); Bg9 = floor(100*(g9 *100 - floor(g9*100)));
            Rw1 = floor(w1);Gw1 = floor(100*(w1-floor(w1))); Bw1 = floor(100*(w1 *100 - floor(w1*100)));
            Rw2 = floor(w2);Gw2 = floor(100*(w2-floor(w2))); Bw2 = floor(100*(w2 *100 - floor(w2*100)));
            Rw3 = floor(w3);Gw3 = floor(100*(w3-floor(w3))); Bw3 = floor(100*(w3 *100 - floor(w3*100)));
            Rw4 = floor(w4);Gw4 = floor(100*(w4-floor(w4))); Bw4 = floor(100*(w4 *100 - floor(w4*100)));
            Rw5 = floor(w5);Gw5 = floor(100*(w5-floor(w5))); Bw5 = floor(100*(w5 *100 - floor(w5*100)));
            Rw6 = floor(w6);Gw6 = floor(100*(w6-floor(w6))); Bw6 = floor(100*(w6 *100 - floor(w6*100)));
            Rw7 = floor(w7);Gw7 = floor(100*(w7-floor(w7))); Bw7 = floor(100*(w7 *100 - floor(w7*100)));
            Rw8 = floor(w8);Gw8 = floor(100*(w8-floor(w8))); Bw8 = floor(100*(w8 *100 - floor(w8*100)));
            Rw9 = floor(w9);Gw9 = floor(100*(w9-floor(w9))); Bw9 = floor(100*(w9 *100 - floor(w9*100)));
    end
    
    if strcmp(PCA_MUL_GW, 'TRUE')
       P = zeros(data_size,6);
       P(:,1) = gFx; P(:,2) = gFy; P(:,3) = gFz; P(:,4) = wx; P(:,5) = wy; P(:,6) = wz;
       [coef, score, ~,~,explained, ~] = pca(P);
       pc1 = score(:,1);pc2 = score(:,1); pc3 = score(:,3);pc4 = score(:,4);pc5 = score(:,5);pc6 = score(:,6);
    end
    
    % generate image
    for k = 1:number_of_images_per_input  % for debug set number_of_images_per_input to 1
        if strcmp(MUL_GW,'TRUE')
            R = zeros(net_input_size,net_input_size); 
            B = zeros(net_input_size,net_input_size); 
            G = zeros(net_input_size,net_input_size); 
            I = zeros(net_input_size,net_input_size,3);
        end
        
        if strcmp(PCA_MUL_GW,'TRUE')
            R = zeros(net_input_size,net_input_size); 
            B = zeros(net_input_size,net_input_size); 
            G = zeros(net_input_size,net_input_size); 
            I = zeros(net_input_size,net_input_size,3);
        end
        
        if strcmp(ISS,'TRUE')
            R = zeros(net_input_size,3);
            B = zeros(net_input_size,3);
            G = zeros(net_input_size,3);
            I = zeros(net_input_size,3,3);
        end
        
        if strcmp(ISS_GW, 'TRUE')
            R = zeros(net_input_size,6);
            B = zeros(net_input_size,6);
            G = zeros(net_input_size,6);
            I = zeros(net_input_size,6,3);
        end
        
        if strcmp(ISS_P,'TRUE')
            R = zeros(net_input_size,9);
            B = zeros(net_input_size,9);
            G = zeros(net_input_size,9);
            I = zeros(net_input_size,9,3);
        end
        
        if strcmp(ISS_GW_P, 'TRUE')
            R = zeros(net_input_size,18);
            B = zeros(net_input_size,18);
            G = zeros(net_input_size,18);
            I = zeros(net_input_size,18,3);
        end
        
        if strcmp(MUL_GW,'TRUE')
            for i=((k-1)*net_input_size+1):(k*net_input_size)
                for j=((k-1)*net_input_size+1):(k*net_input_size)
                    % no overlapping within the ecc and gyro
                        R(i-(k-1)*net_input_size,j-(k-1)*net_input_size) = gFx(i) * wx(j);
                        B(i-(k-1)*net_input_size,j-(k-1)*net_input_size) = gFy(i) * wy(j);
                        G(i-(k-1)*net_input_size,j-(k-1)*net_input_size) = gFz(i) * wz(j);
                end
            end
        end
        
        if strcmp(PCA_MUL_GW,'TRUE')
            for i=((k-1)*net_input_size+1):(k*net_input_size)
                for j=((k-1)*net_input_size+1):(k*net_input_size)
                    % no overlapping within the ecc and gyro
                        R(i-(k-1)*net_input_size,j-(k-1)*net_input_size) = pc1(i) * pc2(j);
                        B(i-(k-1)*net_input_size,j-(k-1)*net_input_size) = pc3(i) * pc4(j);
                        G(i-(k-1)*net_input_size,j-(k-1)*net_input_size) = pc5(i) * pc6(j);
                end
            end
        end
        
        if strcmp(ISS,'TRUE')
            for i=((k-1)*net_input_size+1):(k*net_input_size)
                % ACC only
                R(i-(k-1)*net_input_size,1) = Rgx(i);
                G(i-(k-1)*net_input_size,1) = Ggx(i);
                B(i-(k-1)*net_input_size,1) = Bgx(i);
                R(i-(k-1)*net_input_size,2) = Rgy(i);
                G(i-(k-1)*net_input_size,2) = Ggy(i);
                B(i-(k-1)*net_input_size,2) = Bgy(i);
                R(i-(k-1)*net_input_size,3) = Rgz(i);
                G(i-(k-1)*net_input_size,3) = Ggz(i);
                B(i-(k-1)*net_input_size,3) = Bgz(i);
            end
        end
        
        if strcmp(ISS_GW,'TRUE')
            for i=((k-1)*net_input_size+1):(k*net_input_size)
                % ACC&Gyro
                R(i-(k-1)*net_input_size,1) = Rgx(i);
                G(i-(k-1)*net_input_size,1) = Ggx(i);
                B(i-(k-1)*net_input_size,1) = Bgx(i);
                R(i-(k-1)*net_input_size,2) = Rgy(i);
                G(i-(k-1)*net_input_size,2) = Ggy(i);
                B(i-(k-1)*net_input_size,2) = Bgy(i);
                R(i-(k-1)*net_input_size,3) = Rgz(i);
                G(i-(k-1)*net_input_size,3) = Ggz(i);
                B(i-(k-1)*net_input_size,3) = Bgz(i);
                R(i-(k-1)*net_input_size,4) = Rwx(i);
                G(i-(k-1)*net_input_size,4) = Gwx(i);
                B(i-(k-1)*net_input_size,4) = Bwx(i);
                R(i-(k-1)*net_input_size,5) = Rwy(i);
                G(i-(k-1)*net_input_size,5) = Gwy(i);
                B(i-(k-1)*net_input_size,5) = Bwy(i);
                R(i-(k-1)*net_input_size,6) = Rwz(i);
                G(i-(k-1)*net_input_size,6) = Gwz(i);
                B(i-(k-1)*net_input_size,6) = Bwz(i);
            end
        end
        
        
        if strcmp(ISS_P,'TRUE')
            for i=((k-1)*net_input_size+1):(k*net_input_size)
                % ACC only
                R(i-(k-1)*net_input_size,1) = Rg1(i);
                G(i-(k-1)*net_input_size,1) = Gg1(i);
                B(i-(k-1)*net_input_size,1) = Bg1(i);
                R(i-(k-1)*net_input_size,2) = Rg2(i);
                G(i-(k-1)*net_input_size,2) = Gg2(i);
                B(i-(k-1)*net_input_size,2) = Bg2(i);
                R(i-(k-1)*net_input_size,3) = Rg3(i);
                G(i-(k-1)*net_input_size,3) = Gg3(i);
                B(i-(k-1)*net_input_size,3) = Bg3(i);
                R(i-(k-1)*net_input_size,4) = Rg4(i);
                G(i-(k-1)*net_input_size,4) = Gg4(i);
                B(i-(k-1)*net_input_size,4) = Bg4(i);
                R(i-(k-1)*net_input_size,5) = Rg5(i);
                G(i-(k-1)*net_input_size,5) = Gg5(i);
                B(i-(k-1)*net_input_size,5) = Bg5(i);
                R(i-(k-1)*net_input_size,6) = Rg6(i);
                G(i-(k-1)*net_input_size,6) = Gg6(i);
                B(i-(k-1)*net_input_size,6) = Bg6(i);
                R(i-(k-1)*net_input_size,7) = Rg7(i);
                G(i-(k-1)*net_input_size,7) = Gg7(i);
                B(i-(k-1)*net_input_size,7) = Bg7(i);
                R(i-(k-1)*net_input_size,8) = Rg8(i);
                G(i-(k-1)*net_input_size,8) = Gg8(i);
                B(i-(k-1)*net_input_size,8) = Bg8(i);
                R(i-(k-1)*net_input_size,9) = Rg9(i);
                G(i-(k-1)*net_input_size,9) = Gg9(i);
                B(i-(k-1)*net_input_size,9) = Bg9(i);
            end
        end
        
        if strcmp(ISS_GW_P,'TRUE')
            for i=((k-1)*net_input_size+1):(k*net_input_size)
                % ACC&Gyro
         R(i-(k-1)*net_input_size,1) = Rg1(i);
                G(i-(k-1)*net_input_size,1) = Gg1(i);
                B(i-(k-1)*net_input_size,1) = Bg1(i);
                R(i-(k-1)*net_input_size,2) = Rg2(i);
                G(i-(k-1)*net_input_size,2) = Gg2(i);
                B(i-(k-1)*net_input_size,2) = Bg2(i);
                R(i-(k-1)*net_input_size,3) = Rg3(i);
                G(i-(k-1)*net_input_size,3) = Gg3(i);
                B(i-(k-1)*net_input_size,3) = Bg3(i);
                R(i-(k-1)*net_input_size,4) = Rg4(i);
                G(i-(k-1)*net_input_size,4) = Gg4(i);
                B(i-(k-1)*net_input_size,4) = Bg4(i);
                R(i-(k-1)*net_input_size,5) = Rg5(i);
                G(i-(k-1)*net_input_size,5) = Gg5(i);
                B(i-(k-1)*net_input_size,5) = Bg5(i);
                R(i-(k-1)*net_input_size,6) = Rg6(i);
                G(i-(k-1)*net_input_size,6) = Gg6(i);
                B(i-(k-1)*net_input_size,6) = Bg6(i);
                R(i-(k-1)*net_input_size,7) = Rg7(i);
                G(i-(k-1)*net_input_size,7) = Gg7(i);
                B(i-(k-1)*net_input_size,7) = Bg7(i);
                R(i-(k-1)*net_input_size,8) = Rg8(i);
                G(i-(k-1)*net_input_size,8) = Gg8(i);
                B(i-(k-1)*net_input_size,8) = Bg8(i);
                R(i-(k-1)*net_input_size,9) = Rg9(i);
                G(i-(k-1)*net_input_size,9) = Gg9(i);
                B(i-(k-1)*net_input_size,9) = Bg9(i);
                R(i-(k-1)*net_input_size,10) = Rw1(i);
                G(i-(k-1)*net_input_size,10) = Gw1(i);
                B(i-(k-1)*net_input_size,10) = Bw1(i);
                R(i-(k-1)*net_input_size,11) = Rw2(i);
                G(i-(k-1)*net_input_size,11) = Gw2(i);
                B(i-(k-1)*net_input_size,11) = Bw2(i);
                R(i-(k-1)*net_input_size,12) = Rw3(i);
                G(i-(k-1)*net_input_size,12) = Gw3(i);
                B(i-(k-1)*net_input_size,12) = Bw3(i);
                R(i-(k-1)*net_input_size,13) = Rw4(i);
                G(i-(k-1)*net_input_size,13) = Gw4(i);
                B(i-(k-1)*net_input_size,13) = Bw4(i);
                R(i-(k-1)*net_input_size,14) = Rw5(i);
                G(i-(k-1)*net_input_size,14) = Gw5(i);
                B(i-(k-1)*net_input_size,14) = Bw5(i);
                R(i-(k-1)*net_input_size,15) = Rw6(i);
                G(i-(k-1)*net_input_size,15) = Gw6(i);
                B(i-(k-1)*net_input_size,15) = Bw6(i);
                R(i-(k-1)*net_input_size,16) = Rw7(i);
                G(i-(k-1)*net_input_size,16) = Gw7(i);
                B(i-(k-1)*net_input_size,16) = Bw7(i);
                R(i-(k-1)*net_input_size,17) = Rw8(i);
                G(i-(k-1)*net_input_size,17) = Gw8(i);
                B(i-(k-1)*net_input_size,17) = Bw8(i);
                R(i-(k-1)*net_input_size,18) = Rw9(i);
                G(i-(k-1)*net_input_size,18) = Gw9(i);
                B(i-(k-1)*net_input_size,18) = Bw9(i);
            end
        end
        
        
        I(:,:,1) = R; 
        I(:,:,2) = G; 
        I(:,:,3) = B; 

        if strcmp(MUL_GW,'TRUE') || strcmp(ISS,'TRUE') || strcmp(ISS_GW,'TRUE') || strcmp(PCA_MUL_GW, 'TRUE') || strcmp(ISS_P,'TRUE') || strcmp(ISS_GW_P,'TRUE') 
            % Shift all values to the positive range 
            IR = R - min(R(:));
            IG = G - min(G(:));
            IB = B - min(B(:));
            I(:,:,1) = IR / (max(IR(:)) - min(IR(:)));
            I(:,:,2) = IG / (max(IG(:)) - min(IG(:)));
            I(:,:,3) = IB / (max(IB(:)) - min(IB(:)));
        end
        
        % save image
        if strcmp(SavetoDisk,'TRUE')
            imwrite(I, sprintf('%s/data/%s/%s_%d.png', RootDirectory,[filenames{1,f}],[filenames{1,f}],k));
        end
    end
end
