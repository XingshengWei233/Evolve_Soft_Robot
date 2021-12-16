function springIndex = mToSpr(m1,m2)
%MTOSPR Summary of this function goes here
%   Detailed explanation goes here
for i = 1:length(m1.mConnectedIndex)
    if m1.mConnectedIndex(i) == m2.index
        springIndex = m1.spIndex(i,1);
    end
end
end

