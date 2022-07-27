classdef Simulation
    %SIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        genome
        dt
        unitL
        size
        masses
        springs
        mu
        damp
        gravity
    end
    
    methods
        function obj = Simulation(genome, dt=0.01, unitL=1)
            %SIMULATION Construct an instance of this class
            %   Detailed explanation goes here
            obj.genome = genome;
            obj.size = genome.size();
            obj.dt = dt;
            obj.masses = obj.generateMasses();
            obj.springs = obj.generateSprings();
            
        end
        
        function masses = generateMasses(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            masses = obj.Property1 + inputArg;
        end
        
        function springs = generateSprings(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            springs = obj.Property1 + inputArg;
        end
        
        function outputArg = step(obj,inputArg)
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

