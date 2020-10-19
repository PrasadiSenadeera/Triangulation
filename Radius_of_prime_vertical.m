function [ N ] = Radius_of_prime_vertical( latitude )
%this function shows the radius of the curvature of the prime vertical
%section at a given latitude.
format long
a=6377301.243;
% here symbol k used as square of eccenticity.
k=0.006637846745256864;

N=a/(1-k*(sin(latitude))^2)^(1/2);

%e=square of e

end 
