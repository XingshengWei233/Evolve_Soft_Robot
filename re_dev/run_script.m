%init sims first

%define parameters
sideLength = 3;
popSize = 100;
nUnitCubeType = 2;
nWorker = 4;
iteration = 100;
logInterval = 100;

%generate a population of genome

pop = Population(popSize, sideLength, nUnitCubeType);
pop.sortPop();

%loop:
for j = 1 : iteration
    allChildren = zeros(nWorker, sideLength, sideLength, sideLength);
    allSpeeds = zeros(nWorker, 1);
    for i = 1 : nWorker
        %select parents
        parent1 = pop.genomes(randi(popSize), :, :, :);
        parent2 = pop.genomes(randi(popSize), :, :, :);
        %make new genomes
        child = pop.crossover(parent1, parent2);
        child = pop.mutate(child);
        allChildren(i, :, :, :) = child;
    end
    %simulate children
    parfor i = 1 : nWorker
        child = allChildren(i, :, :, :);
        sim = Simulation(child);
        speed = sim.evaluate(speed);
        allSpeeds(i) = speed;
    end
    
    %sort and select
    pop.insertSortSelect(allChildren, allSpeeds);
    
    if rem(j, logInterval) == 0
        pop.log();
    end
    disp('iteration' + num2str(j));
end
