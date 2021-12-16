function boolConnect = connected(m1,m2)
%CONNECTED Summary of this function goes here
boolConnect = 0; %false
for i = 1:length(m1.mConnectedIndex)
    if m1.mConnectedIndex(i) == m2.index
        boolConnect = 1;
    end
end
end

