clear all;
close all;
clc;

Titv = 10;%total time interval 10
dt=0.005;
nCore = 4;

%spring parameters
jMax = 200;%iteration number 500

%generate initial population
pop = 50; %50
multiCubeSize=5;
nCube=(multiCubeSize-1)^3;

n = [1:jMax];
totSpeedBest = zeros(1,jMax);
%totGenoBest = zeros(jMax,nCube);

genoPop = importdata('genoLastGenerationC 50-300.txt');
popSpeed = importdata('totPopSpeedC50-300.txt');
popSpeed = popSpeed(end,:)';
%% 
fileSpeed = fopen('totPopSpeedC.txt','w');
fileGeno = fopen('totBestGenoC.txt','w');

for j = 1:jMax
    %inheritate 4 child
    child = zeros(nCore,length(genoPop));
    childSpeed = zeros(nCore,1);
    parfor k = 1:nCore
        chosen = randi(pop,1,2);%choose two individual to be parent
        parent1 = genoPop(chosen(1),:);
        parent2 = genoPop(chosen(2),:); 
        child(k,:) = crossover(parent1,parent2);
        child(k,:) = mutate(child(k,:));
        childSpeed(k) = evaluate(child(k,:),multiCubeSize,Titv,dt);
    end
    %sort the children into population
    for k = 1:nCore
        childRank = 1;
        for i = 1:pop
            if childSpeed(k)<popSpeed(i)
                childRank = i+1;
            end
        end
        if childRank<=pop
            popSpeed(childRank+1:end) = popSpeed(childRank:end-1);
            popSpeed(childRank) = childSpeed(k);
            genoPop(childRank+1:end,:) = genoPop(childRank:end-1,:);
            genoPop(childRank,:) = child(k,:);
        end
    end
    
    for i = 1:pop
        fprintf(fileSpeed,'%f ',popSpeed(i));
    end
    fprintf(fileSpeed,'\n');
    
    fprintf(fileGeno,'%d ',genoPop(1,:));
    fprintf(fileGeno,'\n');
    
    %record best speed
    totSpeedBest(j) = popSpeed(1);
    figure(1)
    plot(n(1:j),totSpeedBest(1:j));
    %totPopSpeed(:,j) = popSpeed;
    %totGenoBest(j,:) = genoPop(1,:);
    disp('iteration:')
    disp(j)
end
%% write in file:
fclose(fileSpeed);
fclose(fileGeno);
fileLastGeno = fopen('genoLastGenerationC.txt','w');
for i = 1:pop
    fprintf(fileLastGeno,'%d ',genoPop(i,:));
    fprintf(fileLastGeno,'\n');
end
fclose(fileLastGeno);



