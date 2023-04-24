%This is an example script to run the function to process and correct
%photon data to extract bathymetry. The data can be downloaded from
%openaltimetry.org after selecting an appropiate area. The hdf5 files can
%be downloaded from the photon visualization window in openaltimetry
%Copyright: Julius Jara Muñoz, Hochschule Biberach, 2023

%% example 1 using the signal gt3r from the photon data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
file1='processed_ATL03_20220904003921_11321601_005_01.h5'; %this is the hdf5 file downloaded from openaltimetry and stored in the same folder as the scripts

%% get data from h5 file
store=0;%save as a backup file (1=yes; 0=no)
TRACK1=GETDATA_ATL03(file1,store);

%% project data along satellite track (this step may take some minutes depending of the number of photons)
[TRACK2,l] = PROJECTDATA_ATL03(TRACK1);%the output l is the projected profile

%% map point cloud components, this step require manually mapping each part of the point cloud (will be automated in future versions)
%instructions are given in the Command Window of matlab when running the script
mapping=1; %mapping = 1 authorize the mapping; Mapping=0 load previous mapping
signal='gt3r';%type of signal to process

[TRACK3,index_batimetry,index_sea,index_land] = PROFILEDATA(TRACK2,signal,mapping,file1);%the index outputs are the classified point clouds

%% correct sea water refraction
[E_new, N_new, Z_new, TRACK4]=REFRACTIONDATA(TRACK3,signal);

%% plot and format outputs
window=20;%movin mean window, stable at 20
[BAT,LAND,SEA,BAT_corr,Ms]=FORMATOUTPUTDATA(TRACK4,signal,window,file1);






%% example 2 using the signal gt2r from the photon data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

file1='processed_ATL03_20220904003921_11321601_005_01.h5';

%% get data from h5 file
store=0;
TRACK1=GETDATA_ATL03(file1,store);

%% project data along satellite track
[TRACK2,l] = PROJECTDATA_ATL03(TRACK1);

%% map point cloud components 
mapping=0; signal='gt2r';

[TRACK3,index_batimetry,index_sea,index_land] = PROFILEDATA(TRACK2,signal,mapping,file1);

%% correct sea water refraction
[E_new, N_new, Z_new, TRACK4]=REFRACTIONDATA(TRACK3,signal);

%% plot and format outputs
window=5;
[BAT,LAND,SEA,BAT_corr,Ms]=FORMATOUTPUTDATA(TRACK4,signal,window,file1);






%% example 3 using signal gt2l %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

file1='processed_ATL03_20220904003921_11321601_005_01.h5';

%% get data from h5 file
store=0;
TRACK1=GETDATA_ATL03(file1,store);

%% project data along satellite track
[TRACK2,l] = PROJECTDATA_ATL03(TRACK1);

%% map point cloud components 
mapping=1; signal='gt2l';

[TRACK3,index_batimetry,index_sea,index_land] = PROFILEDATA(TRACK2,signal,mapping,file1);

%% correct sea water refraction
[E_new, N_new, Z_new, TRACK4]=REFRACTIONDATA(TRACK3,signal);

%% plot and format outputs
window=4;
[BAT,LAND,SEA,BAT_corr,Ms]=FORMATOUTPUTDATA(TRACK4,signal,window,file1);





%% example 4 using signal gt1r %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

file1='processed_ATL03_20220904003921_11321601_005_01.h5';

%% get data from h5 file
store=0;
TRACK1=GETDATA_ATL03(file1,store);

%% project data along satellite track
[TRACK2,l] = PROJECTDATA_ATL03(TRACK1);

%% map point cloud components 
mapping=1; signal='gt1r';

[TRACK3,index_batimetry,index_sea,index_land] = PROFILEDATA(TRACK2,signal,mapping,file1);

%% correct sea water refraction
[E_new, N_new, Z_new, TRACK4]=REFRACTIONDATA(TRACK3,signal);

%% plot and format outputs
window=4;
[BAT,LAND,SEA,BAT_corr,Ms]=FORMATOUTPUTDATA(TRACK4,signal,window,file1);


