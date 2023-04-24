function dp=projection(l,md,type)
%l=profile.  (x , y) in utm coordinates
%md = points in utm to be projected. (x,y,z) in utm 
%type: output TerraceM, flipped (2) unfliped (1) x axis

dx=l(1,1)-l(2,1);
	dy=l(1,2)-l(2,2);
	m=(dy/dx); 
    m2=-1/m;
	an=atand(m);%angle of the profile 
	dkm=sqrt(dx.^2+dy.^2);%length profile
	b=l(1,2)-m*l(1,1);%eq. constant
    
for i=1:length(md(:,1)) 
    clear TOC
    b2=md(i,2)-m2*md(i,1);
    Pnx=(b2-b)/(m-m2);
    Pny=m*Pnx+b;
    %coordinates
    dp(i,1)=Pnx;
    dp(i,2)=Pny;
    %distance along profile
    
if type==1
    
    if an>0       
       
       %TOC=dkm-(dkm+((l(1,2)-Pny)/sind(an))); % distance in km
       TOC=((l(1,2)-Pny)/sind(an));
     clc
        %disp('usual1')
    elseif an<0
        clc
        %disp('special1')
        %TOC=-((l(1,2)-Pny)/sind(an)); % distance in km
        TOC=((l(1,2)-Pny)/sind(an)); % distance in km . ------ > the best
    end
end
    
    
    
if type==2
     
    if an<0      %an>0  
        dk=dkm-(dkm+((l(1,2)-Pny)/sind(an))); % distance in km
      %dp(i,3)=dkm+dk;
      TOC=dkm+dk;
        clc
       % disp('usual2')
    elseif an>0 %an<0
        clc
       % disp('special2')
        %dp(i,3)=-((l(1,2)-Pny)/sind(an)); % distance in km
        TOC=-((l(1,2)-Pny)/sind(an)); % distance in km
    end
        
end

%convert to km
dp(i,3)=deg2km(TOC);
    
    
    dp(i,4)=md(i,3); %z
    
    try
    dp(i,5)=md(i,4); %level
    catch
    end
    
    try
    dp(i,6)=md(i,5); %level
    catch
    end
    
    
end