function vertices = lattice(sideLen)
%GENERATELATTICE Summary of this function goes here
%   Detailed explanation goes here
vertices = zeros(sideLen^3,3);
for i = 1:sideLen
    for j = 1:sideLen
        for k = 1:sideLen
            vertices(mLoc([i j k]-1,sideLen),:) = [i j k];
        end
    end
end
vertices = vertices-1;
end

