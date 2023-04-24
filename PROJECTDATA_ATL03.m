function [TRACKS,l]= PROJECTDATA_ATL03(TRACK)

TRACKS=TRACK;
signal_names={'gt3r','gt3l','gt2r','gt2l','gt1r','gt1l'};
%signal_names={'gt2l'};

 for i=1:numel(signal_names)
     clear P1 Id1 l md_ph md_ref dp_ph dp_ref
%      try


signal=signal_names{i}

%get track geometry
[P1,Id1]=  min(TRACK.(sprintf('%s',signal)).photon.ph_N);
[P2,Id2]=  max(TRACK.(sprintf('%s',signal)).photon.ph_N);

%define profile based on track
l(1,:)=[TRACK.(sprintf('%s',signal)).photon.ph_E(Id1) TRACK.(sprintf('%s',signal)).photon.ph_N(Id1)];
l(2,:)=[TRACK.(sprintf('%s',signal)).photon.ph_E(Id2) TRACK.(sprintf('%s',signal)).photon.ph_N(Id2)];

%convert structure to matrix before loop
md_ph(:,1)=TRACK.(sprintf('%s',signal)).photon.ph_E;
md_ph(:,2)=TRACK.(sprintf('%s',signal)).photon.ph_N;
md_ph(:,3)=TRACK.(sprintf('%s',signal)).photon.ph_Z;
md_ph(:,4)=TRACK.(sprintf('%s',signal)).photon.ph_confidence(:,2);%1 land 2 Ocean 4 inland water heigth classified, the sea looks well classified
md_ref(:,1)=TRACK.(sprintf('%s',signal)).reference.ref_longitude;
md_ref(:,2)=TRACK.(sprintf('%s',signal)).reference.ref_latitude;
md_ref(:,3)=TRACK.(sprintf('%s',signal)).reference.ref_elevation;
md_ref(:,4)=TRACK.(sprintf('%s',signal)).reference.ref_azimut;
md_ref(:,5)=TRACK.(sprintf('%s',signal)).reference.ref_geoid;

type=1;%unflipped

dp_ph=projection(l,md_ph,type); 
dp_ref=projection(l,md_ref,type); 

TRACKS.(sprintf('%s',signal)).photon.process_distprofile=dp_ph;
TRACKS.(sprintf('%s',signal)).reference.process_distprofile=dp_ref;

%      catch
%         i=i+1;%in case of missing signals
%     end
     
    if i==3
       disp('50% processed') 
    end
     
end
 
