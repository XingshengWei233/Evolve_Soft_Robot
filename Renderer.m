classdef Renderer
    %RENDERER Render soft robot to images and videos
    

    properties
        sim
        dt
        genome
    end
    

    methods
        function obj = Renderer(sim)
            %RENDERER Construct an instance of this class
            obj.sim = sim;
            obj.dt = sim.dt;
            obj.genome = sim.genome;
        end
        

        function obj = renderFloor(obj)
            X = [20 20 -20 -20];
            Y = [20 -20 -20 20];
            Z = [0 0 0 0];
            floor = fill3(X, Y, Z, 'b', 'LineStyle', 'none');
            floor.FaceAlpha = 0.3;            
            hold on;
        end


        function obj = renderSpring(obj)
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


        function obj = renderCube(obj, i, j, k)
            %   Render faces of a unit cube
            if obj.genome(i, j, k) ~=0 % no render
                if obj.genome(i, j, k) == 1 %render green
                    color = 'g';
                elseif obj.genome(i, j, k) == 2 %render yellow
                    color = 'y';
                end
                verticesP = [obj.sim.robot.masses(i, j, k).P; obj.sim.robot.masses(i+1, j, k).P; ...
                    obj.sim.robot.masses(i+1, j, k+1).P; obj.sim.robot.masses(i, j, k+1).P];
                fill3(verticesP(:, 1), verticesP(:, 2), verticesP(:, 3), color)
                verticesP = [obj.sim.robot.masses(i, j, k).P; obj.sim.robot.masses(i+1, j, k).P; ...
                    obj.sim.robot.masses(i+1, j+1, k).P; obj.sim.robot.masses(i, j+1, k).P];
                fill3(verticesP(:, 1), verticesP(:, 2), verticesP(:, 3), color)
                verticesP = [obj.sim.robot.masses(i, j, k).P; obj.sim.robot.masses(i, j+1, k).P; ...
                    obj.sim.robot.masses(i, j+1, k+1).P; obj.sim.robot.masses(i, j, k+1).P];
                fill3(verticesP(:, 1), verticesP(:, 2), verticesP(:, 3), color)
                verticesP = [obj.sim.robot.masses(i+1, j+1, k).P; obj.sim.robot.masses(i+1, j, k).P; ...
                    obj.sim.robot.masses(i+1, j, k+1).P; obj.sim.robot.masses(i+1, j+1, k+1).P];
                fill3(verticesP(:, 1), verticesP(:, 2), verticesP(:, 3), color)
                verticesP = [obj.sim.robot.masses(i+1, j+1, k).P; obj.sim.robot.masses(i, j+1, k).P; ...
                    obj.sim.robot.masses(i, j+1, k+1).P; obj.sim.robot.masses(i+1, j+1, k+1).P];
                fill3(verticesP(:, 1), verticesP(:, 2), verticesP(:, 3), color)
                verticesP = [obj.sim.robot.masses(i, j+1, k+1).P; obj.sim.robot.masses(i, j, k+1).P; ...
                    obj.sim.robot.masses(i+1, j, k+1).P; obj.sim.robot.masses(i+1, j+1, k+1).P];
                fill3(verticesP(:, 1), verticesP(:, 2), verticesP(:, 3), color)
            end
        end


        function obj = renderSkin(obj)
            %   Render all faces
            for i = 1:obj.sim.robot.sideLength
                for j = 1:obj.sim.robot.sideLength
                    for k = 1:obj.sim.robot.sideLength
                        obj = obj.renderCube(i, j, k);
                    end
                end
            end
        end


        function obj = renderFrame(obj)
            %   Render a frame image of current robot status
            obj = obj.renderFloor();
            axis equal
            scl = 8;
            xlim([-1 2*scl-1])
            ylim([-scl scl])
            zlim([-0 scl])
            grid on
            obj = obj.renderSkin();
            obj = obj.renderSpring();
        end


        function obj = video(obj)
            %   Write a video of episode to file
            fps = 25;
            v = VideoWriter('video_output/test.avi');
            v.FrameRate = fps;
            open(v);
            maxSteps = obj.sim.maxSteps;           
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
            close(v);
            disp('Video saved!')
        end
    end
end

