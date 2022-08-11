clear all;
close all;
clc;

Titv = 5;%total time interval in sec
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

verteces = L*[0 0 0;
              0 0 1;
              0 1 0;
              0 1 1;
              1 0 0;
              1 0 1;
              1 1 0;
              1 1 1];
offSet = [0 0 1];
nMass = size(verteces,1); %number of mass
P0 = ones(nMass,1)*offSet+verteces;
m = Mass.empty;
for i=1:8
    m(i) = Mass(P0(i,:));
    m(i).index = i;
end

sp = Spring.empty;
for i=2:7
    sp(i-1) = Spring(m(1),m(i),kbc);
end
sp(7) = Spring(m(2),m(4),kbc);
m(2) = m(2).addSpring(7);
m(4) = m(4).addSpring(7);

%sp(8) = Spring(m(2),m(6),kbc); 
[sp(8),m(2),m(6)] = connectSpring(8,m(2),m(6),kbc);
sp(9) = Spring(m(3),m(4),kbc);
sp(10) = Spring(m(3),m(7),kbc);
sp(11) = Spring(m(4),m(6),kbc);
sp(12) = Spring(m(4),m(7),kbc);
sp(13) = Spring(m(4),m(8),kbc);
sp(14) = Spring(m(5),m(6),kbc);
sp(15) = Spring(m(5),m(7),kbc);
sp(16) = Spring(m(6),m(7),kbc);
sp(17) = Spring(m(6),m(8),kbc);
sp(18) = Spring(m(7),m(8),kbc);

nSpr = length(sp);

%centroid = 
P = zeros(nMass,3,iteration);
%% 
for k=1:iteration %iteration
    for i = 1:nMass
        m(i) = m(i).resetF();
        m(i) = m(i).addFloorForce(Kf,mu);
    end
    
    for i = 1:nSpr
    sp(i) = sp(i).updateL(T);
    end
    
    m(1) = m(1).addSpringForce(sp12.sprF(1));
    m(1) = m(1).addSpringForce(sp13.sprF(1));
    m(1) = m(1).addSpringForce(sp14.sprF(1));
    m(2) = m(2).addSpringForce(sp12.sprF(2));
    m(2) = m(2).addSpringForce(sp23.sprF(1));
    m(2) = m(2).addSpringForce(sp24.sprF(1));
    m(3) = m(3).addSpringForce(sp13.sprF(2));
    m(3) = m(3).addSpringForce(sp23.sprF(2));
    m(3) = m(3).addSpringForce(sp34.sprF(1));
    m(4) = m(4).addSpringForce(sp14.sprF(2));
    m(4) = m(4).addSpringForce(sp24.sprF(2));
    m(4) = m(4).addSpringForce(sp34.sprF(2));
    
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
    plot3(m1P(f,1),m1P(f,2),m1P(f,3),'b.');
    hold on
    plot3(m2P(f,1),m2P(f,2),m2P(f,3),'b.');  
    plot3(m3P(f,1),m3P(f,2),m3P(f,3),'b.');  
    plot3(m4P(f,1),m4P(f,2),m4P(f,3),'b.');  
    
    plot3([m1P(f,1),m2P(f,1)],[m1P(f,2),m2P(f,2)],[m1P(f,3),m2P(f,3)],'r-'); 
    plot3([m1P(f,1),m3P(f,1)],[m1P(f,2),m3P(f,2)],[m1P(f,3),m3P(f,3)],'r-'); 
    plot3([m1P(f,1),m4P(f,1)],[m1P(f,2),m4P(f,2)],[m1P(f,3),m4P(f,3)],'r-'); 
    plot3([m2P(f,1),m3P(f,1)],[m2P(f,2),m3P(f,2)],[m2P(f,3),m3P(f,3)],'r-'); 
    plot3([m2P(f,1),m4P(f,1)],[m2P(f,2),m4P(f,2)],[m2P(f,3),m4P(f,3)],'r-'); 
    plot3([m3P(f,1),m4P(f,1)],[m3P(f,2),m4P(f,2)],[m3P(f,3),m4P(f,3)],'r-'); 
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