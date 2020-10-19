
disp('          ********************************')
disp('     Geodetic Triangulation Computation -2016 ')
disp('          *************FG 571*************')
disp(' ')
disp(' ')

format long % to obtain the 16 decimal points for the readings...
% Latitude and Longitude values of the known points.
latKO=6.6212958;
longKO= 80.83285473;
latHG= 6.718907961;
longHG= 80.74510763;
fAZ= 138.0472778;  %forward Azimuth from HG to KO

%***************find the radian values for latitudes and longitudes.

rad_latKO =con_rad(latKO);
rad_longKO =con_rad(longKO);
rad_latHG =con_rad(latHG);
rad_longHG =con_rad(longHG);
rad_fAZ=con_rad(fAZ);


%**************To find the Azimuth from Hawagala to other stations 

Az1=rad_fAZ+con_rad(xlsread('Data\known data.xlsx',1,'i80'));    %Azimuth  from Hawagala to Hatarabage
Az2=rad_fAZ-con_rad(xlsread('Data\known data.xlsx',1,'f80'));   %Azimuth  from Hawagala to Kirimaduhela 
Az3=rad_fAZ-con_rad(xlsread('Data\known data.xlsx',1,'i1'));   %Azimuth  from Hawagala to New paraviyangala
Az4=Az3+con_rad(xlsread('Data\known data.xlsx',1,'b80'));  %Azimuth  from Hawagala to Bogandeniyahena
Az5=rad_fAZ-con_rad(xlsread('Data\known data.xlsx',1,'i2')); % Azimuth from hawagala to bogandeniyahena using another method can use to check the accuracy of the task

Az= [Az1,Az2,Az3,Az4];
Az=con_rad_dig(Az);
xlswrite('Results\Azimuth from Hawagala.xlsx',Az);
disp('Azimuth from Hawagala to other four unknown stations were calculated Succesfully.')
disp(' ')

An= xlsread('Data\known data.xlsx',1,'k1:k21'); % read the included angles
An=con_rad(An);%Convert the included angles in to radians
xlswrite('Results\mean angles.xlsx',An,'a1:a21'); %write the converted included angles in Excel sheet
An= xlsread('Results\mean angles.xlsx',1,'a1:a21'); %read the included angles in radians

%***************Calculation The ellipsoidal distance between Hawagala and Kirioluhena 
[S,bAZ,R]=inv_sol(rad_latHG,rad_longHG,rad_latKO,rad_longKO,rad_fAZ);

disp('The ellipsoidal distance between Hawagala to Kirioluhena was found succesfuly ')
disp(' ')


xlswrite('Results\Base length.xlsx',S); %Write the base length in an Excelsheet

%***************Calculation length of the spherical triangles


s(1)=FindLength((An(14,1)+An(15,1)+An(16,1)),An(1,1),S,R); %Distance from hawagala to hatarabage
s(2)=FindLength((An(14,1)+An(15,1)+An(16,1)),An(13,1),S,R);%Distance from hatarabage to Kirioluhena
s(3)=FindLength((An(17,1)+An(18,1)),An(12,1),S,R);%Distance from Kirioluhena to Kirimaduhela
s(4)=FindLength(An(17,1),(An(1,1)+An(2,1)),s(2),R);%Distance from Hatarabage to Kirimaduhela
s(5)=FindLength((An(17,1)+An(18,1)),An(2,1),S,R);%Distance from Hawagala to Kirimaduhela
s(6)=FindLength((An(4,1)+An(5,1)),(An(2,1)+An(3,1)),S,R);%Distance from Hawagala to Bogandeniyahena
s(7)=FindLength((An(4,1)+An(5,1)),(An(12,1)+An(11,1)),S,R);%Distance from Kirioluhena to Bogandeniyahena
s(8)=FindLength(An(4,1),An(3,1),s(3),R);%Distance from Kirimaduhela to Bogandeniyahena
s(9)=FindLength(An(7,1),An(20,1),s(8),R);%Distance from New paraviyangala to Bogandeniyahena
s(10)=FindLength(An(9,1),An(14,1),s(1),R);%Distance from Hawagala to new paraviyangala
s(11)=FindLength(An(8,1),(An(19,1)+An(18,1)),s(4),R); %Distance from new paraviyangala to hatarabage
s(12)=FindLength(An(7,1),(An(5,1)+An(6,1)),s(8),R); %Distance from new paraviyangala to kirimaduhela


