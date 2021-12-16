clear all;
close all;
clc;

Titv = 30;%total time interval
dt=0.001;

%spring parameters
kMin = 1000; kMax = 10000;
bMax = 4;
cMax = 2*pi;
jMax = 10000;%iteration number

%generate initial population
pop = 100;
nSpr = 22;

%totSpeedBest = zeros(jMax,1);
genoPop = zeros(nSpr,3,pop);
popSpeed = zeros(pop,1);
totPopSpeed = zeros(pop,jMax);
for i = 1:pop
    genoPop(:,:,i) = generateGeno(kMin,kMax,bMax,cMax);
    popSpeed(i) = evaluate(genoPop(:,:,i),Titv);
end
disp('initial population generated');

%sort initial population
popSpeed(:,2) = [1:pop];
popSpeed = sortrows(popSpeed,'descend');
rankedIndex = popSpeed(:,2);
genoPopSorted = zeros(nSpr,3,pop);
for i = 1:pop
    genoPopSorted(:,:,i) = genoPop(:,:,rankedIndex(i));
end
genoPop = genoPopSorted;
popSpeed = popSpeed(:,1);

for j = 1:jMax
    %geno = generateGeno(kMin,kMax,bMax,cMax); %random search
    %geno = mutate(genoBest); %hillClimber
    
    %inheritate a child
    chosen = randi(pop,1,2);%choose two individual to be parent
    parent1 = genoPop(:,:,chosen(1));
    parent2 = genoPop(:,:,chosen(2));
    child = crossover(parent1,parent2);
    child = mutate(child);
    childSpeed = evaluate(child,Titv);
    
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
        genoPop(:,:,childRank+1:end) = genoPop(:,:,childRank:end-1);
        genoPop(:,:,childRank) = child;
    end
    
    %record best speed
    %totSpeedBest(j) = popSpeed(1);
    totPopSpeed(:,j) = popSpeed;
    
    disp('iteration:')
    disp(j)
end

%% write in file:
%totPopSpeed = totPopSpeed';
fileID = fopen('totPopSpeed.txt','w');
for i = 1:pop
    fprintf(fileID,'%f ',totPopSpeed(i,:));
    fprintf(fileID,'\n');
end
fclose(fileID);

fileID = fopen('genoBest.txt','w');
for i = 1:22
    fprintf(fileID,'%d ',genoPop(i,:,1));
    fprintf(fileID,'\n');
end
fclose(fileID);
%% plot
figure(10000000)
k=[1:jMax];
plot(k,totPopSpeed(1,:));

%qweasdafeqfqffqfwdqdwfqfeqdwdqwfqfwd
%% animation

iteration = Titv/dt;

[speed_Ptot,Ptot] = evaluate(genoPop(:,:,1),Titv);

fps = 25
v = VideoWriter('test.avi');
v.FrameRate = fps;
open(v);


df = 1/fps/dt;
for f = 1:df:iteration
    plotRobot(Ptot,f);
    frame = getframe;
    writeVideo(v,frame);
    f
end

close(v);
