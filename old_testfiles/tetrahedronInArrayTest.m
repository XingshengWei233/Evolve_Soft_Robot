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

m1 = Mass([0 0 2]);
m2 = Mass([1 0 2]);
m3 = Mass([0.5 0.85 2]);
m4 = Mass([0.5 0.42 2.7]);

m = [m1 m2 m3 m4];
kbc = [5000,2,0];
sp12 = Spring(m1,m2,kbc);
sp13 = Spring(m1,m3,kbc);
sp14 = Spring(m1,m4,kbc);
sp23 = Spring(m2,m3,kbc);
sp24 = Spring(m2,m4,kbc);
sp34 = Spring(m3,m4,kbc);
sp = Spring.empty;

%centroid = 
m1P = zeros(iteration,3);
m2P = zeros(iteration,3);
m3P = zeros(iteration,3);
m4P = zeros(iteration,3);
for k=1:iteration %iteration
    for i = 1:4
        m(i) = m(i).resetF();
        m(i) = m(i).addFloorForce(Kf,mu);
    end
    
    
    sp12 = sp12.updateL(T);
    sp13 = sp13.updateL(T);
    sp14 = sp14.updateL(T);
    sp23 = sp23.updateL(T);
    sp24 = sp24.updateL(T);
    sp34 = sp34.updateL(T);
    
    
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
    
    for i = 1:4
        m(i) = m(i).updateStatus(dt);
    end
    sp12 = sp12.updateVertex(m(1),m(2));
    sp13 = sp13.updateVertex(m(1),m(3));
    sp14 = sp14.updateVertex(m(1),m(4));
    sp23 = sp23.updateVertex(m(2),m(3));
    sp24 = sp24.updateVertex(m(2),m(4));
    sp34 = sp34.updateVertex(m(3),m(4));
    
    
    m1P(k,:) = m(1).P;
    m2P(k,:) = m(2).P;
    m3P(k,:) = m(3).P;
    m4P(k,:) = m(4).P;
    
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