xlswrite('Results\Length of sides.xlsx',s); %Write the length of all sides in an Excelsheet

disp('Length of the all sides were found succesfuly using sine formular')
disp(' ')


%************Find the Approximate coordinates of stations


%------Find the approximate coordinate of Hatarabage
[lat1,long1]=Direct_sol(rad_latHG,rad_longHG,Az1,s(1));
lat(1)=lat1;                                                                
long(1)=long1;


%------Find the approximate coordinate of New Paraviyangala
[lat2,long2]=Direct_sol(rad_latHG,rad_longHG,Az3,s(10));
lat(2)=lat2;                                                                
long(2)=long2;

%------Find the approximate coordinate of Kirimaduhela

[lat3,long3]=Direct_sol(rad_latHG,rad_longHG,Az2,s(5));
lat(3)=lat3;                                                                
long(3)=long3;


%------Find the approximate coordinate of Bogandeniyahena
[lat4,long4]=Direct_sol(rad_latHG,rad_longHG,Az4,s(6));
lat(4)=lat4;                                                                
long(4)=long4;

[lat5,long5]=Direct_sol(rad_latHG,rad_longHG,rad_fAZ,S);
lat52=con_rad_dig(lat5);
lat53=con_rad_dig(long5);

App_cor = [lat ,long];
App_cor=toDegrees('radians',App_cor);
xlswrite('Results\App cordinates.xlsx',App_cor);
%con_rad_dig(lat1),con_rad_dig(lat2),con_rad_dig(lat3),con_rad_dig(lat4)
%con_rad_dig(long1),con_rad_dig(long2),con_rad_dig(long3),con_rad_dig(long4),

disp('Approximate coordinates of four sations were found succesfuly ')
disp(' ')

%***************Finding the  Azimuth of every line ***********
 
% Lines starts from New Paraviyangala
NP_to_HG = Azimuth(lat(2),long(2),rad_latHG,rad_longHG);
NP_to_HB = Azimuth(lat(2),long(2),lat(1),long(1));
NP_to_BG = Azimuth(lat(2),long(2),lat(4),long(4));
NP_to_KH = Azimuth(lat(2),long(2),lat(3),long(3));

% Lines starts from Hawagala
HG_to_NP = Azimuth(rad_latHG,rad_longHG,lat(2),long(2));
HG_to_BG = Azimuth(rad_latHG,rad_longHG,lat(4),long(4));
HG_to_KH = Azimuth(rad_latHG,rad_longHG,lat(3),long(3));
HG_to_HB = Azimuth(rad_latHG,rad_longHG,lat(1),long(1));
HG_to_KO = Azimuth(rad_latHG,rad_longHG,rad_latKO,rad_longKO);

% Lines starts from Hatarabage
HB_to_HG= Azimuth(lat(1),long(1),rad_latHG,rad_longHG);
HB_to_NP= Azimuth(lat(1),long(1),lat(2),long(2));
HB_to_KH = Azimuth(lat(1),long(1),lat(3),long(3));
HB_to_KO = Azimuth(lat(1),long(1),rad_latKO,rad_longKO);

%Lines starts from kirimaduhela
KH_to_HG = Azimuth(lat(3),long(3),rad_latHG,rad_longHG);
KH_to_NP = Azimuth(lat(3),long(3),lat(2),long(2));
KH_to_BG = Azimuth(lat(3),long(3),lat(4),long(4));
KH_to_HB = Azimuth(lat(3),long(3),lat(1),long(1));
KH_to_KO = Azimuth(lat(3),long(3),rad_latKO,rad_longKO);

