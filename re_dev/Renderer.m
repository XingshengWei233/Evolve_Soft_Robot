classdef Renderer
    %RENDERER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sim
        dt
    end
    
    methods
        function obj = Renderer(sim)
            %RENDERER Construct an instance of this class
            %   Detailed explanation goes here
            obj.sim = sim;
            obj.dt = sim.dt;

        end
        
        function obj = renderFloor(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            X = [20 20 -20 -20];
            Y = [20 -20 -20 20];
            Z = [0 0 0 0];
            floor = fill3(X,Y,Z,'b','LineStyle','none');
            floor.FaceAlpha = 0.3;
            
            hold on;
        end

        function obj = renderSpring(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            nSpring = length(obj.sim.robot.springs);
            for i = 1:nSpring
                coord = [obj.sim.robot.springs(i).vertex1; obj.sim.robot.springs(i).vertex2];
                X = coord(:, 1);
                Y = coord(:, 2);
                Z = coord(:, 3);
                plot3(X, Y, Z, 'r');
                hold on;
            end
        end

        function obj = renderMass(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            for i = 1:obj.sim.robot.sideLength + 1
                for j = 1:obj.sim.robot.sideLength + 1
                    for k = 1:obj.sim.robot.sideLength + 1

                        X = obj.sim.robot.masses(i, j, k).P(1);
                        Y = obj.sim.robot.masses(i, j, k).P(2);
                        Z = obj.sim.robot.masses(i, j, k).P(3);
                        plot3(X, Y, Z, 'bo');
                        hold on;
                    end
                end
            end
        end

        function obj = renderCube(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end

        function obj = renderFrame(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            obj = obj.renderFloor();
            axis equal
            scl = 8;
            xlim([-1 2*scl-1])
            ylim([-scl scl])
            zlim([-0 scl])
            grid on
            obj = obj.renderMass();
            obj = obj.renderSpring();
        end

        function obj = video(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fps = 25;
            v = VideoWriter('test.avi');
            v.FrameRate = fps;
            open(v);
            maxSteps = 1000;
            
            gap = 1/fps/obj.dt;

            for i = 1:maxSteps
                obj.sim = obj.sim.step();
                if rem(i, gap) == 0
                    disp(i)
                    fig = figure('visible','off');
                    %fig = figure('visible','off','Position',[0 0 1920 1080]);
                    
                    obj = obj.renderFrame();
                    frame = getframe;
                    writeVideo(v,frame);
                end

            end
%             for f = 1:df:iteration
%                 fig = figure('visible','off');
%                 %fig = figure('visible','off','Position',[0 0 1920 1080]);
%                 
%                 obj = obj.renderFrame();
%                 frame = getframe;
%                 writeVideo(v,frame);
%             end
            
            close(v);
            disp('Video saved!')
        end

        function obj = close(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end

    end
end
