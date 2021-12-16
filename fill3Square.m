function fill3Square(P,f,massIndex1,massIndex2,massIndex3,massIndex4,color)
%FILL3SQUARE Summary of this function goes here
%   Detailed explanation goes here
fill3([P(massIndex1,1,f);P(massIndex2,1,f);P(massIndex3,1,f);P(massIndex4,1,f)],[P(massIndex1,2,f);P(massIndex2,2,f);P(massIndex3,2,f);P(massIndex4,2,f)],[P(massIndex1,3,f);P(massIndex2,3,f);P(massIndex3,3,f);P(massIndex4,3,f)],color,'LineStyle','none');
end

