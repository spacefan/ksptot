classdef GravityForceModel < AbstractForceModel
    %GravityForceModel Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = GravityForceModel()
            
        end
        
        function forceVect = getForce(obj, stateLogEntry)
            [~, rVect, ~, mass, bodyInfo, ~] = obj.getParamsFromStateLogEntry(stateLogEntry);
            
            r = norm(rVect);
            forceVect = -((bodyInfo.gm * mass)/(r^3)) * rVect; %km^3/s^2 * mT / km^2 = km*mT/s^2
        end
    end
end