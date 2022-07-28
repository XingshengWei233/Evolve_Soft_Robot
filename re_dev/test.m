close all;
clear all;

sideLen = 2;
pop = Population(1,sideLen,3);
genome = pop.genomes(1,:,:,:);
genome = squeeze(genome);
sim = Simulation(genome);
masses_val = zeros(sideLen+1,sideLen+1,sideLen+1);
for i = 1:sideLen+1
    for j = 1:sideLen+1
        for k = 1:sideLen+1
            masses_val(i,j,k) = sim.masses(i,j,k).mass;
        end
    end
end
%test connect
% sim = sim.connect([1,1,1], [1,1,2], 1);
% sim = sim.connect([1,1,1], [1,1,3], 1);
% sim = sim.connect([1,1,1], [1,1,2], 0);

%test unitCubeAddSpring
%sim = sim.unitCubeAddSpring(1,1,1);



mass1 = sim.masses(1,1,1);
mass2 = sim.masses(1,1,2);
springs = sim.springs;