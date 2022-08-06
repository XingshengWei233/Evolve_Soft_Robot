classdef Simulation
    %SIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        genome
        mu
        Kf
        damp
        g
        startPos 
        dt
        maxSteps
        T
        robot
    end
    

    methods
        function obj = Simulation(genome)
            %SIMULATION Construct an instance of this class
            %   Detailed explanation goes here
            obj.genome = genome;
            obj.mu = 0.5;
            obj.Kf = 10000;
            obj.damp = 0.9;
            obj.g = [0,0,-9.81];
            obj.startPos = [0,0,1];
            obj.dt = 0.01;
            obj.maxSteps = 500; %10s
            obj.T = 0;
            obj.robot = Robot(genome, obj.mu, obj.Kf, obj.damp, obj.g, obj.startPos, obj.dt);
        end
        
        function obj = step(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.robot = obj.robot.step();
            obj.T = obj.T + obj.dt;

        end

        function outputArg = reset(obj,genome)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function speed = evaluate(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            startP = obj.robot.getCOM();
            startX = startP(1);
            for i = 1:obj.maxSteps
                obj = obj.step();
                obj.robot.masses(1,1,1).P
            end
            endP = obj.robot.getCOM();
            endX = endP(1);
            speed = (endX - startX) / obj.T;
        end
    end
end

