clear all;
close all;
clc;

%Titv = 30;%total time interval
%dt=0.005;

%spring parameters
% kMin = 1000; kMax = 10000;
% bMax = 4;
% cMax = 2*pi;
jMax = 300;%iteration number

%generate initial population
pop = 20;
multiCubeSize=5;
nCube=(multiCubeSize-1)^3;


genoPop = zeros(pop,nCube);
popSpeed = zeros(pop,2);
popSpeed(:,1) = [1:pop];
totPopSpeed = zeros(pop,jMax);
%totGenoBest = zeros(jMax,nCube);
for i = 1:pop
    genoPop(i,:)=randi(3,1,nCube)-1;
    popSpeed(i,2) = evaluate(genoPop(i,:),multiCubeSize);
end
disp('initial population speed evaluated');

%sort initial population

popSpeed = sortrows(popSpeed,2,'descend');
rankedIndex = popSpeed(:,1);
genoPopSorted = zeros(pop,nCube);
for i = 1:pop
    genoPopSorted(i,:) = genoPop(rankedIndex(i),:);
end
genoPop = genoPopSorted;
popSpeed = popSpeed(:,2);


for j = 1:jMax

    
    %inheritate a child
    chosen = randi(pop,1,2);%choose two individual to be parent
    parent1 = genoPop(chosen(1),:);
    parent2 = genoPop(chosen(2),:); 
    child = crossover(parent1,parent2);
    child = mutate(child);
    childSpeed = evaluate(child,multiCubeSize);
    
    %sort the child into population
    childRank = 1;
    for i = 1:pop
        if childSpeed<popSpeed(i)
            childRank = i+1;
        end
    end
    if childRank<=pop
        popSpeed(childRank+1:end) = popSpeed(childRank:end-1);
        popSpeed(childRank) = childSpeed;
        genoPop(childRank+1:end,:) = genoPop(childRank:end-1,:);
        genoPop(childRank,:) = child;
    end
    
    %record best speed
    %totSpeedBest(j) = popSpeed(1);
    totPopSpeed(:,j) = popSpeed;
    %totGenoBest(j,:) = genoPop(1,:);
    disp('iteration:')
    disp(j)
end
%% write in file:
fileID = fopen('totPopSpeed.txt','w');
for i = 1:pop
    fprintf(fileID,'%f ',totPopSpeed(i,:));
    fprintf(fileID,'\n');
end
fclose(fileID);

fileID = fopen('genoBest.txt','w');
for i = 1:pop
    fprintf(fileID,'%d ',genoPop(i,:));
    fprintf(fileID,'\n');
end
fclose(fileID);
%% plot
figure(10000000)
k=[1:jMax];
plot(k,totPopSpeed(1,:));


