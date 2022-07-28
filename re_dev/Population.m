classdef Population
    %POPULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        genomes
        popSize
        sideLength
        speeds
    end
    
    methods
        function obj = Population(popSize, sideLength, nUnitCubeType)
            %POPULATION Construct an instance of this class
            %   Detailed explanation goes here
            obj.popSize = popSize;
            obj.sideLength = sideLength;
            obj.genomes = randi(nUnitCubeType, [popSize, sideLength, sideLength, sideLength]) - 1;
            %obj.speeds = obj.evaluatePop();
            disp('population generated')
        end
        
        function speeds = evaluatePop(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            speeds = zeros(obj.popSize, 1);
            parfor i = 1 : obj.popSize
                sim = Simulation(obj.genomes(i,:,:,:));
                speeds(i) = sim.evaluate();
            end
        end
        
        function sortPop(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function outputArg = insertSortSelect(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function outputArg = crossover(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function outputArg = mutation(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function log(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

