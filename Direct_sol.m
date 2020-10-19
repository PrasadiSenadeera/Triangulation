function [ App_lat ,App_long ] = Direct_sol(lat,long,fAZ,s)
%This function allows you to find the latitude and longitude of a point using
%direct solution of the mid latitude formula


for i=1:4
    if (i==1)
        DA=0;   %DA delta Azimuth
        lat_dif=0;
        
    else
    mid_lat=lat+(lat_dif/2);
    long_dif=(s*sin(fAZ+(DA/2)))/(Radius_of_prime_vertical(mid_lat)*cos(mid_lat));
    lat_dif=(s*cos(fAZ+(DA/2)))/(Radius_of_meridian(mid_lat)*cos(long_dif/2));
    DA=lat_dif*sin(mid_lat);
    end
end

    App_lat= lat+lat_dif;
    App_long=long+long_dif;
    

end

