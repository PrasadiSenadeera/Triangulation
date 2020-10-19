% This function returns the co- efficient for the latitudes
function [ R ] = lat_cal( m,s,A)
%M- Radius of the meridian for Mid latitude
%S - distance between forward/backward station and instrument station
%A- Azimuth of the line
R=(m/s)*sin(A);


end

