classdef SideSlipAngleConstraint < AbstractConstraint
    %SideSlipAngleConstraint Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        normFact = 1;
        event(1,:) LaunchVehicleEvent
        
        lb(1,1) double = 0;
        ub(1,1) double = 0;
    end
    
    methods
        function obj = SideSlipAngleConstraint(event, lb, ub)
            obj.event = event;
            obj.lb = lb;
            obj.ub = ub;   
            
             obj.id = rand();
        end
        
        function [lb, ub] = getBounds(obj)
            lb = obj.lb;
            ub = obj.ub;
        end
        
        function [c, ceq, value, lwrBnd, uprBnd, type, eventNum] = evalConstraint(obj, stateLog, celBodyData)           
            type = obj.getConstraintType();
            stateLogEntry = stateLog.getLastStateLogForEvent(obj.event);
            
            ut = stateLogEntry.time;
            rVect = stateLogEntry.position;
            vVect = stateLogEntry.velocity;
            bodyInfo = stateLogEntry.centralBody;
            
            [bankAng,angOfAttack,angOfSideslip] = stateLogEntry.attitude.getAeroAngles(ut, rVect, vVect, bodyInfo);
            
            value = rad2deg(angOfSideslip);
                       
            if(obj.lb == obj.ub)
                c = [];
                ceq(1) = value - obj.ub;
            else
                c(1) = obj.lb - value;
                c(2) = value - obj.ub;
                ceq = [];
            end
            c = c/obj.normFact;
            ceq = ceq/obj.normFact;  
            
            lwrBnd = obj.lb;
            uprBnd = obj.ub;
            
            eventNum = obj.event.getEventNum();
        end
        
        function sF = getScaleFactor(obj)
            sF = obj.normFact;
        end
        
        function setScaleFactor(obj, sF)
            obj.normFact = sF;
        end
        
        function tf = usesStage(obj, stage)
            tf = false;
        end
        
        function tf = usesEngine(obj, engine)
            tf = false;
        end
        
        function tf = usesTank(obj, tank)
            tf = false;
        end
        
        function tf = usesEngineToTankConn(obj, engineToTank)
            tf = false;
        end
        
        function tf = usesEvent(obj, event)
            tf = obj.event == event;
        end
        
        function type = getConstraintType(obj)
            type = 'Side Slip Angle';
        end
        
        function name = getName(obj)
            name = sprintf('%s - Event %i', obj.getConstraintType(), obj.event.getEventNum());
        end
        
        function [unit, lbLim, ubLim, usesLbUb, usesCelBody, usesRefSc] = getConstraintStaticDetails(obj)
            unit = 'deg';
            lbLim = -360;
            ubLim = 360;
            usesLbUb = true;
            usesCelBody = false;
            usesRefSc = false;
        end
        
        function addConstraintTf = openEditConstraintUI(obj, lvdData)
            addConstraintTf = lvd_EditGenericMAConstraintGUI(obj, lvdData);
        end
    end
    
    methods(Static)
        function constraint = getDefaultConstraint(~)            
            constraint = SideSlipAngleConstraint(LaunchVehicleEvent.empty(1,0),0,0);
        end
    end
end