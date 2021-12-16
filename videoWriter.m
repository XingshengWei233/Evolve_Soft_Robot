%% animation
clear all
close all
clc
Titv = 10;%total time interval
dt=0.005;

iteration = Titv/dt;
%geno = importdata('genoBestEA10000iter100pop.txt');
geno = importdata('genoBest pop20iter300.txt');
geno = geno(10,:);
[Vx,P,m,sp,c] = evaluateP(geno,5);
%%
fps = 25;
v = VideoWriter('final10.avi');
v.FrameRate = fps;
open(v);


df = 1/fps/dt;
for f = 1:df:iteration
    fig = figure('visible','off','Position',[0 0 1920 1080]);
    %view(20,20);
    plotCube(P,f,m,sp,c,geno)
    
    axis equal
    scl = 8;
    xlim([-1 2*scl-1])
    ylim([-scl scl])
    zlim([-0 scl])
    floor = fill3(2*[-scl scl scl -scl],2*[-scl -scl scl scl],[0 0 0 0],'b','LineStyle','none');
    floor.FaceAlpha = 0.3;
    grid on
    frame = getframe;
    writeVideo(v,frame);
    f
end

close(v);
