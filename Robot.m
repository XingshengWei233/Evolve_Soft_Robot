classdef Robot
    %ROBOT Assemble a soft robot with masses and springs, 
    %   that can execute dynamics by time steps
    

    properties
        genome
        unitL % Side length of unit cube
        sideLength % Number of unit cubes per dimension
        masses
        springs
        mu % floor friction coefficient
        Kf % stiffness of floor
        damp % viscous friction coefficient
        g % gravitational acceleration
        startPos % start position of mass(1, 1, 1)      
        dt
        T
    end
    

    methods
        function obj = Robot(genome, mu, Kf, damp, g, startPos, dt)
            %SIMULATION Construct an instance of this class
            obj.genome = genome;
            obj.unitL = 1;
            obj.sideLength = size(genome, 1);
            obj.startPos = startPos;
            obj.mu = mu;
            obj.Kf = Kf;
            obj.damp = damp;
            obj.g = g;
            obj = obj.generateMasses();
            obj.springs = Spring.empty(0);
            obj = obj.generateSprings();
            obj.dt = dt;
            obj.T = 0;
        end
        

        function obj = unitCubeAddMass(obj, i, j, k)
            %   generate springs for each unit cube
            for a = 0 : 1
                for b = 0 : 1
                    for c = 0 : 1
                        obj.masses(i+a, j+b, k+c).mass = 1;
                    end
                end
            end
        end
        

        function obj = generateMasses(obj)
            obj.masses = Mass.empty(0);
            for k = 1 : obj.sideLength + 1
                for j = 1 : obj.sideLength + 1
                    for i = 1 : obj.sideLength + 1
                        obj.masses(end + 1) = Mass([i j k], obj.damp, obj.g);
                        obj.masses(end).P = [i j k] + obj.startPos - 1;
                    end
                end
            end
            obj.masses = reshape(obj.masses, obj.sideLength + 1, obj.sideLength + 1, obj.sideLength + 1);
            for i = 1 : obj.sideLength
                for j = 1 : obj.sideLength
                    for k = 1 : obj.sideLength
                        if obj.genome(i, j, k) ~= 0
                            obj = obj.unitCubeAddMass(i, j, k);
                        end
                    end
                end
            end
        end

        
        function obj = connect(obj, massIndex1, massIndex2, b)
            %   connect 2 masses with a spring
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
                obj.springs(end).m1index = massIndex1;
                obj.springs(end).m2index = massIndex2;
                obj.masses(i1, j1, k1).mConnectedIndex(end + 1, :) = obj.masses(i2, j2, k2).index;
                obj.masses(i1, j1, k1).spIndex(end + 1, :) = [obj.springs(end).index, 1];
                obj.masses(i2, j2, k2).mConnectedIndex(end + 1, :) = obj.masses(i1, j1, k1).index;
                obj.masses(i2, j2, k2).spIndex(end + 1, :) = [obj.springs(end).index, 2];
            end
        end
        

        function obj = unitCubeAddSpring(obj, i, j, k)
            %   generate springs for each unit cube
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
        
        
        function obj = step(obj)
            %   Execute dynamics over dt to next time step

            %   step masses
            for i = 1:obj.sideLength + 1
                for j = 1:obj.sideLength + 1
                    for k = 1:obj.sideLength + 1

                        obj.masses(i,j,k) = obj.masses(i,j,k).resetF();
                        obj.masses(i,j,k) = obj.masses(i,j,k).addFloorForce(obj.Kf,obj.mu);

                        for a = 1:size(obj.masses(i,j,k).spIndex,1)
                            obj.masses(i,j,k) = obj.masses(i,j,k).addSpringForce( ...
                                obj.springs(obj.masses(i,j,k).spIndex(a,1)).sprF(obj.masses(i,j,k).spIndex(a,2)));
                        end
                        obj.masses(i,j,k) = obj.masses(i,j,k).updateStatus(obj.dt);

                    end
                end
            end
            
            % step springs
            for i = 1:length(obj.springs)
                if obj.springs(i).b~=0
                    obj.springs(i) = obj.springs(i).updateL(obj.T);%breath
                end
                i1 = obj.springs(i).m1index(1); j1 = obj.springs(i).m1index(2); k1 = obj.springs(i).m1index(3);
                i2 = obj.springs(i).m2index(1); j2 = obj.springs(i).m2index(2); k2 = obj.springs(i).m2index(3);
                obj.springs(i) = obj.springs(i).updateVertex( ...
                    obj.masses(i1,j1,k1),obj.masses(i2,j2,k2));
            end
            
            % step time
            obj.T = obj.T + obj.dt;
        end



        function COM = getCOM(obj)
            %   get center of mass
            %   return 0 if total mass = 0
            COM = [0, 0, 0];
            totalMass = 0;
            for i = 1:obj.sideLength + 1
                for j = 1:obj.sideLength + 1
                    for k = 1:obj.sideLength + 1
                        if obj.masses(i, j, k).mass ~= 0
                            COM = COM + obj.masses(i, j, k).P;
                            totalMass = totalMass + obj.masses(i, j, k).mass;
                        end
                    end
                end
            end
            if totalMass == 0
                COM = 0;
            else
                COM = COM / totalMass;
            end
        end
    end
end