% Lines starts from Bogandenihena
BG_to_HG = Azimuth(lat(4),long(4),rad_latHG,rad_longHG);
BG_to_KO = Azimuth(lat(4),long(4),rad_latKO,rad_longKO);
BG_to_NP = Azimuth(lat(4),long(4),lat(2),long(2));
BG_to_KH = Azimuth(lat(4),long(4),lat(3),long(3));

% Lines starts from Kirioluhena
KO_to_HG = Azimuth(rad_latKO,rad_longKO,rad_latHG,rad_longHG);
KO_to_BG = Azimuth(rad_latKO,rad_longKO,lat(4),long(4));
KO_to_KH = Azimuth(rad_latKO,rad_longKO,lat(3),long(3));
KO_to_HB = Azimuth(rad_latKO,rad_longKO,lat(1),long(1));

disp('Azimuth of the all lines were found succesfuly ')
disp(' ')

% Find the new distances from inverse of mid latitude formula

NewDistance(1)= Find_Distance(lat(1),long(1),rad_latHG,rad_longHG,HB_to_HG); %Distance from hawagala to hatarabage
NewDistance(2)= Find_Distance(rad_latKO,rad_longKO,lat(1),long(1),KO_to_HB);%Distance from hatarabage to Kirioluhena
NewDistance(3)= Find_Distance(rad_latKO,rad_longKO,lat(3),long(3),KO_to_KH);%Distance from Kirioluhena to Kirimaduhela
NewDistance(4)= Find_Distance(lat(1),long(1),lat(3),long(3),HB_to_KH);%Distance from Hatarabage to Kirimaduhela
NewDistance(5)= Find_Distance(lat(3),long(3),rad_latHG,rad_longHG,KH_to_HG);%Distance from Hawagala to Kirimaduhela
NewDistance(6)= Find_Distance(rad_latHG,rad_longHG,lat(4),long(4),HG_to_BG);%Distance from Hawagala to Bogandeniyahena
NewDistance(7)= Find_Distance(rad_latKO,rad_longKO,lat(4),long(4),KO_to_BG);%Distance from Kirioluhena to Bogandeniyahena
NewDistance(8)= Find_Distance(lat(3),long(3),lat(4),long(4),KH_to_BG);%Distance from Kirimaduhela to Bogandeniyahena
NewDistance(9)= Find_Distance(lat(2),long(2),lat(4),long(4),NP_to_BG);%Distance from New paraviyangala to Bogandeniyahena
NewDistance(10)= Find_Distance(lat(2),long(2),rad_latHG,rad_longHG,NP_to_HG);%Distance from Hawagala to new paraviyangala
NewDistance(11)= Find_Distance(lat(2),long(2),lat(1),long(1),NP_to_HB);%Distance from new paraviyangala to hatarabage
NewDistance(12)= Find_Distance(lat(2),long(2),lat(3),long(3),NP_to_KH);%Distance from new paraviyangala to kirimaduhela
xlswrite('Results\New Length of sides.xlsx',NewDistance); %Write the length of all sides in an Excelsheet

disp('Length of the all lines were computed succesfuly using mid latitude formula. ')
disp(' ')


inclu_angle= [ (App_In(KO_to_HG,KO_to_HB));%include angle 1
               (App_In(KO_to_HG,KO_to_KH));%include angle 2
               (App_In(KO_to_KH,KO_to_BG));%include angle 3
               (App_In(BG_to_KH,BG_to_KO));%include angle 4
               (App_In(BG_to_HG,BG_to_KH));%include angle 5
               (App_In(BG_to_NP,BG_to_HG));%include angle 6
               (App_In(NP_to_KH,NP_to_BG));%include angle 7
               (App_In(NP_to_HB,NP_to_KH));%include angle 8
               (App_In(NP_to_HG,NP_to_HB));%include angle 9
               (App_In(HG_to_BG,HG_to_NP));%include angle 10
               (App_In(HG_to_KH,HG_to_BG));%include angle 11
               (App_In(HG_to_KO,HG_to_KH));%include angle 12
               (App_In(HG_to_HB,HG_to_KO));%include angle 13
               (App_In(HB_to_NP,HB_to_HG));%include angle 14
               (App_In(HB_to_KH,HB_to_NP));%include angle 15
               (App_In(HB_to_KO,HB_to_KH));%include angle 16
               (App_In(KH_to_HB,KH_to_KO));%include angle 17
               (App_In(KH_to_HG,KH_to_HB));%include angle 18
               (App_In(KH_to_NP,KH_to_HG));%include angle 19
               (App_In(KH_to_BG,KH_to_NP));%include angle 20
               (App_In(KH_to_KO,KH_to_BG));%include angle 21
               ] ;           

           
           
           
