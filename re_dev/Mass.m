classdef Mass
    %MASS Summary of this class goes here
    %   Detailed explanation goes here
    properties (Constant)  
    end
    properties 
        P;
        Fr;
        mass;
        V;
        A;
        damp;
        G;
        index;
        spIndex;
        mConnectedIndex;
    end
    
    methods
        function obj = Mass(initialPosition)
            obj.P = [initialPosition(1),initialPosition(2),initialPosition(3)];
            obj.mass = 1;
            obj.G = [0,0,1]*-9.81*obj.mass;     
            obj.V = [0,0,0];
            obj.Fr = obj.G;
            obj.A = obj.Fr*obj.mass;
            obj.damp = 0.9;
            
        end
        
        function obj = addForce(obj,F)
            obj.Fr = obj.Fr+F;
        end
        
        function obj = addFloorForce(obj,Kf,mu) %add mu
            if obj.P(3)<0
                obj.Fr(3) = obj.Fr(3)-obj.P(3)*Kf;
                fricDir = -obj.V(1:2)/norm(obj.V(1:2));%unit vector of friction direction
                fricMag = mu*obj.Fr(3);
                fric = fricDir*fricMag;
                obj.Fr(1:2) = obj.Fr(1:2)+fric;
            end
        end
        
        function obj = resetF(obj)
            obj.Fr = [0,0,1]*-9.81*obj.mass;
        end
        
        function obj = addSpringForce(obj,F)
            obj.Fr = obj.Fr+F;
        end
        
        function obj = updateStatus(obj,dt)
            obj.A = obj.Fr*obj.mass;
            obj.V = obj.V+obj.A*dt*obj.damp;
            obj.P = obj.P+obj.V*dt;
        end
        
        function obj = addSpring(obj,newSpIndex)
            obj.spIndex = [obj.spIndex;newSpIndex];
        end
    end
end

