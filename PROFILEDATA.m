function [TRACKS,index_batimetry,index_sea,index_land]=PROFILEDATA(TRACK,signal,mapping,file)

profile_ph = TRACK.(sprintf('%s',signal)).photon.process_distprofile(:,3)*1e3;

Z_ph=TRACK.(sprintf('%s',signal)).photon.process_distprofile(:,4);

CONF_ph=TRACK.(sprintf('%s',signal)).photon.process_distprofile(:,5);

figure
if mapping==0

hold on
plot(profile_ph(CONF_ph==4),Z_ph(CONF_ph==4),'.','Markeredgecolor',[0 0 1])%high
plot(profile_ph(CONF_ph==3),Z_ph(CONF_ph==3),'.','Markeredgecolor',[0.1 0.1 .8])%med
%plot(profile_ph(CONF_ph==2),Z_ph(CONF_ph==2),'.','Markeredgecolor',[0 .8 .8])%low

plot(profile_ph(CONF_ph==0),Z_ph(CONF_ph==0),'.','Markeredgecolor',[0.5 0.5 0.5])%noise
plot(profile_ph(CONF_ph==1),Z_ph(CONF_ph==1),'.','Markeredgecolor',[0 .7 .7])%buffer

%plot(profile_ph(CONF_ph==-1),Z_ph(CONF_ph==-1),'.','Markeredgecolor',[0 0 0])%no surface
plot(profile_ph(CONF_ph==-2),Z_ph(CONF_ph==-2),'.','Markeredgecolor',[1 0 0])%TEP returns

%legend('high','med','low','noise','buffer','no surf.','TEP')
legend('high','med','noise','buffer','TEP')

load(sprintf('INDEX_MAPPING_%s_%s.mat',file,signal));
index_batimetry=IDD.b; index_sea=IDD.s; index_land=IDD.l;

else
       
    %mapping bathymetry
figure(1)
    clf
    disp('select Bathymetry: adjust zoom and press enter when ready')
    [selx_b,sely_b,index_batimetry]=lasso(profile_ph,Z_ph);
    
    %mapping sea
figure(1)
    %clf
    disp('select Sea: adjust zoom and press enter when ready')
    pause 
    [selx_s,sely_s,index_sea]=lasso(profile_ph,Z_ph);
    
    disp('ready')
    
figure(1)
     %   clf
    disp('select Land: adjust zoom and press enter when ready (twice)')
    pause 
    [selx_s,sely_s,index_land]=lasso(profile_ph,Z_ph);



IDD.b=index_batimetry;
IDD.s=index_sea;
IDD.l=index_land;

%if exist('INDEX_MAPPING.mat','file')==2
if exist(sprintf('INDEX_MAPPING_%s_%s.mat',file,signal),'file')==2
clear IDD index_land index_sea index_batimetry
disp('loading previous mapping. Delete file "INDEX_MAPPING.mat" to strart from scratch')
load(sprintf('INDEX_MAPPING_%s_%s.mat',file,signal));
index_batimetry=IDD.b; index_sea=IDD.s; index_land=IDD.l;
else
save(sprintf('INDEX_MAPPING_%s_%s.mat',file,signal),'IDD')
end


disp('tschuss ... chao')

end

%find selected vals in TRACKS 

TRACKS=TRACK;

Z_ph_b=zeros(numel(Z_ph),1);
Z_ph_b(index_batimetry)=1;%bat

Z_ph_s=zeros(numel(Z_ph),1);
Z_ph_s(index_sea)=1;%sea

Z_ph_l=zeros(numel(Z_ph),1);
Z_ph_l(index_land)=1;%land


TRACKS.(sprintf('%s',signal)).photon.Z_ph_b=Z_ph_b;
TRACKS.(sprintf('%s',signal)).photon.Z_ph_s=Z_ph_s;
TRACKS.(sprintf('%s',signal)).photon.Z_ph_l=Z_ph_l;

