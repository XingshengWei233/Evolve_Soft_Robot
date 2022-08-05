classdef Spring
    %SPRING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        a = 0.1 %breathing altitude
        k = 5000
    end
    
    properties 
        vertex1
        vertex2
        L %rest length
        L0 %rest length with no breath
        m1Index
        m2Index
        index
        type
        b
    end
    
    
    methods
        function obj = Spring(Mass1,Mass2,b)
            %SPRING Construct an instance of this class
            %   Detailed explanation goes here
            obj.m1Index = Mass1.index;
            obj.m2Index = Mass2.index;
            obj.vertex1 = Mass1.P;
            obj.vertex2 = Mass2.P;
            obj.L = norm(Mass1.P-Mass2.P);
            obj.L0 = norm(Mass1.P-Mass2.P);
            obj.b = b;
        end
        
        function obj = updateVertex(obj,Mass1,Mass2)
            obj.vertex1 = Mass1.P;
            obj.vertex2 = Mass2.P;
        end
        
        function obj = updateL(obj,T)
            obj.L = obj.L0 + obj.a*sin(obj.b*T);
        end
        
        function F = sprF(obj,whichMass)
            F1 = obj.k*(norm(obj.vertex1-obj.vertex2)-obj.L)*(obj.vertex2-obj.vertex1)/norm(obj.vertex2-obj.vertex1);
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

