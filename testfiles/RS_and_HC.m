clear all;
close all;
clc;

Titv = 30;%global time
dt=0.001;

%spring parameters
kMin = 1000; kMax = 10000;
bMax = 4;
cMax = 2*pi


%generate geno

nSpr = 22;
jMax = 10000;
totSpeed = zeros(jMax,1);

geno_0 = generateGeno(kMin,kMax,bMax,cMax);
speedBest = evaluate(geno_0,Titv);
genoBest = geno_0;
%random search
for j = 1:jMax
    geno = generateGeno(kMin,kMax,bMax,cMax); %random search
    %geno = mutate(genoBest); %hillClimber
    speed = evaluate(geno,Titv);
    if speed>speedBest
        genoBest = geno;
        speedBest = speed;
    end
    totSpeed(j) = speedBest;
    j
end

%plot
k=[1:jMax]';
plot(k,totSpeed)


%% animation


iteration = Titv/dt;

[speed_Ptot,Ptot] = evaluate(genoBest,Titv);

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
