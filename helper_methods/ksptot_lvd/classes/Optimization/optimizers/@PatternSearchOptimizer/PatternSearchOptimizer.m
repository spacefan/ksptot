classdef PatternSearchOptimizer < AbstractOptimizer
    %PatternSearchOptimizer Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        options(1,1) PatternSearchOptions = PatternSearchOptions();
    end
    
    methods
        function obj = PatternSearchOptimizer()
            obj.options = PatternSearchOptions();
        end
        
        function optimize(obj, lvdOpt, writeOutput)
            [x0All, actVars, varNameStrs] = lvdOpt.vars.getTotalScaledXVector();
            [lbAll, ubAll, lbUsAll, ubUsAll] = lvdOpt.vars.getTotalScaledBndsVector();
            typicalX = lvdOpt.vars.getTypicalScaledXVector();
            
            if(isempty(x0All) && isempty(actVars))
                return;
            end
            
            evtNumToStartScriptExecAt = obj.getEvtNumToStartScriptExecAt(lvdOpt, actVars);
            evtToStartScriptExecAt = lvdOpt.lvdData.script.getEventForInd(evtNumToStartScriptExecAt);
            
            objFuncWrapper = @(x) lvdOpt.objFcn.evalObjFcn(x, evtToStartScriptExecAt);
            nonlcon = @(x) lvdOpt.constraints.evalConstraints(x, true, evtToStartScriptExecAt, true);
                        
            usePara = lvdOpt.lvdData.settings.optUsePara;
            scaleProb = lvdOpt.lvdData.settings.getScaleProbStr();
            
            if(strcmpi(scaleProb,'obj-and-constr'))
                scaleMesh = true;
            else
                scaleMesh = false;
            end

            initMeshSize = norm(typicalX)/(10*length(typicalX));
            opts = obj.options.getOptionsForOptimizer(x0All);
            opts = optimoptions(opts, 'ScaleMesh',scaleMesh, 'UseParallel',usePara, 'InitialMeshSize',initMeshSize);
            
            problem.objective = objFuncWrapper;
            problem.x0 = x0All;
            problem.Aineq = [];
            problem.bineq = [];
            problem.Aeq = [];
            problem.beq = [];
            problem.lb = lbAll;
            problem.ub = ubAll;
            problem.nonlcon = nonlcon;
            problem.options = opts;
            problem.solver = 'patternsearch';
            
            problem.lvdData = lvdOpt.lvdData; %need to get lvdData in somehow
                    
            %%% Run optimizer
            celBodyData = lvdOpt.lvdData.celBodyData;
            propNames = {'Liquid Fuel/Ox','Monopropellant','Xenon'};
            handlesObsOptimGui = ma_ObserveOptimGUI(celBodyData, problem, true, writeOutput, [], varNameStrs, lbUsAll, ubUsAll);
            
            recorder = ma_OptimRecorder();
            outputFnc = @(x, optimValues, state) ma_OptimOutputFunc(x, optimValues, state, handlesObsOptimGui, problem.objective, problem.lb, problem.ub, celBodyData, recorder, propNames, writeOutput, varNameStrs, lbUsAll, ubUsAll);
            problem.options.OutputFcn = outputFnc;
            
            lvd_executeOptimProblem(celBodyData, writeOutput, problem, recorder);
            close(handlesObsOptimGui.ma_ObserveOptimGUI);
        end
    end
end