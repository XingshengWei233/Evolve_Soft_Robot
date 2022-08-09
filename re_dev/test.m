close all;
clear all;

sideLen = 2;
pop = Population(5,sideLen);
genome = pop.group{1, 1};
%genome = squeeze(genome);
%robot = Robot(genome, [0,0,1]);
sim = Simulation(genome);

% masses_val = zeros(sideLen+1,sideLen+1,sideLen+1);
% for i = 1:sideLen+1
%     for j = 1:sideLen+1
%         for k = 1:sideLen+1
%             masses_val(i,j,k) = robot.masses(i,j,k).mass;
%         end
%     end
% end

%test connect
% sim = sim.connect([1,1,1], [1,1,2], 1);
% sim = sim.connect([1,1,1], [1,1,3], 1);
% sim = sim.connect([1,1,1], [1,1,2], 0);

%test unitCubeAddSpring
%sim = sim.unitCubeAddSpring(1,1,1);



mass1 = sim.robot.masses(1,1,1);
mass2 = sim.robot.masses(1,1,2);
springs = sim.robot.springs;

% for i = 1:10
%     sim = sim.step();
%     sim.robot.masses(1).P
% end
speed = sim.evaluate()
renderer = Renderer(sim);
%renderer = renderer.renderFrame();

%renderer.video();