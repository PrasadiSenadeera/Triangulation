function [ W ] = weight(  )
%weight matrix clculation
std = xlsread('Data\known data.xlsx','n1:n21');
for i=1:21
    for j=1:21
        if (i==j)
            W(i,j)= std(i);
        else
            W(i,j)=0;
        end
    end 
end

end