xlswrite('Results\Appro_angle.xlsx',inclu_angle);            %Write the Approximate include angle in an Excelsheet      

disp('Included angles of the lines were computed using calculated azimuths')
disp(' ')

%Calculation of F Matrix ( Approximated included angles- actual observed values)
Obs_Ang=xlsread('Results\mean angles.xlsx',1,'a1:a21'); 
F = inclu_angle-Obs_Ang;
xlswrite('Results\F matrix.xlsx',F);
disp('F matrix (error matrix) was created succesfuly ')
disp(' ')

%Find the Radius of meridian and Radius of prime vertical for Prime
%verticals for the area

mid_lat=(lat1+lat2+lat3+lat4+rad_latHG+rad_latKO)/6;
M=Radius_of_meridian(mid_lat)  ;                             %M- Radius of the meridian for the area
N=Radius_of_prime_vertical(mid_lat) ;                        %N- Radius of the Prime vertical  for the area



% Write all azimuth in a metrix to easy calculations
A=[HB_to_HG,HB_to_NP,HB_to_KH,0,HB_to_KO;           %Lines from hatarabage ,in clockwise direction
   NP_to_BG,NP_to_KH,0,NP_to_HB,NP_to_HG;            %Lines from new paraviyangala ,in clockwise direction
   KH_to_KO,KH_to_HB,KH_to_HG,KH_to_NP,KH_to_BG;   %Lines from Kirimaduhela ,in clockwise direction
   BG_to_KO,BG_to_KH,0,BG_to_HG,BG_to_NP;            %Lines from bogandeniyahena ,in clockwise direction
   HG_to_NP,HG_to_BG,HG_to_KH,rad_fAZ,HG_to_HB;      %Lines from Hawagala ,in clockwise direction
   KO_to_HB,bAZ,0,KO_to_KH,KO_to_BG; ];                %Lines from Kirioluhena ,in clockwise direction


xlswrite('Results\Azimuth',A);


% calculation of B matrix

