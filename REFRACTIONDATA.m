function [E_new, N_new, Z_new, TRACK]=REFRACTIONDATA(TRACKS,signal)

B(:,1)=TRACKS.(sprintf('%s',signal)).photon.process_distprofile(:,3);
B(:,2)=TRACKS.(sprintf('%s',signal)).photon.ph_Z;


IDb=extractfield(TRACKS.(sprintf('%s',signal)).photon,'Z_ph_b')';
IDs=extractfield(TRACKS.(sprintf('%s',signal)).photon,'Z_ph_s')';

SEA(:,1)=B(IDs(:,1)==1,1);
SEA(:,2)=B(IDs(:,1)==1,2);

%bathymetry profile uncorrected
BAT(:,1)=B(IDb(:,1)==1,1);
BAT(:,2)=B(IDb(:,1)==1,2);

E=TRACKS.(sprintf('%s',signal)).photon.ph_E;
N=TRACKS.(sprintf('%s',signal)).photon.ph_N;
Z=TRACKS.(sprintf('%s',signal)).photon.ph_Z;

%ENU coordinates of bathymetry photons in degs
E_ph1=E(IDb(:,1)==1,1);
N_ph1=N(IDb(:,1)==1,1);
Z_ph=Z(IDb(:,1)==1,1);

%ENU coordinates of bathymetry photons in utm
[E_ph,N_ph,utmzone] = deg2utm(N_ph1,E_ph1);


%Sea level model
W_SL=mean(SEA(:,2));

%ref data
ref_prof=TRACKS.(sprintf('%s',signal)).reference.process_distprofile(:,3);
ref_elev=TRACKS.(sprintf('%s',signal)).reference.process_distprofile(:,4);
ref_az=TRACKS.(sprintf('%s',signal)).reference.process_distprofile(:,5);

%get ref_elev and ref_azimuth for photon data
ref_elev_ph = interp1(ref_prof,ref_elev,BAT(:,1));
ref_az_ph = interp1(ref_prof,ref_az,BAT(:,1));

%refraction values
deltaTheta=2;
n1 = 1.00029;       % Default refractive index of air
n2 = 1.34116;       % Default refractive index of seawater 

%Refraction correction E, N and U in UTM
[E_new1, N_new1, Z_new]=refraction_correction_atlas_UPDATE(E_ph, N_ph, Z_ph, W_SL, ...
    ref_elev_ph, ref_az_ph, deltaTheta, n1, n2);

%back to deg
[N_new,E_new] = utm2deg(E_new1,N_new1,utmzone);

%reproject to profile
%define profile based on track
%get track geometry
[P1,Id1]=  min(TRACKS.(sprintf('%s',signal)).photon.ph_N);
[P2,Id2]=  max(TRACKS.(sprintf('%s',signal)).photon.ph_N);
l(1,:)=[TRACKS.(sprintf('%s',signal)).photon.ph_E(Id1) TRACKS.(sprintf('%s',signal)).photon.ph_N(Id1)];
l(2,:)=[TRACKS.(sprintf('%s',signal)).photon.ph_E(Id2) TRACKS.(sprintf('%s',signal)).photon.ph_N(Id2)];

md(:,1)=E_new;
md(:,2)=N_new;
md(:,3)=Z_new;

type=1;%unflipped
Bat_corr_proj=projection(l,md,type); 


TRACK=TRACKS;

TRACK.(sprintf('%s',signal)).photon.Z_corrected=Z_new;
TRACK.(sprintf('%s',signal)).photon.E_corrected=E_new;
TRACK.(sprintf('%s',signal)).photon.N_corrected=N_new;
TRACK.(sprintf('%s',signal)).photon.profile_corrected=Bat_corr_proj(:,3);

figure
clf
subplot(2,1,1)
hold on
%plot(SEA(:,1),SEA(:,2),'.k')
plot(BAT(:,1),BAT(:,2),'.k')
plot(Bat_corr_proj(:,3),Z_new,'.r')
xlabel('Distance along profile (km)'); ylabel('Elevation (m)')

legend('uncorrected','corrected','location','southeast')

subplot(2,1,2)
hold on
plot(E_ph1,N_ph1,'ok')
plot(E_new,N_new,'.r')
xlabel('Easting'); ylabel('Northing')
