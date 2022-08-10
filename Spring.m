classdef Spring
    %SPRING that can be connected to masses with dynamics

    
    properties (Constant)
        a = 0.1 %breathing altitude
        k = 5000 %spring constant
    end
    

    properties 
        vertex1 % instance vertex position 1
        vertex2 % instance vertex position 2
        L % instance rest length 
        L0 % rest length with no breath
        m1index % index of connected mass 1
        m2index % index of connected mass 2
        index
        b
    end
    
    
    methods
        function obj = Spring(Mass1, Mass2, b)
            %SPRING Construct an instance of this class
            obj.m1index = Mass1.index;
            obj.m2index = Mass2.index;
            obj.vertex1 = Mass1.P;
            obj.vertex2 = Mass2.P;
            obj.L = norm(Mass1.P-Mass2.P);
            obj.L0 = norm(Mass1.P-Mass2.P);
            obj.b = b * 2;
        end
        

        function obj = updateVertex(obj, Mass1, Mass2)
            obj.vertex1 = Mass1.P;
            obj.vertex2 = Mass2.P;
        end
        

        function obj = updateL(obj, T)
            obj.L = obj.L0 + obj.a * sin(obj.b * T);
        end
        

        function F = sprF(obj,whichMass)
            F1 = obj.k * (norm(obj.vertex1 - obj.vertex2) - obj.L) * ...
                (obj.vertex2 - obj.vertex1) / norm(obj.vertex2 - obj.vertex1);
            F2 = -F1;
            if whichMass == 1
                F = F1;
            end
            if whichMass == 2
                F = F2;
            end
        end
    end
end

