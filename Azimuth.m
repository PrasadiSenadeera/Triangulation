%inverse solution Gauss mid latitude fromular to find the azimuth when latitudes are known%

function [ AZ ] = Azimuth( p1,L1,p2,L2 )
% p1,p2=latitude of 1,2 stations
% L1,L2=longitude of 1,2 stations

DL=L2-L1;  % dL=delta lamda
DP=p2-p1;  % dp=delta phi

pm=(p1+p2)/2; % pm=mid latitude

k=Radius_of_prime_vertical(pm);
l=Radius_of_meridian(pm);
DA= (DL*sin(pm)*sec(DP/2))/2;
AZ = atan( (k*DL*cos(pm))/(l*DP*cos(DL/2)) ) - DA;
if (DL>0 && DP<0 && AZ<0)
    AZ=pi+AZ;
elseif (DL<0 && DP<0 && AZ>0)
    AZ=pi+AZ;
elseif (DL<0 && DP>0 && AZ<0) 
    AZ=2*pi+AZ; 
else
    AZ=AZ;
end

s=(l*DP*cos(DL/2))/(cos(AZ+DA));
end

