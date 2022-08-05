classdef Simulation
    %SIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        genome
        dt
        T
        unitL
        sideLength
        masses
        springs
        mu
        Kf
        damp
        gravity
        startPos
        robot
    end
    
    methods
        function obj = Simulation(genome)
            %SIMULATION Construct an instance of this class
            %   Detailed explanation goes here
            obj.genome = genome;
            obj.sideLength = size(genome, 1);
            obj.dt = 0.01;
            obj.unitL = 1;
            obj.startPos = [0,0,1];
            obj.Kf = 10000;
            obj.mu = 0.5;
            obj.robot = Robot(genome, obj.startPos, obj.Kf, obj.mu);
            obj.T = 0;
            
        end
        
        
        function obj = step(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.robot = obj.robot.step();
            obj.T = obj.T + obj.dt;

        end

        function outputArg = reset(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function speed = evaluate(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            speed = obj.Property1 + inputArg;
        end
    end
end

