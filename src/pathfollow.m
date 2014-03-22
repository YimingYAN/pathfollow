classdef pathfollow < handle
    
    
    %% Properties
    properties (SetAccess = private)
        lp;             % LP problem object
        parameters;     % Parameters object
        counter;        % Counter object
        iter;           % Iteration object
        newton;         % Newton's direction object
        output;         % Output object
        status;         % Status object
    end
    
    
    %% Methods
    methods
        %% Constrcutor
        %
        % Optional input:
        %       parameters_input. A struct contatins user defined sparameters.
        function p = pathfollow(A,b,c, parameters_input)
            
            % Initialize objects
            p.lp = LP(A,b,c);
            
            if nargin < 4
                p.parameters = Parameters;
            else
                p.parameters = Parameters(parameters_input);
            end
            
            p.counter = Counter;
            p.iter = Iterate(p.lp);
            p.newton = Newton;
            p.output = Output;
            p.status = Status;
        end
        
        
        %% Main Solver         
        function solve(p)
            % solve - Driver function for the main solver
            
            % Get initial point and it's residual
            p.iter.initialPoint(p.lp);
            p.iter.calculateResiduals(p.lp);
            
            % Main loop
            p.output.printHeader(p.lp, p.parameters)
            while ~p.iter.checkTermination(p.lp, p.counter, p.parameters, p.status);
                
                % Output
                p.output.printIterations(p.counter, p.iter, p.parameters)
                
                % Get Newton's dirction
                p.newton.solve(p.iter, p.parameters, p.lp);
                
                % Get step length
                p.iter.stepSize(p.parameters, p.newton);
                
                % Update the iterate
                p.iter.nextIter(p.newton);
                
                % Calculate residuals
                p.iter.calculateResiduals(p.lp);
                
                % Increase counter
                p.counter.incrementIterationCount;
            end % End while
            
            % Output the info of the final ipm iteration
            p.output.printIterations(p.counter, p.iter, p.parameters);
            p.output.printFooter(p.lp, p.parameters, p.status);
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %            Ultilities              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setProbName(p, Name)
            % setProbName - set the name for the problem
            
            p.lp.setProbName(Name);
        end
        
        function N = getIter(p)
            % getIter - Gets # of ipm iterations
            
            N = p.counter.iterN;
        end
        
        function final_mu = getMu(p)
            % final_mu - Gets mu from ipm
            
            final_mu = p.iter.mu;
        end
        
        
        function residual = getIPMResidual(p)
            % getIPMResidual - Gets residual from ipm
            
            residual = p.iter.residual;
        end
        
        function fval = getFval(p)
            % getFval - get optimal objective function value
            fval = p.lp.c' * p.lp.optx;
        end
        
    end
end
