%length of spherical triangle using sin formula%
function [ s ] = FindLength( x,y,S,R )        

s=R*asin((sin(y)*sin(S/R))/sin(x));

end

