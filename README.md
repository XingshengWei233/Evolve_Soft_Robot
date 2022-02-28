# Evolve Soft Robot
Author: Jiyuan Hu, Xingsheng Wei
## Description:
1. Use MATLAB to build a physics simulator from scratch by creating mass and spring elements, velocity proportional damping and friction law.
2. Use evolutionary algorithm (EA) to evolve a soft robot that "walks" as fast as possible along x-axis. (For practice purpose the algorithm is written without using EA related libraries).
3. Matlab code, requires Parallel Computing Toolbox.
## Portfolio Page:
https://xw2815.wixsite.com/xingshengwei/evolve-soft-robot
## Contents:
### main_Evolution_Parrallel.m
The main script to run.
### main_Evolution_Parrallel_Continue.m
The script that load the best population from last run and keep evolve from it.
### Plotter.m
Plot converge plot and dot plot.
### VideoWriter.m
Run the simulation of one genome and output a video.
### Mass.m
A class of mass of each vertex of unit cube.
### Spring.m
A class of spring that connect verteces of unit cube.
