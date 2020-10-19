%=============Find the different of Azimuth
function [ t ] = App_In( a,b )

if a<b
    t=b-a;
else
    t=a-b;
end

if t> pi
    t=con_rad(360)-t;
end    
end

