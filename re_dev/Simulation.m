classdef Simulation
    %SIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        genome
        dt
        unitL
        sideLength
        masses
        springs
        mu
        damp
        gravity
        startPos
    end
    
    methods
        function obj = Simulation(genome)
            %SIMULATION Construct an instance of this class
            %   Detailed explanation goes here
            obj.genome = genome;
            obj.sideLength = size(genome, 1);
            obj.dt = 0.01;
            obj.unitL = 1;
            obj.startPos = [0,0,0];
            obj.masses = obj.generateMasses();
            obj.springs = Spring.empty(0);
            obj = obj.generateSprings();
            
        end
        
        function masses = unitCubeAddMass(obj, masses, i, j, k)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            for a = 0:1
                for b = 0:1
                    for c = 0:1
                        masses(i+a, j+b, k+c).mass = 1;
                    end
                end
            end
        end
        
        function masses = generateMasses(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            masses = Mass.empty(0);
            for k = 1 : obj.sideLength + 1
                for j = 1 : obj.sideLength + 1
                    for i = 1 : obj.sideLength + 1
                        masses(end + 1) = Mass([i j k]);
                        masses(end).index = [i j k];
                    end
                end
            end
            masses = reshape(masses, obj.sideLength + 1, obj.sideLength + 1, obj.sideLength + 1);
            for i = 1 : obj.sideLength
                for j = 1 : obj.sideLength
                    for k = 1 : obj.sideLength
                        if obj.genome(i, j, k) ~= 0
                            masses = obj.unitCubeAddMass(masses, i, j, k);
                        end
                    end
                end
            end
        end
        
        function obj = connect(obj, massIndex1, massIndex2, b)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            i1 = massIndex1(1); j1 = massIndex1(2); k1 = massIndex1(3);
            i2 = massIndex2(1); j2 = massIndex2(2); k2 = massIndex2(3);
            connected = false;
            if ~isempty(obj.masses(i1, j1, k1).mConnectedIndex)
                for i = 1 : size(obj.masses(i1, j1, k1).mConnectedIndex, 1)
                    if obj.masses(i1, j1, k1).mConnectedIndex(i, :) == obj.masses(i2, j2, k2).index
                        connected = true;
                        spIndex = obj.masses(i1, j1, k1).spIndex(i);
                        obj.springs(spIndex).b = min(obj.springs(spIndex).b, b);
                    end
                end
            end
            if connected == false
                obj.springs(end + 1) = Spring(obj.masses(i1, j1, k1), obj.masses(i2, j2, k2), b);
                obj.springs(end).index = length(obj.springs);
                obj.masses(i1, j1, k1).mConnectedIndex(end + 1, :) = obj.masses(i2, j2, k2).index;
                obj.masses(i1, j1, k1).spIndex(end + 1) = obj.springs(end).index;
                obj.masses(i2, j2, k2).mConnectedIndex(end + 1, :) = obj.masses(i1, j1, k1).index;
                obj.masses(i2, j2, k2).spIndex(end + 1) = obj.springs(end).index;
            end
        end
        
        function obj = unitCubeAddSpring(obj, i, j, k)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            unitType = obj.genome(i, j, k);
            b = unitType - 1;
            obj = obj.connect([i, j, k], [i+1, j, k], b);
            obj = obj.connect([i, j, k], [i, j+1, k], b);
            obj = obj.connect([i, j, k], [i, j, k+1], b);
            obj = obj.connect([i, j, k], [i+1, j+1, k], b);
            obj = obj.connect([i, j, k], [i, j+1, k+1], b);
            obj = obj.connect([i, j, k], [i+1, j, k+1], b);
            
            obj = obj.connect([i+1, j+1, k], [i+1, j, k], b);
            obj = obj.connect([i+1, j+1, k], [i, j+1, k], b);
            obj = obj.connect([i+1, j+1, k], [i+1, j+1, k+1], b);
            obj = obj.connect([i+1, j+1, k], [i+1, j, k+1], b);
            obj = obj.connect([i+1, j+1, k], [i, j+1, k+1], b);
            
            obj = obj.connect([i+1, j, k+1], [i+1, j, k], b);
            obj = obj.connect([i+1, j, k+1], [i, j, k+1], b);
            obj = obj.connect([i+1, j, k+1], [i+1, j+1, k+1], b);
            obj = obj.connect([i+1, j, k+1], [i, j+1, k+1], b);
            
            obj = obj.connect([i, j+1, k+1], [i, j+1, k], b);
            obj = obj.connect([i, j+1, k+1], [i, j, k+1], b);
            obj = obj.connect([i, j+1, k+1], [i+1, j+1, k+1], b);
        end
        
        function obj = generateSprings(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.springs = Spring.empty(0);
            for i = 1 : obj.sideLength
                for j = 1 : obj.sideLength
                    for k = 1 : obj.sideLength
                        if obj.genome(i, j, k) ~= 0
                            obj = obj.unitCubeAddSpring(i, j, k);
                        end
                    end
                end
            end
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

