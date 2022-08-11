clc
clear all

% Save an episode of best robot walking from file to a video
load('saved_population/population.mat')
genome = popGroup{1, 1};
sim = Simulation(genome);
renderer = Renderer(sim);
renderer.video();