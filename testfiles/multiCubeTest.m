clear all;
close all;
clc;

tPara = tic;

Titv = 0.001;%total time interval in sec 10
dt=0.001;
T = 0; %global time
iteration = Titv/dt;
multiCubeSize = 6;

L = 1; %static unit cube length
Kf=10000; % floor constant
mu = 0.5; %floor friction

kbc = [5000,0,0;5000,4,0];%cube not breath %cube breath

tParameter = toc(tPara)


tlattice = tic;

unitCube = lattice(2);%define the verteces of a unit cube

verteces = L*lattice(multiCubeSize);%define the lattice of mass
cubeCenters = lattice(multiCubeSize-1);%define the lattice of cube centers
nCube = size(cubeCenters,1);
offSet = [0 0 0.1];
nMass = size(verteces,1); %number of mass
P0 = ones(nMass,1)*offSet+verteces;
tLattice = toc(tlattice)


tmass = tic;
m = Mass.empty;
for i=1:nMass %generate masses
    m(i) = Mass(P0(i,:));
    m(i).index = i;
end
tMass = toc(tmass)


geno = randi(3,1,nCube)-1; %generate random genotype


tcube = tic;
%index of vertix masses of each unit cube
c = zeros(nCube,8);
for i =1:nCube
    for j = 1:8
        c(i,j) = mLoc(unitCube(j,:)+cubeCenters(i,:),multiCubeSize);
    end
end
tCube = toc(tcube)

%connect springs to makeCube
disp('spring')
tic
sp = Spring.empty;
for i=1:nCube
    if geno(i)>0
        [sp,m] = makeCube(sp,m,c(i,:),kbc(geno(i),:));
    end
end
nSpr = length(sp);
toc

disp('reset mass')
tic
%reset mass and force for masses with 0 mass
for i=1:nMass
    if isempty(m(i).spIndex)
        m(i).mass = 0;
        m(i).resetF();
    end
end
toc

disp('centroid0')
tic
centroid0 = zeros(1,3);
for i=1:nMass
    if m(i).mass == 1
        centroid0 = centroid0+m(i).P;
    end
end
centroid0 = centroid0/nMass;

toc


P = zeros(nMass,3,iteration);%record position of all masses
for k=1:iteration %iteration
    disp('resetF on mass,floor force')
    tic
    for i = 1:nMass
        m(i) = m(i).resetF();
        m(i) = m(i).addFloorForce(Kf,mu);
    end
    toc
    
    disp('spring breath')
    tic
    for i = 1:nSpr
        sp(i) = sp(i).updateL(T);%breath
    end
    toc
    
    disp('addSpringForce')
    tic
    for i = 1:nMass
        for j = 1:size(m(i).spIndex,1)
            m(i) = m(i).addSpringForce(sp(m(i).spIndex(j,1)).sprF(m(i).spIndex(j,2)));
        end
    end
    toc
    
    disp('update m status')
    tic
    for i = 1:nMass
        m(i) = m(i).updateStatus(dt);
    end
    toc
    
    disp('update spring vertex?')
    tic
    for i = 1:nSpr
    sp(i) = sp(i).updateVertex(m(sp(i).m1index),m(sp(i).m2index));
    end
    toc
    
    disp('record mass position')
    tic
    for i = 1:nMass %record mass positions
        P(i,:,k) = m(i).P;
    end
    toc
    %sp12.sprF(1)
    %m1.Fr
    disp('timing and display')
    tic
    T = T+dt;
    if rem(k,100)==0
        k
    end
    toc
end

%calculate final centroid
disp('calculate final centroid and speed')
tic
centroidf = zeros(1,3);
for i=1:nMass
    if m(i).mass == 1
        centroidf = centroidf+m(i).P;
    end
end
centroidf = centroidf/nMass;

Vx = (centroidf(1) - centroid0(1))/Titv;
toc

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
    scl = 7;
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