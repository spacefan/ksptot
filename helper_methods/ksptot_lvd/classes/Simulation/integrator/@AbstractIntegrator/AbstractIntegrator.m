classdef(Abstract) AbstractIntegrator < matlab.mixin.SetGet & matlab.mixin.Heterogeneous
    %AbstractIntegrator Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        [t,y,te,ye,ie] = integrate(obj, odefun, tspan, y0, evtsFunc, odeOutputFun)
        
        options = getOptions(obj)
    end
end