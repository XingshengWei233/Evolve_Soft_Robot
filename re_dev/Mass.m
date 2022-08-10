classdef Mass
    %MASS that can be connected to spring with dynamics


    properties 
        mass;
        P; % position
        g; % gravitational acceleration
        Fr;% force recieved
        A;% acceleration
        V;% velocity
        damp;% viscous friction coefficient
        index;
        spIndex;% index of connected springs
        mConnectedIndex;% index of connected masses
    end
    

    methods
        function obj = Mass(index, damp, g)
            obj.index = [index(1), index(2), index(3)];
            obj.mass = 0;
            obj.g = g;     
            obj.V = [0 0 0];
            obj.A = obj.Fr * obj.mass;
            obj.damp = damp;
            obj.mConnectedIndex = zeros(0, 3);
            obj.spIndex = zeros(0, 2);
        end
        

        function obj = addForce(obj,F)
            obj.Fr = obj.Fr+F;
        end
        

        function obj = addFloorForce(obj, Kf, mu)
            if obj.P(3)<0
                obj.Fr(3) = obj.Fr(3) - obj.P(3) * Kf;
                fricDir = -obj.V(1:2)/norm(obj.V(1:2));%unit vector of friction direction
                fricMag = mu * obj.Fr(3);
                fric = fricDir * fricMag;
                obj.Fr(1:2) = obj.Fr(1:2) + fric;
            end
        end
        

        function obj = resetF(obj)
            obj.Fr = obj.g * obj.mass;
        end
        

        function obj = addSpringForce(obj,F)
            obj.Fr = obj.Fr + F;
        end
        

        function obj = updateStatus(obj,dt)
            obj.A = obj.Fr * obj.mass;
            obj.V = obj.V + obj.A * dt * obj.damp;
            obj.P = obj.P + obj.V*dt;
        end
        

        function obj = addSpring(obj,newSpIndex)
            obj.spIndex = [obj.spIndex; newSpIndex];
        end
    end
end

