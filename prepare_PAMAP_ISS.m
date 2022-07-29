%% prepare PAMAP data for MUL2Image
close all;clear;clc
%%
DataDirectory = '/home/maintenance/debug/PAMAP';
imds = dir(DataDirectory);
img_dirs = {imds.name};
filenames_split = split({img_dirs{1,3:end}},"."); filenames = {filenames_split{1,1:end,1}};
num_files = length(filenames);
%% cluster 1
Lying = []; % 1
Sitting = []; % 2
Standing = []; % 3
Walking = []; % 4
Running = []; % 5
NordicWalking = []; % 7
AscendingStairs = []; % 12
DescendingStairs = []; %13
Cycling = []; % 6
RopeJumping = []; % 24
WatchingTV = []; % 9 
ComputerWork = []; % 10
CarDriving = []; % 11
VacuumCleaning = []; % 16
Ironing = []; % 17
FoldingLaundry = []; %18
HouseCleaning = []; % 19
PlayingSoccer = []; % 20

%% read data
for f = 1:3:num_files 
    PAMAP = importfile(DataDirectory + "/" + filenames{1,f}, [2, Inf]);
    Lying = [Lying ; table2array(PAMAP(find(PAMAP.UserMode == 1),1:6))]; % 1
    Sitting = [Sitting; table2array(PAMAP(find(PAMAP.UserMode == 2),1:6))]; % 2
    Standing = [Standing; table2array(PAMAP(find(PAMAP.UserMode == 3),1:6))]; % 3
    Walking = [Walking; table2array(PAMAP(find(PAMAP.UserMode == 4),1:6))]; % 4
    Running = [Running; table2array(PAMAP(find(PAMAP.UserMode == 5),1:6))]; % 5
    Cycling = [Cycling; table2array(PAMAP(find(PAMAP.UserMode == 6),1:6))]; % 6
    NordicWalking = [NordicWalking; table2array(PAMAP(find(PAMAP.UserMode == 7),1:6))]; % 7
    WatchingTV = [WatchingTV; table2array(PAMAP(find(PAMAP.UserMode == 9),1:6))]; % 9 
    ComputerWork = [ComputerWork; table2array(PAMAP(find(PAMAP.UserMode == 10),1:6))]; % 10
    CarDriving = [CarDriving; table2array(PAMAP(find(PAMAP.UserMode == 11),1:6))]; % 11
    AscendingStairs = [AscendingStairs; table2array(PAMAP(find(PAMAP.UserMode == 12),1:6))]; % 12
    DescendingStairs = [DescendingStairs; table2array(PAMAP(find(PAMAP.UserMode == 13),1:6))]; %13
    VacuumCleaning = [VacuumCleaning; table2array(PAMAP(find(PAMAP.UserMode == 16),1:6))]; % 16
    Ironing = [Ironing; table2array(PAMAP(find(PAMAP.UserMode == 17),1:6))]; % 17
    FoldingLaundry = [FoldingLaundry; table2array(PAMAP(find(PAMAP.UserMode == 18),1:6))]; %18
    HouseCleaning = [HouseCleaning; table2array(PAMAP(find(PAMAP.UserMode == 19),1:6))]; % 19
    PlayingSoccer = [PlayingSoccer; table2array(PAMAP(find(PAMAP.UserMode == 20),1:6))]; % 20
    RopeJumping = [RopeJumping; table2array(PAMAP(find(PAMAP.UserMode == 24),1:6))]; % 24
end

%% Swap A with G
tmpA = Lying(:, ([4 5 6]));
tmpB = Lying(:, ([1 2 3]));
Lying(:, [1 2 3]) = tmpA;Lying(:, [4 5 6]) = tmpB;

tmpA = Sitting(:, ([4 5 6]));
tmpB = Sitting(:, ([1 2 3]));
Sitting(:, [1 2 3]) = tmpA;Sitting(:, [4 5 6]) = tmpB;

tmpA = Standing(:, ([4 5 6]));
tmpB = Standing(:, ([1 2 3]));
Standing(:, [1 2 3]) = tmpA;Standing(:, [4 5 6]) = tmpB;

