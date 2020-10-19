
function [ M ] = Radius_of_meridian( lattitude )

% This is use to find the Radius of the curvature of the Meridianal
% section at a given lattitude

a=6377301.243;
% here symbol k used as square of eccentricity.
k=0.006637846745256864;
  

M=a*(1-k)/(1-k*(sin(lattitude))^2)^(3/2);
end

