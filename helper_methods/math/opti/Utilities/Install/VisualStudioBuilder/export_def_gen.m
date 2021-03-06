function export_def_gen(path,outpath,name)
%Generate export definition file for DLL building


%Generate dump file
%dumpbin /ALL /OUT:dump.txt "libclp.lib" "libcoinutils.lib" "libosi.lib"

%Read into MATLAB
dump = fileread(path); len = length(dump);
nl = sprintf('\n'); ord = 1;
if(strcmp(computer,'PCWIN'))
    name = [name '32'];
else
    name = [name '64'];
end
try
    fprintf('Generating %s.def...',name);
    %Write .DEF file header
    fp = fopen([outpath filesep name '.def'],'w');
    fprintf(fp,'LIBRARY   %s\n',upper(name));
    fprintf(fp,'EXPORTS\n');

    %For each method, find, write corresponding entry(ies)
    switch(name)
        case {'optiSolverPackA32','optiSolverPackA64'}
            m = retSPA();
        case {'optiSolverPackB32','optiSolverPackB64'}
            m = retSPB();
        otherwise
            error('Unknown definition file');
    end
    for i = 1:length(m)
        if(m{i}(1) == '?')
            idx = strfind(dump,[m{i} '@']);
        else
            idx = strfind(dump,sprintf('%s\r',m{i}));
            if(isempty(idx))
                idx = strfind(dump,[m{i} '@']); %have a go
            end
        end
        temp = cell(length(idx),1);
        if(isempty(idx))
            error('Could not find entry %s',m{i});
        else
            for j = 1:length(idx)
                n = length(m{i});
                while(idx(j)+n < len && ~strcmp(dump(idx(j)+n),nl))
                    n = n+1;
                end
                symbol = dump(idx(j):idx(j)+n-2);
                ind = strfind(symbol,'@');
                if(m{i}(1) ~= '?' && ~isempty(ind)) %C, don't need @
                    symbol = symbol(1:ind(1)-1);
                end
                if(~any(strcmp(temp,symbol)))         
                    temp{j} = symbol;
                    fprintf(fp,'   %s @%d\n',symbol,ord);
                    ord = ord + 1;
                end
            end
        end
    end
    fclose(fp);
catch ME
    fclose(fp);
    rethrow(ME);
end
fprintf('Done! [%d ordinals]\n',ord-1);    
        

function str = retSPA()
%Return known Exports for OPTI Solver PackA

%Clp
str = {'??0ClpSolve','??1ClpSolve','??0ClpSimplex','??1ClpSimplex','?loadProblem@ClpSimplex',...
       '?initialSolve@ClpSimplex','?setPresolveType@ClpSolve','?setSolveType@ClpSolve',...
       '??0ClpEventHandler','??1ClpEventHandler','?eventWithInfo@ClpEventHandler',...
       '?passInMessageHandler@ClpModel','?passInEventHandler@ClpSimplex','?loadQuadraticObjective@ClpModel',...
       '?setDualObjectiveLimit@ClpModel','?setDualTolerance@ClpModel','?setMaximumIterations@ClpModel',...
       '?setMaximumSeconds@ClpModel','?setObjectiveOffset@ClpModel','?setPrimalObjectiveLimit@ClpModel',...
       '?setPrimalTolerance@ClpModel','?setFactorizationFrequency@ClpSimplex','?setNumberRefinements@ClpSimplex'};
   
%CoinUtils
str = [str '??0CoinLpIO', '??1CoinLpIO', '??0CoinMpsIO', '??1CoinMpsIO', '?getMatrixByCol@CoinMpsIO',...
       '?readGMPL@CoinMpsIO','?readMps@CoinMpsIO','?passInMessageHandler@CoinMpsIO','?getNumCols@CoinMpsIO',...
       '?getNumRows@CoinMpsIO','?readGms@CoinMpsIO','?setInfinity@CoinMpsIO','?readQuadraticMps@CoinMpsIO',...
       '?integerColumns@CoinMpsIO','?objectiveOffset@CoinMpsIO','?getColLower@CoinMpsIO','?getColUpper@CoinMpsIO',...
       '?getObjCoefficients@CoinMpsIO','?getRowLower@CoinMpsIO','?getRowUpper@CoinMpsIO','??0CoinMessageHandler',...
       '?checkSeverity@CoinMessageHandler','??1CoinMessageHandler','?clone@CoinMessageHandler','?setLogLevel@CoinMessageHandler',...
       '?getProblemName@CoinMpsIO','?getProblemName@CoinLpIO','?getNumCols@CoinLpIO','?getNumRows@CoinLpIO',...
       '?getColLower@CoinLpIO','?getColUpper@CoinLpIO','?getRowLower@CoinLpIO','?getRowUpper@CoinLpIO',...
       '?getObjCoefficients@CoinLpIO','?getMatrixByCol@CoinLpIO','?objectiveOffset@CoinLpIO',...
       '?integerColumns@CoinLpIO','?setInfinity@CoinLpIO','?readLp@CoinLpIO','?passInMessageHandler@CoinLpIO',...
       'glp_version','??0CoinPackedMatrix','??1CoinPackedMatrix','??0CoinSet','??4CoinSet','??1CoinSet',...
       '??0CoinSosSet','??1CoinSosSet','?setMpsData@CoinMpsIO','?setProblemName@CoinMpsIO',...
       '?writeMps@CoinMpsIO','?setProblemName@CoinLpIO','?setLpDataWithoutRowAndColNames@CoinLpIO',...
       '?writeLp@CoinLpIO'];
   
