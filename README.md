# Evolve Soft Robot
Author: Jiyuan Hu, Xingsheng Wei
## Description:
1. Use MATLAB to build a physics simulator from scratch by creating mass and spring elements, velocity proportional damping and friction law.
2. Use evolutionary algorithm (EA) to evolve a soft robot that "walks" as fast as possible along x-axis. (For practice purpose the algorithm is written without using EA related libraries).
3. Matlab code, requires Parallel Computing Toolbox.
## Portfolio Page:
https://xw2815.wixsite.com/xingshengwei/evolve-soft-robot
## Contents:
### run_script.m
The main script to run evolution.
### replay_script.m
Run the simulation of the best saved genome and output a video.
### Mass.m
A class of mass that can be connected to spring with dynamics.
### Spring.m
A class of spring that can be connected to masses with dynamics.
### Robot.m
A class of soft robot that assembled with masses and springs, which can execute dynamics by time steps.
### Simulation.m
A class of simulation that makes simulation environments with default parameters, which can step the robot and evaluate the speed on X direction.
### Renderer.m
A class of renderer that renders soft robot to images and videos.
### Population.m
A class that contains a population of genomes that can perform crossover, mutation, sorting and plotting fitness curve.
### Test.m
Test script that tests critical functions. (To be updated)
