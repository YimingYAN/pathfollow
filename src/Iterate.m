classdef Iterate < handle
    % Iterate Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Rd;         % Dual residual
        Rp;         % Primal residual
        Rc;         % Complementary residual
        residual;   % residual
        mu;         % Duality gap
    end
    
    % Propeties for conducting the iterative process
    properties (SetAccess = private)
        x;          % \
        y;          % | Iterates
        s;          % /
        
        
        bc;         % Normalizing factor for residual
        
        alphax;     % Step size for x
        alphas;     % Step size for s
    end
    
    %% Methods
    methods
        %% Constructor
        function iter = Iterate(lp)
            iter.bc = 1+max([norm(lp.b), norm(lp.c)]);
        end
        
        %% calculateResiduals
        function calculateResiduals(iter, lp)
            % CalculateResiduals - Calculates residuals
            iter.Rd = lp.A' * iter.y + iter.s - lp.c;
            iter.Rp = lp.A  * iter.x - lp.b;
            iter.Rc = iter.x.*iter.s;
            
            % Get the duality gap
            iter.mu = mean(iter.Rc);
            iter.residual = norm([iter.Rd; iter.Rp; iter.Rc])/iter.bc;
        end
        
        %% checkTermination
        function termination = checkTermination(iter, lp, counter, parameters, status)
            % checkTermination - Checks termiantion condition
            
            termination = 0;
            
            % Check residual
            if ~isempty(iter.residual) && iter.residual < parameters.tol
                termination = 1;
                status.updateExtflg('terminatedByRelResidual');
            end
            
            % Check maxIter
            if counter.iterN >= parameters.maxIter
                termination = 1;
                status.updateExtflg('terminatedByMaxIter');
            end
            
            % Set optimal solution
            if termination 
                lp.set_optx( iter.x );
                lp.set_opty( iter.y );
                lp.set_opts( iter.s );
            end
        end
        
        %% nextIter
        function nextIter(iter, newton)
            % nextIter - Gets next iterates.
            % Run this function after get Newton direction and step size.
            
            iter.update_x( iter.x + iter.alphax*newton.dx );
            iter.update_s( iter.s + iter.alphas*newton.ds );
            iter.update_y( iter.y + iter.alphas*newton.dy );
        end
        
        
        %% stepSize
        function stepSize(iter, parameters, newton)
            % stepSize - Calculates stepsize
            
            % Set the parameters eta defining fraction of max step to boundary
            eta = max(parameters.etaMin, 1-iter.mu);
            
            iter.alphax = -1/min(min( newton.dx ./ iter.x),-1);
            iter.alphax = min(1, eta * iter.alphax);
            
            iter.alphas = -1/min(min( newton.ds ./ iter.s),-1);
            iter.alphas = min(1, eta * iter.alphas);
        end
        
        %% initialPoint
        function initialPoint(iter, lp)
            % initialPoint - Gets the starting point (x0,y0,s0) for the primal-dual IPMs
            %
            % For reference, please refer to "On the Implementation of a Primal-Dual
            % Interior Point Method" by Sanjay Mehrotra.
            
            e = ones(lp.n,1);
            
            % solution for min norm(s) s.t. A'*y + s = c
            y0 = (lp.A*lp.A')\(lp.A*lp.c);
            s0 = lp.c-lp.A'*y0;
            
            % min norm(x) s.t. Ax = b
            x0 = lp.A'*( (lp.A*lp.A')\lp.b );
            
            % delta_x and delta_s
            delta_x = max(-1.5*min(x0),0);
            delta_s = max(-1.5*min(s0),0);
            
            % delta_x_c and delta_s_c
            pdct = 0.5*(x0+delta_x*e)'*(s0+delta_s*e);
            delta_x_c = delta_x+pdct/(sum(s0)+lp.n*delta_s);
            delta_s_c = delta_s+pdct/(sum(x0)+lp.n*delta_x);
            
            % output
            iter.update_x(x0+delta_x_c*e);
            iter.update_s(s0+delta_s_c*e);
            iter.update_y(y0);
        end
        
        %% Set new iterate
        function iter = update_x(iter, x_new)
            
            iter.x = x_new;
        end
        
        function iter = update_y(iter, y_new)

            iter.y = y_new;
        end
        
        function iter = update_s(iter, s_new)
            
            iter.s = s_new;
            
        end
        
        
    end
end

