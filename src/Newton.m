classdef Newton < handle
    % NEWTON Solves Newton's direction
    %
    % The Newton's diections are obtained by solving the following system,
    %   [   A   0   0 ] [ dx ] = - [           Ax - b ]
    %   [   0   A'  I ] [ dy ] = - [         A'y +s -c]
    %   [   S   0   X ] [ ds ] = - [ XSe - sigma*mu*e ].
    %
    % Augmented system is actually solved.
    %
    % March 22, 2014
    % Yiming Yan
    % University of Edinburgh
    
    %% Properties
    properties (SetAccess = private)
        sigma;      % Centering parameter
        dx;         % Newton direction for x
        dy;         % Newton direction for y
        ds;         % Newton direction for s
    end
    
    %% Methods
    methods
        
        %% Constructor
        function newton = Newton()
        % Newton constructor 
        
        end
        
        %% Driver for solving Newton's direction         %
        function solve(newton, iter, parameters, lp)
            % solve - Solves Newton's Directions
            
            % Make a heuristic choice of the centering parameters,
            % and adjust the right-hand side
            newton.sigma = min(0.1,100*iter.mu);
            Rc = iter.Rc - newton.sigma*iter.mu;
            
            % Use augmented system to solve the directions
            rhs = sparse([-iter.Rp; -iter.Rd + Rc ./ iter.x]);
            
            % Set up the scaling matrix and form the coef matrix for normal equations
            DD = min(parameters.maxDiag,...
                - iter.s ./ iter.x);
            B = [sparse(lp.m,lp.m) lp.A; lp.A' sparse(1:lp.n,1:lp.n,DD)];
            
            % ldl' factorization
            [L,D,pm] = newton.getFactorisation(B);
            
            % Solve linear system
            dxy = newton.solveLinearSystem(lp, rhs, L, D, pm);
            
            % Get the directions
            newton.dy = dxy(1:lp.m);
            newton.dx = dxy( lp.m + 1 : lp.m + lp.n );
            newton.ds = -( Rc + iter.s .* newton.dx ) ./ iter.x;
        end
        
    end
    
    methods (Static)
        function [L,D,pm] = getFactorisation(B)
            % getFactorisation - LDL' factorisation
            [L, D, pm] = ldl(B,'vector');
        end
        
        function d = solveLinearSystem(prob, rhs, L, D, pm)
            % solveLinearSystem - Solves a linear system of equations
            
            d = zeros(prob.m + prob.n, 1);
            d(pm, :) =...
                L'\(D\(L\(rhs(pm, :))));
        end
        
    end
    
    
    
end
