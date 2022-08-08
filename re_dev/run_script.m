clc
clear all
%init sims first

%define parameters
sideLength = 3;
popSize = 20;
nUnitCubeType = 2;
nWorker = 6;
iteration = 100;
logInterval = 100;

%generate a population of genome

pop = Population(popSize, sideLength);

%loop:
for j = 1 : iteration
    children = zeros(nWorker, sideLength, sideLength, sideLength);
    speeds = zeros(nWorker, 1);
    speed = 0;
    parfor i = 1 : nWorker
        i
        %select parents
        parent1 = pop.group{randi(popSize), 1};
        parent2 = pop.group{randi(popSize), 1};
        %make new genomes
        child = pop.crossover(parent1, parent2); %needs testing
        child = pop.mutate(child); %needs testing
        children(i, :, :, :) = child;
        sim = Simulation(child);
        speed = sim.evaluate();
        speeds(i) = speed;
    end
    pop = pop.insertSortSelect(children, speeds);
    %simulate children
%     parfor i = 1 : nWorker
%         child = allChildren(i, :, :, :);
%         sim = Simulation(child);
%         speed = sim.evaluate(speed);
%         allSpeeds(i) = speed;
%     end
    
    %sort and select
    pop.insertSortSelect(children, speeds);
    
    if rem(j, logInterval) == 0
        pop.log();
    end
    disp('iteration' + num2str(j));
end
