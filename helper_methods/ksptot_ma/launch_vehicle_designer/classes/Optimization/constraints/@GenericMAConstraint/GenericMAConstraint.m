classdef GenericMAConstraint < AbstractConstraint
    %GenericMAConstraint Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        constraintType(1,:) char = '';
        normFact = 1;
        event(1,1) LaunchVehicleEvent = LaunchVehicleEvent(LaunchVehicleScript())
        
        lb(1,1) double = 0;
        ub(1,1) double = 0;
        
        refStation(1,1) struct
        refOtherSC(1,1) struct
        refBodyInfo(1,1) KSPTOT_BodyInfo
    end
    
    methods
        function obj = GenericMAConstraint(constraintType, event, lb, ub, refStation, refOtherSC, refBodyInfo)
            obj.constraintType = constraintType;
            obj.event = event;
            obj.lb = lb;
            obj.ub = ub;
            obj.refStation = refStation;
            obj.refOtherSC = refOtherSC;
            obj.refBodyInfo = refBodyInfo;
        end
        
        function [c, ceq, value, lwrBnd, uprBnd, type, eventNum] = evalConstraint(obj, stateLog, celBodyData)
            stateLogEntry = stateLog.getLastStateLogForEvent(obj.event).getMAFormattedStateLogMatrix();
            
            type = obj.constraintType;
            switch type
                case {'ut'}
                    value = ma_TimeTask(stateLogEntry, type, celBodyData);
                case {'rX','rY','rZ','vX','vY','vZ','rNorm','vNorm'}
                    value = ma_GAVectorElementsTask(stateLogEntry, type, celBodyData);
                case {'sma','ecc','inc','raan','arg','tru','mean','period','sunRX','sunRY','sunRZ','rPe','rAp','altPe','altAp','betaAngle'}
                    value = ma_GAKeplerElementsTask(stateLogEntry, type, celBodyData);
                case {'Elevation'}
                    value = ma_GAAzElRangeTasks(stateLogEntry, type, obj.refStation, celBodyData);
                case {'CB_ID'}
                    value = ma_GACentralBodyTasks(stateLogEntry, type, celBodyData);
                case {'distToCelBody'}
                    value = ma_GADistToCelBodyTask(stateLogEntry, type, obj.refBodyInfo, celBodyData);
                case {'distToRefSC','relVelToCelBody','relPositionInTrack','relPositionCrossTrack','relPositionRadial','relPositionInTrackOScCentered','relPositionCrossTrackOScCentered','relPositionRadialOScCentered','relSma','relEcc','relInc','relRaan','relArg'}
                    value = ma_GADistToRefSCTask(stateLogEntry, type, obj.refOtherSC, celBodyData);
                case {'distToRefStn'}
                    value = ma_GADistToRefStationTask(stateLogEntry, type, obj.refStation, celBodyData);
                case {'Eclipse','OtherSC_LOS','Station_LOS'}
                    value = ma_GAEclipseTask(stateLogEntry, type, obj.refOtherSC, obj.refStation, celBodyData);
                case {'H1','K1','H2','K2'}
                    value = ma_GAEquinoctialElementsTask(stateLogEntry, type, celBodyData);
                case {'long','lat','driftRate','horzVel','vertVel'}
                    value = ma_GALongLatAltTasks(stateLogEntry, type, celBodyData);
                case {'fuelOx','monoprop','xenon','dry','total'}
                    value = ma_GASpacecraftMassTasks(stateLogEntry, type, celBodyData);
                case {'X','Y','Z','mag','RA','Dec'}
                    value = ma_OutboundHyperVelVectTask(stateLogEntry, type, celBodyData);
            end
            
            if(obj.lb == obj.ub)
                c = [0 0];
                ceq(1) = value - obj.ub;
            else
                c(1) = obj.lb - value;
                c(2) = value - obj.ub;
                ceq = [0]; %#ok<NBRAK>
            end
            c = c/stateLog.normFact;
            ceq = ceq/stateLog.normFact;  
            
            lwrBnd = obj.lb;
            uprBnd = obj.ub;
            
            eventNum = obj.event.getEventNum();
        end
    end
end