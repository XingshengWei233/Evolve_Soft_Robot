load('2x2x2_population.mat')
genome = popGroup{1, 1};
sim = Simulation(genome);
renderer = Renderer(sim);
renderer.video();