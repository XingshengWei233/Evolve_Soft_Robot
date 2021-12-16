clear all;
close all;
clc;

geno1 = randi(3,1,27)-1
geno2 = randi(3,1,27)-1
child = crossover(geno1,geno2)
diff = [child-geno1;child-geno2]