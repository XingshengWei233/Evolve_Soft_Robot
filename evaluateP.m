function [Vx,P,m,sp,c] = evaluateP(geno,multiCubeSize,Titv,dt)
tic
%Titv = 10;%total time interval in sec 10
%dt=0.005;
T = 0; %global time
iteration = Titv/dt;
%multiCubeSize = 5;

L = 1; %static unit cube length
Kf=10000; % floor constant
mu = 0.5; %floor friction
b = [0;4];%cube not breath %cube breath

unitCube = lattice(2);%define the verteces of a unit cube

verteces = L*lattice(multiCubeSize);%define the lattice of mass
cubeCenters = lattice(multiCubeSize-1);%define the lattice of cube centers
nCube = size(cubeCenters,1);
offSet = [0 0 0.1];
offSet = [0 0 1];
nMass = size(verteces,1); %number of mass
P0 = ones(nMass,1)*offSet+verteces;

m = Mass.empty;
for i=1:nMass %generate masses
    m(i) = Mass(P0(i,:));
    m(i).index = i;
end

%geno = randi(3,1,nCube)-1; %generate random genotype

%index of vertix masses of each unit cube
c = zeros(nCube,8);
for i =1:nCube
    for j = 1:8
        c(i,j) = mLoc(unitCube(j,:)+cubeCenters(i,:),multiCubeSize);
    end
end

%connect springs to makeCube

sp = Spring.empty;
for i=1:nCube
    if geno(i)~=0
        [sp,m] = makeCube(sp,m,c(i,:),b(geno(i)));
    end
end
nSpr = length(sp);

%reset mass and force for masses with 0 mass
for i=1:nMass
    if isempty(m(i).spIndex)
        m(i).mass = 0;
        m(i).resetF();
    end
end

centroid0 = zeros(1,3);
for i=1:nMass
    if m(i).mass == 1
        centroid0 = centroid0+m(i).P;
    end
end
centroid0 = centroid0/nMass;
P = zeros(nMass,3,iteration);%record position of all masses
for k=1:iteration %iteration
    for i = 1:nMass
        m(i) = m(i).resetF();
        m(i) = m(i).addFloorForce(Kf,mu);
    end
    
    for i = 1:nSpr
        if sp(i).b~=0
            sp(i) = sp(i).updateL(T);%breath
        end
    end
    
    for i = 1:nMass
        for j = 1:size(m(i).spIndex,1)
            m(i) = m(i).addSpringForce(sp(m(i).spIndex(j,1)).sprF(m(i).spIndex(j,2)));
        end
    end
    
    for i = 1:nMass
        m(i) = m(i).updateStatus(dt);
    end
    
    for i = 1:nSpr
    sp(i) = sp(i).updateVertex(m(sp(i).m1index),m(sp(i).m2index));
    end
    
    for i = 1:nMass %record mass positions
        P(i,:,k) = m(i).P;
    end
    %sp12.sprF(1)
    T = T+dt;
    if rem(k,100)==0
        T
    end
end

%calculate final centroid
centroidf = zeros(1,3);
for i=1:nMass
    if m(i).mass == 1
        centroidf = centroidf+m(i).P;
    end
end
centroidf = centroidf/nMass;

Vx = (centroidf(1) - centroid0(1))/Titv;
toc
end