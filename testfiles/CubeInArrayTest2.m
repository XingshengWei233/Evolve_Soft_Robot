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
    [sp(i-1),m(1),m(i)] = connectSpring(i-1,m(1),m(i),kbc);
end
[sp(7),m(2),m(4)] = connectSpring(7,m(2),m(4),kbc);
[sp(8),m(2),m(6)] = connectSpring(8,m(2),m(6),kbc);
[sp(9),m(3),m(4)] = connectSpring(9,m(3),m(4),kbc);
[sp(10),m(3),m(7)] = connectSpring(10,m(3),m(7),kbc);
[sp(11),m(4),m(6)] = connectSpring(11,m(4),m(6),kbc);
[sp(12),m(4),m(7)] = connectSpring(12,m(4),m(7),kbc);
[sp(13),m(4),m(8)] = connectSpring(13,m(4),m(8),kbc);
[sp(14),m(5),m(6)] = connectSpring(14,m(5),m(6),kbc);
[sp(15),m(5),m(7)] = connectSpring(15,m(5),m(7),kbc);
[sp(16),m(6),m(7)] = connectSpring(16,m(6),m(7),kbc);
[sp(17),m(6),m(8)] = connectSpring(17,m(6),m(8),kbc);
[sp(18),m(7),m(8)] = connectSpring(18,m(7),m(8),kbc);

nSpr = length(sp);

%centroid = 
P = zeros(nMass,3,iteration);

for i = 1:nMass
    m(i)
end

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