B=  [ lat_cal(-M,s(2),A(1,5)),0,0,0,long_cal(N,s(2),A(1,5),lat1),0,0,0;
    0,0,lat_cal(M,s(3),A(3,1)),0,0,0,long_cal(-N,s(3),A(3,1),lat3),0;
    0,0,lat_cal(-M,s(3),A(3,1)),lat_cal(M,s(7),A(4,1)),0,0,long_cal(N,s(3),A(3,1),lat3),long_cal(-N,s(7),A(4,1),lat4);
    0,0,lat_cal(M,s(8),A(3,5)),(lat_cal(M,s(8),A(4,2))-lat_cal(M,s(7),A(4,1))),0,0,long_cal(-N,s(8),A(3,5),lat3),(long_cal(N,s(8),A(3,5),lat3)-long_cal(N,s(7),A(6,5),rad_latKO));
    0,0,lat_cal(-M,s(8),A(3,5)),(lat_cal(M,s(6),A(4,4))-lat_cal(M,s(8),A(4,2))),0,0,long_cal(N,s(8),A(3,5),lat3),(long_cal(N,s(6),A(5,2),rad_latHG)-long_cal(N,s(8),A(3,5),lat3));
    0,lat_cal(M,s(9),A(2,1)),0,(lat_cal(M,s(9),A(4,5))-lat_cal(M,s(6),A(4,4))),0,long_cal(-N,s(9),A(2,1),lat2),0,(long_cal(N,s(9),A(2,1),lat2)-long_cal(N,s(6),A(5,2),rad_latHG));
    0,(lat_cal(M,s(12),A(2,2))-lat_cal(M,s(9),A(2,1))),lat_cal(M,s(12),A(3,4)),lat_cal(-M,s(9),A(4,5)),0,(long_cal(N,s(12),A(3,4),lat3)-long_cal(N,s(9),A(4,5),lat4)),long_cal(-N,s(12),A(3,4),lat3),long_cal(N,s(9),A(2,1),lat4);
    lat_cal(M,s(11),A(1,2)),(lat_cal(M,s(11),A(2,4))-lat_cal(M,s(12),A(2,2))),lat_cal(-M,s(12),A(3,4)),0,long_cal(-N,s(11),A(1,2),lat1),(long_cal(N,s(11),A(1,2),lat1)-long_cal(N,s(12),A(3,4),lat3)),long_cal(N,s(12),A(3,4),lat3),0;
    lat_cal(-M,s(11),A(1,2)),(lat_cal(M,s(10),A(2,5))-lat_cal(M,s(11),A(2,4))),0,0,long_cal(N,s(11),A(1,2),lat1),(long_cal(N,s(10),A(5,1),rad_latHG)-long_cal(N,s(11),A(1,2),lat1)),0,0;
    0,lat_cal(-M,s(10),A(2,5)),0,lat_cal(M,s(6),A(4,4)),0,long_cal(N,s(10),A(2,5),lat2),0,long_cal(-N,s(6),A(4,4),lat4);
    0,0,lat_cal(M,s(5),A(3,3)),lat_cal(-M,s(6),A(4,4)),0,0,long_cal(-N,s(5),A(3,3),lat3),long_cal(N,s(6),A(4,4),lat4);
    0,0,lat_cal(-M,s(5),A(3,3)),0,0,0,long_cal(N,s(5),A(3,3),lat3),0;
    lat_cal(M,s(1),A(1,1)),0,0,0,long_cal(-N,s(1),A(1,1),lat1),0,0,0;
    (lat_cal(M,s(11),A(1,2)-lat_cal(M,s(1),A(1,1)))),lat_cal(M,s(11),A(2,4)),0,0,(long_cal(N,s(11),A(2,4),lat2)-long_cal(N,s(1),A(5,5),rad_latHG)),long_cal(-N,s(11),A(2,4),lat2),0,0;
    (lat_cal(M,s(4),A(1,3)-lat_cal(M,s(11),A(1,2)))),lat_cal(-M,s(11),A(2,4)),lat_cal(M,s(4),A(3,2)),0,(long_cal(N,s(4),A(3,2),lat3)-long_cal(N,s(11),A(2,4),lat2)),long_cal(N,s(11),A(2,4),lat2),long_cal(-N,s(4),A(3,2),lat3),0;
    (lat_cal(M,s(2),A(1,5)-lat_cal(M,s(4),A(1,3)))),0,lat_cal(-M,s(4),A(3,2)),0,(long_cal(N,s(2),A(6,1),rad_latKO)-long_cal(N,s(4),A(3,2),lat3)),0,long_cal(N,s(4),A(3,2),lat3),0;
    lat_cal(M,s(4),A(1,3)),0,(lat_cal(M,s(4),A(3,2))-lat_cal(M,s(3),A(3,1))),0,long_cal(-N,s(4),A(1,3),lat1),0,(long_cal(N,s(5),A(5,3),lat1)-long_cal(N,s(3),A(6,4),rad_latKO)),0;
    lat_cal(-M,s(4),A(1,3)),0,(lat_cal(M,s(5),A(3,3))-lat_cal(M,s(4),A(3,2))),0,long_cal(-N,s(4),A(1,3),lat1),0,(long_cal(N,s(5),A(3,3),rad_latHG)-long_cal(N,s(4),A(1,3),lat1)),0;
    0,lat_cal(M,s(12),A(2,2)),(lat_cal(M,s(12),A(3,4))-lat_cal(M,s(5),A(3,3))),0,0,long_cal(-N,s(12),A(2,2),lat2),(long_cal(N,s(12),A(2,2),lat2)-long_cal(N,s(5),A(5,3),rad_latHG)),0;
    0,lat_cal(-M,s(12),A(2,2)),(lat_cal(M,s(8),A(3,5))-lat_cal(M,s(12),A(3,4))),lat_cal(M,s(8),A(4,2)),0,long_cal(N,s(12),A(2,2),lat2),(long_cal(N,s(8),A(3,5),lat3)-long_cal(N,s(12),A(2,2),lat2)),long_cal(-N,s(8),A(3,5),lat3);
    0,0,(lat_cal(M,s(3),A(3,1))-lat_cal(M,s(8),A(3,5))),lat_cal(-M,s(8),A(4,2)),0,0,(long_cal(N,s(3),A(6,4),rad_latKO)-long_cal(N,s(8),A(4,2),lat4)),long_cal(N,s(8),A(4,2),lat4);
    ];

