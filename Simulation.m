classdef Simulation
    %SIMULATION Make simulation environments with default parameters
    %   can step the robot and evaluate the speed on X direction
    

    properties
        genome
        mu % floor friction coefficient
        Kf % stiffness of floor
        damp % viscous friction coefficient
        g % gravitational acceleration
        startPos % start position of mass(1, 1, 1)
        dt
        maxSteps
        T
        robot
    end
    

    methods
        function obj = Simulation(genome)
            %SIMULATION Construct an instance of this class
            obj.genome = genome;
            obj.mu = 0.5;
            obj.Kf = 10000;
            obj.damp = 0.9;
            obj.g = [0,0,-9.81];
            obj.startPos = [0,0,0.1];
            obj.dt = 0.005;
            duration = 10; % in seconds
            obj.maxSteps = duration / obj.dt; 
            obj.T = 0;
            obj.robot = Robot(genome, obj.mu, obj.Kf, obj.damp, obj.g, obj.startPos, obj.dt);
        end
        

        function obj = step(obj)
            obj.robot = obj.robot.step();
            obj.T = obj.T + obj.dt;

        end

        
        function speed = evaluate(obj)
            startP = obj.robot.getCOM();
            startX = startP(1);
            for i = 1:obj.maxSteps
                obj = obj.step();
                obj.robot.masses(1,1,1).P;
            end
            endP = obj.robot.getCOM();
            endX = endP(1);
            speed = (endX - startX) / obj.T;
        end
    end
end

