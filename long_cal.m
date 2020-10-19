% This function returns the co- efficient for the longitudes
function [ C ] = long_cal(m,s,A,lat) 
%M- Radius of the prime vertical for mid latitude;
%S - distance between forward/backward station and instrument station
%A- Azimuth of the line
C =(m/s)*cos(A)*cos(lat);

end
