clc
close all
clear all

%define parameters
sideLength = 4;
popSize = 64;
nWorker = 6;
iteration = 10;
logInterval = 2;

%generate a population of genome
pop = Population(popSize, sideLength);

%loop:
for j = 1 : iteration
    t0 = tic;

    %produce new generation
    children = zeros(nWorker, sideLength, sideLength, sideLength);
    speeds = zeros(nWorker, 1);
    speed = 0;
    parfor i = 1 : nWorker
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

    %sort and select
    pop = pop.insertSortSelect(children, speeds);

    %visualize and save
    pop = pop.plotCurve();
    if rem(j, logInterval) == 0
        pop = pop.save();
    end

    t_iter = toc(t0);
    disp(strcat('iteration: ', num2str(j), ' time: ', num2str(t_iter)));
end
