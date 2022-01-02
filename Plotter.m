clear all;
close all;
clc;

%% load homework data
EAspeed1 = importdata('totPopSpeed 50-500.txt');
EAspeed2 = importdata('totPopSpeedC50-300.txt');
EAspeed3 = importdata('totPopSpeedC 50-200.txt');
EAspeed = [EAspeed1;EAspeed2;EAspeed3]';
%%
%plot
k=[1:size(EAspeed,2)]';

figure(1)
pop = size(EAspeed);
pop = pop(1);
plot(k,EAspeed(1,:));
title('Convergence Curve')
xlabel('Iteration')
ylabel('Average Velocity on x Direction')

figure(2)
plot(k,EAspeed(1,:),'b');
hold on
for i = 1:pop
    plot(k,EAspeed(i,:),'k.');
end
title('Dot Plot of Population')
xlabel('Iteration')
ylabel('Average Velocity on x Direction')

%diversity = EAspeed(1,:)-EAspeed(end,:);
diversity = std(EAspeed);
figure(3)
plot(k,diversity);
title('Diversity Plot of GA')
xlabel('Iteration')
ylabel('Standard Deviation of Population Velocity')

