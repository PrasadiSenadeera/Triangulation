%inverse solution Gauss mid latitude when forward azimuth is known%
function [ S,bAZ,R ] = inv_sol( lat1,long1,lat2,long2,fAZ )                        %foward azimuth%
mphi=(lat1+lat2)/2;
dlam=(long2-long1);
m=Radius_of_meridian(mphi);                                                              % mphi-mean of the phi%
n=Radius_of_prime_vertical(mphi);                                                              % DA-azimuth difference%

DA=dlam*sin(mphi);  

S=(n*cos(mphi)*dlam)/(sin(fAZ+(DA/2)));
bAZ=fAZ+DA+3.14  ;                                                            %back azimuth%
R=sqrt(m*n); 

end

