clear all;
close all;
clc;

Titv = 3;%total time interval in sec
dt=0.01;
T = 0; %global time
iteration = Titv/dt;
g= -9.81;   %gravity
%m= 1; %kg
L = 1; %static length
Kf=10000; % floor constant
damp = 0.999; %0.9999
mu = 0.5;
kbc = [5000,2,0];
kbc0 = [0,0,0];
unitCube = lattice(2);
multiCubeSize = 4;
verteces = L*lattice(multiCubeSize);
cubeCenters = lattice(multiCubeSize-1);
nCube = size(cubeCenters,1);
offSet = [0 0 1];
nMass = size(verteces,1); %number of mass
P0 = ones(nMass,1)*offSet+verteces;
m = Mass.empty;
for i=1:nMass
    m(i) = Mass(P0(i,:));
    m(i).index = i;
end

%index of vertix masses of cube
c = zeros(nCube,8);
for i =1:nCube
    for j = 1:8
        c(i,j) = mLoc(unitCube(j,:)+cubeCenters(i,:),multiCubeSize);
    end
end

sp = Spring.empty;

%makeCube

%for i=1:nCube
%    [sp,m] = makeCube(sp,m,c(i,:),kbc);
%end
[sp,m] = makeCube(sp,m,c(2,:),kbc);

%add cube at 1 0 0
%[sp(19),m(8),m(9)] = connectSpring(19,m(8),m(9),kbc);




nSpr = length(sp);
%%
%centroid = 
P = zeros(nMass,3,iteration);


for k=1:iteration %iteration
    for i = 1:nMass
        m(i) = m(i).resetF();
        m(i) = m(i).addFloorForce(Kf,mu);
    end
    
    for i = 1:nSpr
        sp(i) = sp(i).updateL(T);
    end
    
    for i = 1:nMass
        for j = 1:size(m(i).spIndex,1)
            m(i) = m(i).addSpringForce(sp(m(i).spIndex(j,1)).sprF(m(i).spIndex(j,2)));
        end
    end
    %m(1) = m(1).addSpringForce(sp12.sprF(1));
    
    for i = 1:nMass
        m(i) = m(i).updateStatus(dt);
    end
    
    for i = 1:nSpr
    sp(i) = sp(i).updateVertex(m(sp(i).m1index),m(sp(i).m2index));
    end
    
    
    for i = 1:nMass
        P(i,:,k) = m(i).P;
    end
    
    %sp12.sprF(1)
    %m1.Fr
    T = T+dt;
    if rem(k,10)==0
        k
    end
end

%figure(1000000)
%time = [0:dt:Titv-dt];
%hold on
%plot(time,m1P(:,1));
%plot(time,m1P(:,2));
%plot(time,m1P(:,3));
%legend('x','y','z');

%% animation
iteration = Titv/dt;

%[speed_Ptot,Ptot] = evaluate(genoPop(:,:,1),Titv);

fps = 10
v = VideoWriter('test.avi');
v.FrameRate = fps;
open(v);


df = 1/fps/dt;
for f = 1:df:iteration
    fig = figure('visible','off');
    %view(20,20);
    %plot3(P(:,1,f),P(:,2,f),P(:,3,f),'b.');%plot mass
    %hold on
    %for i = 1:nSpr
    %    plot3Spring(P,f,sp(i));%plot spring
    %end
    plotCube(P,f,sp)
    
    axis equal
    scl = 6;
    xlim([-scl scl])
    ylim([-scl scl])
    zlim([-0 scl])
    floor = fill3([-scl scl scl -scl],[-scl -scl scl scl],[0 0 0 0],'b','LineStyle','none');
    floor.FaceAlpha = 0.3;
    grid on
    frame = getframe;
    writeVideo(v,frame);
    f
end

close(v);