%CBC
str = [str '??1CoinOneMessage', '??0CoinOneMessage', '??1OsiSolverInterface', '?setDblParam@OsiClpSolverInterface',...
       '?setInteger@OsiClpSolverInterface','?loadProblem@OsiClpSolverInterface','??0OsiClpSolverInterface',...
       '??1OsiClpSolverInterface','??0CbcEventHandler','??1CbcEventHandler',...
       '?addObjects@CbcModel','?setHotstartSolution@CbcModel','?isProvenInfeasible@CbcModel',...
       '?passInEventHandler@CbcModel','?passInMessageHandler@CbcModel','??0CbcModel','??1CbcModel',...
       '?CbcMain0','?CbcMain1','??0CbcSOS'];

%GLPK
str = [str 'glp_create_prob','glp_set_obj_dir','glp_add_rows','glp_add_cols','glp_set_row_bnds',...
       'glp_set_col_bnds','glp_set_obj_coef','glp_load_matrix','glp_delete_prob','glp_get_num_cols',...
       'glp_scale_prob','glp_adv_basis','glp_simplex','glp_exact','glp_init_smcp','glp_get_status',...
       'glp_get_obj_val','glp_get_row_dual','glp_get_col_prim','glp_get_col_dual','glp_interior',...
       'glp_ipt_status','glp_ipt_obj_val','glp_ipt_row_dual','glp_ipt_col_prim','glp_ipt_col_dual',...
       'glp_set_col_kind','glp_intopt','glp_init_iocp','glp_mip_status','glp_mip_obj_val',...
       'glp_mip_col_val','glp_write_mps','glp_write_lp','glp_free_env','glp_term_hook',...
       'glp_error_','glp_error_hook','_glp_lpx_set_int_parm','_glp_lpx_set_real_parm',...
       '_glp_lpx_print_prob'];

%MUMPS
str = [str 'dmumps_c','zmumps_c'];

%IPOPT
str = [str '?ResortX@TNLPAdapter@Ipopt','??0IpoptApplication@Ipopt','??1IpoptApplication@Ipopt',...
       '?Initialize@IpoptApplication@Ipopt','?OptimizeTNLP@IpoptApplication@Ipopt','?Statistics@IpoptApplication@Ipopt',...
       '?Snprintf@Ipopt','??0Journal@Ipopt','??1Journal@Ipopt','?Name@Journal@Ipopt',...
       '?SetPrintLevel@Journal@Ipopt','?SetAllPrintLevels@Journal@Ipopt','?IsAccepted@Journal@Ipopt'];

%BONMIN
str = [str '??1BabSetupBase@Bonmin','??1BonminSetup@Bonmin','?readOptionsFile@BabSetupBase@Bonmin',...
       '?initializeOptionsAndJournalist@BabSetupBase@Bonmin','??0BonminSetup@Bonmin','?registerOptions@BonminSetup',...
       '?initialize@BonminSetup@Bonmin','??0Bab@Bonmin','??1Bab@Bonmin','??0TMINLP@Bonmin','??1TMINLP@Bonmin'];
   
%OOQP
str = [str '?addMonitor@Solver', '??0MehrotraSolver', '??0GondzioSolver','?makeData@QpGenSparseSeq',...
       '??0QpGenSparsePardiso', '??0QpGenSparseMa57', 'getOoqpVersionString', '??1Status'];
   
