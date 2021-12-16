function plot3Spring(P,f,spring)
%PLOT3SPRING Summary of this function goes here
%   Detailed explanation goes here
plot3([P(spring.m1index,1,f),P(spring.m2index,1,f)],[P(spring.m1index,2,f),P(spring.m2index,2,f)],[P(spring.m1index,3,f),P(spring.m2index,3,f)],'r-'); 
end

