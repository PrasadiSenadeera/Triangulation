function [ D ] = Find_Distance( lat1,long1,lat2,long2,fAZ)
%This function is a part of inverse of mid latitude formula and returns the
%distance between two points
mphi=(lat1+lat2)/2;
dlam=(long2-long1);
dphi=(lat2-lat1);
m=Radius_of_meridian(mphi);                                                              % mphi-mean of the phi%
n=Radius_of_prime_vertical(mphi);                                                              % DA-azimuth difference%

DA=dlam*sin(mphi);  
%D=(m*dphi*cos(dlam/2))/(cos((2*fAZ+DA)/2));
D=(n*cos(mphi)*dlam)/(sin((fAZ+fAZ+DA)/2));
%D=(dlam*dlam*mphi*mphi)+(dlam*dlam*n*n*cos(mphi))

end

