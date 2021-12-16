function [massIndex] = mLoc(xyzIndex,sideLength)
%CUBEMINDEX Summary of this function goes here

massIndex = xyzIndex(3) + xyzIndex(2)*sideLength + xyzIndex(1)*sideLength^2+1;
end