disp('B matrix was created succesfuly ')
disp(' ')
xlswrite('Results\B matrix.xlsx',B);


%Calculation of weight matrix

W = weight();
xlswrite('Results\weight matrix.xlsx',W);
disp('weight matrix was created succesfuly ')
disp(' ')


X=(transpose(B)*W*B)\(transpose(B)*W*F);
xlswrite('Results\correction.xlsx',X);
disp('Corrections for the stations were computed succesfuly ')
disp(' ')

%Obtain the adjusted coordinates

adj_cor=[App_cor(1,1)+ con_rad_dig(X(1,1));
         App_cor(1,2)+ con_rad_dig(X(2,1));
         App_cor(1,3)+ con_rad_dig(X(3,1));
         App_cor(1,4)+ con_rad_dig(X(4,1));
         App_cor(1,5)+ con_rad_dig(X(5,1));
         App_cor(1,6)+ con_rad_dig(X(6,1));
         App_cor(1,7)+ con_rad_dig(X(7,1));
         App_cor(1,8)+ con_rad_dig(X(8,1))];
     
disp('Adjusted Coordinates were computed succesfuly ')     
disp(' ')
xlswrite('Results\Final_result.xlsx',adj_cor);
 

% Find the residuals for all included angle.
V=B*X+F;
xlswrite('Results\residual matrix.xlsx',V);


adj_Ang_rad=inclu_angle+ V;
adj_Ang=con_rad_dig(adj_Ang_rad);
xlswrite('Results\Adjusted Include Angles.xlsx',adj_Ang);

disp('Adjusted included angles were computed succesfuly ')     
disp(' ')

disp('Finally this graph shows the position of the six stations. ')     
disp(' ')

disp('A: Hawagala ') 
disp(' ')
disp('B: New Paraviyangala ')     
disp(' ')
disp('C: Bogandeniyahena ')     
disp(' ')
disp('D: Kirimaduhela ')     
disp(' ')
disp('E: Kirioluhena ') 
disp(' ')
disp('F: Hatarabage ')     
disp(' ')


y=[latHG,adj_cor(2),adj_cor(4),adj_cor(3),latKO ,adj_cor(1) ];
x=[longHG,adj_cor(6),adj_cor(8),adj_cor(7),longKO,adj_cor(5)];
H=['A';'B';'C';'D';'E';'F'];
labels=cellstr(H);
%cellstr(num2str([1:6]'));
scatter(x,y,'fill');
text(x, y, labels, 'VerticalAlignment','bottom', 'HorizontalAlignment','right')
                         

disp(' ')
disp(' ')
disp('          **************** FG 571****************')
disp('The triangulation calculation of 2016 was finished succesfully')
disp('          ***************************************')






