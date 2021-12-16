function [spring,mass1,mass2] = connectSpring(springIndex,mass1,mass2,b)
%CONNECTSPRING Summary of this function goes here
%   Detailed explanation goes here
spring = Spring(mass1,mass2,b);
spring.index = springIndex;
mass1 = mass1.addSpring([springIndex,1]);
mass2 = mass2.addSpring([springIndex,2]);
mass1.mConnectedIndex = [mass1.mConnectedIndex,mass2.index];
mass2.mConnectedIndex = [mass2.mConnectedIndex,mass1.index];
end

