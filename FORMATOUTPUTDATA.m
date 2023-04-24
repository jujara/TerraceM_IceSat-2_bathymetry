function [BAT,LAND,SEA,BAT_corr,Ms]=FORMATOUTPUTDATA(TRACK_corr,signal,window,file1)

index_batimetry=extractfield(TRACK_corr.(sprintf('%s',signal)).photon,'Z_ph_b')';
index_sea=extractfield(TRACK_corr.(sprintf('%s',signal)).photon,'Z_ph_s')';
index_land=extractfield(TRACK_corr.(sprintf('%s',signal)).photon,'Z_ph_l')';

BAT1(:,1)=TRACK_corr.(sprintf('%s',signal)).photon.process_distprofile(index_batimetry(:,1)==1,3);%distance prof
BAT1(:,2)=TRACK_corr.(sprintf('%s',signal)).photon.ph_Z(index_batimetry(:,1)==1,1);%distance prof

SEA1(:,1)=TRACK_corr.(sprintf('%s',signal)).photon.process_distprofile(index_sea(:,1)==1,3);%distance prof
SEA1(:,2)=TRACK_corr.(sprintf('%s',signal)).photon.ph_Z(index_sea(:,1)==1,1);%distance prof

LAND1(:,1)=TRACK_corr.(sprintf('%s',signal)).photon.process_distprofile(index_land(:,1)==1,3);%distance prof
LAND1(:,2)=TRACK_corr.(sprintf('%s',signal)).photon.ph_Z(index_land(:,1)==1,1);%distance prof

BAT_corr1(:,1)=TRACK_corr.(sprintf('%s',signal)).photon.profile_corrected;%distance prof
BAT_corr1(:,2)=TRACK_corr.(sprintf('%s',signal)).photon.Z_corrected;%distance prof


%geoid correction
GEOID1=TRACK_corr.(sprintf('%s',signal)).reference.ref_geoid;
ref_prof=TRACK_corr.(sprintf('%s',signal)).reference.process_distprofile(:,3);

%geoid at photon location
GEOID_bat = interp1(ref_prof,GEOID1,BAT1(:,1));
GEOID_bat_corrected = interp1(ref_prof,GEOID1,BAT_corr1(:,1));
GEOID_land = interp1(ref_prof,GEOID1,LAND1(:,1));
GEOID_sea = interp1(ref_prof,GEOID1,SEA1(:,1));

BAT=BAT1; 
BAT(:,2)=BAT1(:,2)-GEOID_bat;

BAT_corr=BAT_corr1; 
BAT_corr(:,2)=BAT_corr1(:,2)-GEOID_bat_corrected;

LAND=LAND1; 
LAND(:,2)=LAND1(:,2)-GEOID_land;

SEA=SEA1;
SEA(:,2)=SEA1(:,2)-GEOID_sea;


%create surface
GROUND=vertcat(BAT_corr,LAND);
M=movmean(GROUND,window);
Ms=smoothdata(M,10);

figure
hold on
box on
ap=plot(BAT(:,1),BAT(:,2),'.k');
plot(LAND(:,1),LAND(:,2),'.k')
plot(SEA(:,1),SEA(:,2),'.k')
ab=plot(BAT_corr(:,1),BAT_corr(:,2),'.r');
plot(Ms(:,1),Ms(:,2),'-b','Linewidth',2)
xlim([min(SEA(:,1)) max(LAND(:,1))])
ylim([min(BAT(:,2)) max(LAND(:,2))])
xlabel('Distance along profile (km)')
ylabel('Elevation (m)')

legend([ap ab],'uncorrected','corrected','Location','northwest')

% Save plot
rect=[1 6 18 10];% horiz vert width heigth
set(gcf,'paperunits','centimeters');
set(gcf,'papertype','A4');    
set(gcf,'paperposition',rect);     
fout = sprintf('Profile_%s_%s.pdf',file1,signal);
saveas(gcf,fout,'pdf');


%save 
%profile as csv
csvwrite(sprintf('Profile_%s_%s.csv',file1,signal),Ms)

%all as kml
%land
E_land=TRACK_corr.(sprintf('%s',signal)).photon.ph_E(index_land(:,1)==1,1);
N_land=TRACK_corr.(sprintf('%s',signal)).photon.ph_N(index_land(:,1)==1,1);
Z_land=TRACK_corr.(sprintf('%s',signal)).photon.ph_Z(index_land(:,1)==1,1);

%bat photon corrected
E_batcorr=TRACK_corr.(sprintf('%s',signal)).photon.E_corrected;
N_batcorr=TRACK_corr.(sprintf('%s',signal)).photon.N_corrected;
Z_batcorr=TRACK_corr.(sprintf('%s',signal)).photon.Z_corrected;

%concatenate
E=vertcat(E_batcorr,E_land);
N=vertcat(N_batcorr,N_land);
Z=vertcat(Z_batcorr,Z_land);

%export csv
%csvwrite(sprintf('MAP_%s_%s.csv',file1,signal),[E,N,Z])
dlmwrite(sprintf('MAP_%s_%s.csv',file1,signal),[E,N,Z],'delimiter',',','precision',15)

%export kml googleearth
 kmlFolder = 'KML';

 %create geostruct
 Data = [];  % initilaize structure 
[Data(1:numel(E)).Geometry] = deal('Point'); % Required
for in = 1:numel(E)
Data(in).Lon = E(in);  % longitude % Required
Data(in).Lat = N(in);  % lat % Required
Data(in).elevation = Z(in);  % lat % Required
end

attribspec = makeattribspec(Data);

filename = fullfile(kmlFolder,sprintf('MAP_%s_%s.kml',file1,signal));
kmlwrite(filename,N,E,'Description',attribspec);