classdef Parameters
        % PARAMETERS Defines parameters for the solver.
        % Date  : March 22, 2014
        % Author: Yiming @ University of Edinburgh

    properties (SetAccess = private)
        maxIter = 100;    % Maximum number of iterations allowed
        tol     = 1.e-6;  % Convergence tolerance
        verbose = 2;      % Controlls how much information to dispaly.
                          % 0   : Nothing
                          % 1   : Only optimal information
                          % 2   : every iterations + optimal information
                          % >=3 : All information
    end
    
    properties (Constant)
        maxDiag = 5.e+15; % Cap for element in the X^{-1}S matrix
        etaMin  = .995;   % Minimum value of the steplength scale parameter eta
    end
    
    methods
        % Constructor
        % paramters_input, optional, the struct contaitns user defined
        % paramters. This will overwirte some of the predifined parameters,
        % including:
        %     maxIter, tol, verbose.
        function parameters = Parameters(parameters_input)
            if nargin > 0
                if isfield(parameters_input, 'maxIter')
                    parameters.maxIter = parameters_input.maxIter;
                end
                
                if isfield(parameters_input, 'tol')
                    parameters.tol = parameters_input.tol;
                end
                
                if isfield(parameters_input, 'verbose')
                    parameters.verbose = parameters_input.verbose;
                end
            end
        end
        
    end
end