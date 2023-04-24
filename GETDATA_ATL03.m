function TRACK=GETDATA_ATL03(filename,store)

% Open the HDF5 File.
file_id = H5F.open (filename, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

% Photon Signal Datasets
signal_names={'gt3r','gt3l','gt2r','gt2l','gt1r','gt1l'};

 for i=1:6
     
     try
signal=signal_names{i};

clear LATFIELD_NAME lat_id LONFIELD_NAME lon_id REF_ELEV ref_elevation_id REF_AZ ref_azim GEOID ref_geoid1 E_photon E N_photon N Z_photon Z ...
    D_photon D CD_photon CD CONFIDENCE_photon CONFIDENCE

disp(sprintf('Processing_signal_%s',signal))

%base
LATFIELD_NAME= [signal,'/geolocation/reference_photon_lat'];
lat_id=H5D.open(file_id,LATFIELD_NAME);

LONFIELD_NAME=[signal,'/geolocation/reference_photon_lon'];
lon_id=H5D.open(file_id,LONFIELD_NAME);

REF_ELEV=[signal ,'/geolocation/ref_elev'];%reference heigth for bathymetry correction
ref_elevation_id=H5D.open(file_id, REF_ELEV);

REF_AZ=[signal ,'/geolocation/ref_azimuth'];%reference azimut for bathymetry correction
ref_azim=H5D.open(file_id, REF_AZ);

GEOID=[signal ,'/geophys_corr/geoid'];%reference azimut for bathymetry correction
ref_geoid1=H5D.open(file_id, GEOID);

TIDE=[signal ,'/geophys_corr/tide_ocean'];%reference azimut for bathymetry correction
ref_tide1=H5D.open(file_id, TIDE);


%photons
E_photon=[signal ,'/heights/lon_ph'];% lon (E) coord
E=H5D.open(file_id, E_photon);

N_photon=[signal ,'/heights/lat_ph'];% lat (N) coord
N=H5D.open(file_id, N_photon);

Z_photon=[signal ,'/heights/h_ph'];% photon corrected height
Z=H5D.open(file_id, Z_photon);

D_photon=[signal ,'/heights/dist_ph_along'];%distance along track
D=H5D.open(file_id, D_photon);

CD_photon=[signal ,'/heights/dist_ph_across'];%distance across track
CD=H5D.open(file_id, CD_photon);

CONFIDENCE_photon=[signal ,'/heights/signal_conf_ph'];%distance along track
CONFIDENCE=H5D.open(file_id, CONFIDENCE_photon);


%%%%%%%%%%%%%%%%%%%%%%%%% READ .h5 and STORE .mat/variable %%%%%%%%%%%%%%%%%%%%%%%%

% Save the datasets to .mat format
TRACK.(sprintf('%s',signal)).reference.ref_latitude=H5D.read(lat_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT');

TRACK.(sprintf('%s',signal)).reference.ref_longitude=H5D.read(lon_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT');     
         
TRACK.(sprintf('%s',signal)).reference.ref_elevation=H5D.read(ref_elevation_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL','H5S_ALL','H5P_DEFAULT');
         
TRACK.(sprintf('%s',signal)).reference.ref_azimut=H5D.read(ref_azim,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT');

TRACK.(sprintf('%s',signal)).reference.ref_geoid=H5D.read(ref_geoid1,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT');

TRACK.(sprintf('%s',signal)).reference.ref_tide=H5D.read(ref_tide1,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT');
         
TRACK.(sprintf('%s',signal)).photon.ph_N=H5D.read(N,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT');         
         
TRACK.(sprintf('%s',signal)).photon.ph_E=H5D.read(E,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT'); 

TRACK.(sprintf('%s',signal)).photon.ph_Z=H5D.read(Z,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT');

TRACK.(sprintf('%s',signal)).photon.ph_D=H5D.read(D,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT');

TRACK.(sprintf('%s',signal)).photon.ph_CD=H5D.read(CD,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT');

TRACK.(sprintf('%s',signal)).photon.ph_confidence=H5D.read(CONFIDENCE,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL','H5P_DEFAULT')';

     catch
      
    i=i+1;   %in case no data  
         
     end

 end

if store == 1
    save(sprintf('TRACS_%s.mat',filename),'TRACK')
end

H5F.close(file_id);
