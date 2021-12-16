clear all;
close all;
clc;

%% load homework data
EAspeed = importdata('totPopSpeed pop20iter300.txt');
%%
%plot
k=[1:size(EAspeed,2)]';

figure(2)
pop = size(EAspeed);
pop = pop(1);
plot(k,EAspeed(1,:),'b');
hold on
for i = 1:pop
    plot(k,EAspeed(i,:),'k.');
end
title('Dot Plot of GA')
xlabel('Iteration')
ylabel('Average Speed on x Direction')

%diversity = EAspeed(1,:)-EAspeed(end,:);
diversity = std(EAspeed);
figure(3)
plot(k,diversity);
title('Diversity Plot of GA')
xlabel('Iteration')
ylabel('Standard Deviation of Population')