tmpA = Walking(:, ([4 5 6]));
tmpB = Walking(:, ([1 2 3]));
Walking(:, [1 2 3]) = tmpA;Walking(:, [4 5 6]) = tmpB;

tmpA = Running(:, ([4 5 6]));
tmpB = Running(:, ([1 2 3]));
Running(:, [1 2 3]) = tmpA;Running(:, [4 5 6]) = tmpB;

tmpA = Cycling(:, ([4 5 6]));
tmpB = Cycling(:, ([1 2 3]));
Cycling(:, [1 2 3]) = tmpA;Cycling(:, [4 5 6]) = tmpB;

tmpA = NordicWalking(:, ([4 5 6]));
tmpB = NordicWalking(:, ([1 2 3]));
NordicWalking(:, [1 2 3]) = tmpA;NordicWalking(:, [4 5 6]) = tmpB;

tmpA = WatchingTV(:, ([4 5 6]));
tmpB = WatchingTV(:, ([1 2 3]));
WatchingTV(:, [1 2 3]) = tmpA;WatchingTV(:, [4 5 6]) = tmpB;

tmpA = ComputerWork(:, ([4 5 6]));
tmpB = ComputerWork(:, ([1 2 3]));
ComputerWork(:, [1 2 3]) = tmpA;ComputerWork(:, [4 5 6]) = tmpB;

tmpA = CarDriving(:, ([4 5 6]));
tmpB = CarDriving(:, ([1 2 3]));
CarDriving(:, [1 2 3]) = tmpA;CarDriving(:, [4 5 6]) = tmpB;

tmpA = AscendingStairs(:, ([4 5 6]));
tmpB = AscendingStairs(:, ([1 2 3]));
AscendingStairs(:, [1 2 3]) = tmpA;AscendingStairs(:, [4 5 6]) = tmpB;

tmpA = DescendingStairs(:, ([4 5 6]));
tmpB = DescendingStairs(:, ([1 2 3]));
DescendingStairs(:, [1 2 3]) = tmpA;DescendingStairs(:, [4 5 6]) = tmpB;

tmpA = VacuumCleaning(:, ([4 5 6]));
tmpB = VacuumCleaning(:, ([1 2 3]));
VacuumCleaning(:, [1 2 3]) = tmpA;VacuumCleaning(:, [4 5 6]) = tmpB;

tmpA = Ironing(:, ([4 5 6]));
tmpB = Ironing(:, ([1 2 3]));
Ironing(:, [1 2 3]) = tmpA;Ironing(:, [4 5 6]) = tmpB;

tmpA = FoldingLaundry(:, ([4 5 6]));
tmpB = FoldingLaundry(:, ([1 2 3]));
FoldingLaundry(:, [1 2 3]) = tmpA;FoldingLaundry(:, [4 5 6]) = tmpB;

tmpA = HouseCleaning(:, ([4 5 6]));
tmpB = HouseCleaning(:, ([1 2 3]));
HouseCleaning(:, [1 2 3]) = tmpA;HouseCleaning(:, [4 5 6]) = tmpB;

tmpA = PlayingSoccer(:, ([4 5 6]));
tmpB = PlayingSoccer(:, ([1 2 3]));
PlayingSoccer(:, [1 2 3]) = tmpA;PlayingSoccer(:, [4 5 6]) = tmpB;

tmpA = RopeJumping(:, ([4 5 6]));
tmpB = RopeJumping(:, ([1 2 3]));
RopeJumping(:, [1 2 3]) = tmpA;RopeJumping(:, [4 5 6]) = tmpB;

%% save to excels
xlswrite('Lying.xlsx',Lying)
xlswrite('Sitting.xlsx',Sitting)
xlswrite('Standing.xlsx',Standing)
xlswrite('Walking.xlsx',Walking)
xlswrite('Running.xlsx',Running)
xlswrite('Cycling.xlsx',Cycling)
xlswrite('NordicWalking.xlsx',NordicWalking)
xlswrite('AscendingStairs.xlsx',AscendingStairs)
xlswrite('DescendingStairs.xlsx',DescendingStairs)
xlswrite('VacuumCleaning.xlsx',VacuumCleaning)
xlswrite('Ironing.xlsx',Ironing)
xlswrite('RopeJumping.xlsx',RopeJumping)