%NOMAD
str = [str '??0Parameter_Entry@NOMAD','??1Parameter_Entries@NOMAD','?insert@Parameter_Entries@NOMAD',...
       '??0Double@NOMAD','??1Double@NOMAD','??4Double@NOMAD','?value@Double@NOMAD','??0Point@NOMAD',...
       '??1Point@NOMAD','??APoint@NOMAD','?set@Point@NOMAD','?init@Parameters@NOMAD',...
       '??1Parameters@NOMAD','?help@Parameters@NOMAD','?read@Parameters@NOMAD','?check@Parameters@NOMAD',...
       '?set_DISPLAY_DEGREE@Parameters@NOMAD','?set_X0@Parameters@NOMAD','?get_signature@Parameters@NOMAD',...
       '?set_DIMENSION@Parameters@NOMAD','?set_LOWER_BOUND@Parameters@NOMAD','?set_UPPER_BOUND@Parameters@NOMAD',...
       '?get_index_obj@Parameters@NOMAD','?set_BB_INPUT_TYPE@Parameters@NOMAD','?set_BB_OUTPUT_TYPE@Parameters@NOMAD',...
       '?get_sgte_cost@Parameters@NOMAD','?has_sgte@Parameters@NOMAD','?get_opt_only_sgte@Parameters@NOMAD',...
       '?get_h_min@Parameters@NOMAD','?get_h_max_0@Parameters@NOMAD','?get_best_infeasible@Barrier@NOMAD',...
       '?reset@Model_Stats@NOMAD','?reset@Stats@NOMAD','??0Evaluator@NOMAD','?eval_x@Evaluator@NOMAD',...
       '?compute_f@Evaluator@NOMAD','?compute_f@Multi_Obj_Evaluator@NOMAD','?begin@Pareto_Front@NOMAD',...
       '?next@Pareto_Front@NOMAD','??0Evaluator_Control@NOMAD','??1Evaluator_Control@NOMAD',...
       '?init@Mads@NOMAD','??1Mads@NOMAD','?run@Mads@NOMAD','?multi_run@Mads@NOMAD',...
       '?_epsilon@Double@NOMAD','?_current_tag@Eval_Point@NOMAD','?_current_bbe@Eval_Point@NOMAD',...
       '?_current_sgte_bbe@Eval_Point@NOMAD','?reset_tags_and_bbes@Eval_Point@NOMAD','?is_feasible@Eval_Point@NOMAD',...
       '?is_eval_ok@Eval_Point@NOMAD'];
   
function str = retSPB()
%Return known Exports for OPTI Solver PackB   
   
%LBFGSB
str = {'SETULB'};

%LEVMAR
str = [str 'dlevmar_der', 'dlevmar_dif', 'dlevmar_bc_der', 'dlevmar_bc_dif', 'dlevmar_lec_der',...
       'dlevmar_lec_dif', 'dlevmar_blec_der', 'dlevmar_blec_dif', 'dlevmar_bleic_der',...
       'dlevmar_bleic_dif', 'dlevmar_blic_der', 'dlevmar_blic_dif', 'dlevmar_leic_der',...
       'dlevmar_leic_dif', 'dlevmar_lic_der', 'dlevmar_lic_dif'];

%M1QN3
str = [str 'M1QN3', 'EUCLID', 'CTONBE', 'CTCABE'];

%MINPACK
str = [str 'HYBRD', 'HYBRJ', 'LMDER', 'LMDIF'];

%PORT NL2SOL
str = [str 'DN2F', 'DN2G', 'DN2FB', 'DN2GB', 'DIVSET', 'D1MACH'];



%PSwarm
str = [str 'PSwarm' 'opt' 'stats'];

%Nlopt
str = [str 'nlopt_algorithm_name', 'nlopt_create','nlopt_destroy','nlopt_optimize','nlopt_set_min_objective',...
       'nlopt_set_lower_bounds','nlopt_set_upper_bounds','nlopt_add_inequality_mconstraint','nlopt_add_equality_mconstraint',...
       'nlopt_set_stopval','nlopt_set_ftol_rel','nlopt_set_ftol_abs','nlopt_set_xtol_rel','nlopt_set_xtol_abs',...
       'nlopt_set_maxeval','nlopt_set_maxtime','nlopt_force_stop','nlopt_set_local_optimizer',...
       'nlopt_set_population','nlopt_set_vector_storage'];
   
%DSDP
str = [str 'DSDPCreate','DSDPSetup','DSDPSolve','DSDPComputeX','DSDPDestroy','DSDPCreateBCone',...
      'BConeAllocateBounds','BConeSetLowerBound','BConeSetUpperBound','DSDPSetYBounds','DSDPGetYBounds',...
      'DSDPCreateLPCone','LPConeSetData2','LPConeScaleBarrier','DSDPCreateSDPCone','SDPConeSetBlockSize',...
      'SDPConeSetSparsity','SDPConeSetASparseVecMat','SDPConeSetXArray','DSDPSetDualObjective',...
      'DSDPGetDObjective','DSDPGetDDObjective','DSDPGetPObjective','DSDPGetPPObjective',...
      'DSDPGetPenaltyParameter','DSDPSetR0','DSDPGetR','DSDPSetRTolerance','DSDPGetRTolerance',...
      'DSDPSetY0','DSDPGetY','DSDPGetBarrierParameter','DSDPSetBarrierParameter',...
      'DSDPReuseMatrix','DSDPSetMaxIts','DSDPSetStepTolerance','DSDPGetStepTolerance',...
      'DSDPSetGapTolerance','DSDPGetGapTolerance','DSDPSetPNormTolerance','DSDPGetPNormTolerance',...
      'DSDPSetDualBound','DSDPGetDualBound','DSDPSetPTolerance','DSDPGetPTolerance',...
      'DSDPGetPInfeasibility','DSDPSetMaxTrustRadius','DSDPGetMaxTrustRadius',...
      'DSDPStopReason','DSDPGetSolutionType','DSDPSetPotentialParameter','DSDPGetPotentialParameter',...
      'DSDPUseDynamicRho','DSDPGetIts','DSDPGetPnorm','DSDPGetStepLengths','DSDPSetMonitor',...
      'DSDPSetPenaltyParameter','DSDPUsePenalty','DSDPGetTraceX','DSDPSetZBar',...
      'DSDPSetDualLowerBound','DSDPGetDataNorms','DSDPGetYMaxNorm','SDPConeUsePackedFormat',...
      'DSDPSetFixedVariables','LPConeSetXVec'];
      
%LPSOLVE
str = [str,'create_hash_table','free_hash_table','findhash','puthash','drophash','lp_solve_version',...
       'make_lp','resize_lp','get_status','get_statustext','copy_lp','dualize_lp','delete_lp','set_lp_name',...
       'get_lp_name','has_BFP','is_nativeBFP','set_BFP','read_XLI','write_XLI','has_XLI','is_nativeXLI','set_XLI',...
       'set_obj','set_obj_fnex','set_sense','set_maxim','set_minim','is_maxim','add_constraintex','set_add_rowmode',...
       'is_add_rowmode','set_rowex','get_row','del_constraint','set_constr_type','get_constr_type','get_constr_value',...
       'is_constr_type','set_rh','get_rh','set_rh_range','get_rh_range','set_rh_vec','add_columnex','set_columnex',...
       'column_in_lp','get_column','del_column','set_mat','get_mat','get_nonzeros','set_bounds_tighter','get_bounds_tighter',...
       'set_upbo','get_upbo','set_lowbo','get_lowbo','set_bounds','set_unbounded','is_unbounded','set_int','is_int','set_binary',...
       'is_binary','set_semicont','is_semicont','is_negative','set_var_weights','get_var_priority','add_SOS','is_SOS_var',...
       'set_row_name','get_row_name','get_origrow_name','set_col_name','get_col_name','get_origcol_name','unscale',...
       'set_preferdual','set_simplextype','get_simplextype','default_basis','set_basiscrash','get_basiscrash',...
       'set_basisvar','set_basis','get_basis','guess_basis','is_feasible','solve','time_elapsed','put_abortfunc',...
       'put_logfunc','get_primal_solution','get_ptr_dual_solution','read_MPS','read_freeMPS','write_mps','write_freemps',...
       'write_lp','read_LP','write_basis','read_basis','write_params','read_params','reset_params','print_lp','print_tableau',...
       'print_objective','print_solution','print_constraints','print_duals','print_scales','print_str','set_outputfile',...
       'set_verbose','get_verbose','set_timeout','get_timeout','set_print_sol','get_print_sol','set_debug','is_debug',...
       'set_trace','print_debugdump','set_anti_degen','get_anti_degen','is_anti_degen','set_presolve','get_presolve',...
       'get_presolveloops','is_presolve','get_orig_index','get_lp_index','set_maxpivot','get_maxpivot','set_obj_bound',...
       'get_obj_bound','set_mip_gap','get_mip_gap','set_bb_rule','get_bb_rule','set_var_branch','get_var_branch','is_infinite',...
       'set_infinite','get_infinite','set_epsint','get_epsint','set_epsb','get_epsb','set_epsd','get_epsd','set_epsel','get_epsel',...
       'set_epslevel','set_scaling','get_scaling','is_scalemode','is_scaletype','is_integerscaling','set_scalelimit',...
       'get_scalelimit','set_improve','get_improve','set_pivoting','get_pivoting','is_use_names','set_use_names',...
       'get_nameindex','is_piv_mode','is_piv_rule','set_break_at_first','is_break_at_first','set_bb_floorfirst',...
       'get_bb_floorfirst','set_bb_depthlimit','get_bb_depthlimit','set_break_at_value','get_break_at_value',...
       'set_negrange','get_negrange','set_epsperturb','get_epsperturb','set_epspivot','get_epspivot','get_max_level',...
       'get_total_nodes','get_total_iter','get_objective','get_working_objective','get_var_primalresult',...
       'get_var_dualresult','get_variables','get_constraints','get_sensitivity_rhs','get_ptr_sensitivity_rhs',...
       'get_sensitivity_objex','get_ptr_sensitivity_obj','set_solutionlimit','get_solutionlimit','get_solutioncount',...
       'get_Norig_rows','get_Nrows','get_Norig_columns','get_Ncolumns'];


