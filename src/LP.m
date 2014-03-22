classdef LP < handle
    % LP Data class of an LP problem.
    % Contatins data for the following problem
    % minimise c'x subject to Ax = b and x >= 0.
    % 
    % Date: March 27, 2014
    % Author: Yiming Yan @ University of Edinburgh
    
    %% Problem data
    properties (SetAccess = private)
        Name;   % Name of the problem
        A;      % \          
        b;      % | Problem data (A,b,c)
        c;      % /
        m;      % Number of constraints
        n;      % Number of variables
    end
    
    %% Optimal solution related properties
    properties (SetAccess = private)
        x;      % Current best approx. for primal optimal solution x*
        y;      % Current best approx. for dual optimal solution y*
        s;      % Current best approx. for dual optimal solution s*
    end
    
    methods
        %% Constructor
        function lp = LP(A, b, c, Name)
           % LP Constructor. 
           % lp = LP(A, b, c)
           % lp = LP(A, b, c, Name)
           % Required input: A, b, and c. LP Problem data.
           % Optional input: Name. Default value 'lp'.
           
           if nargin < 4
               lp.Name = 'lp';
               if nargin < 3
                   error('LP: problem data (A,b,c) needed.');
               end
           else
               lp.Name = Name;
           end 
           
           % Check the dimension of data (A,b,c)
           [tmp_m, tmp_n] = size(A);
           
           if size(c,1) < size(c,2) || size(b,1) < size(b,2) || size(c,1) ~= tmp_n || size(b,1) ~= tmp_m
               error('LP: data dimensions does not match.');
           else
               lp.m = tmp_m; lp.n = tmp_n;
           end
           
           % Store data (A,b,c)
           if ~issparse(A)
               lp.A = sparse(A);
           else
               lp.A = A;
           end
           
           lp.b = b; lp.c = c;
        end
        
        %% Set functions
        function lp = update_x(lp, x_new)
           if size(x_new, 1) ~= lp.n
               error('LP: cannot set x - check the dimension.');
           else
               lp.x = x_new;
           end               
        end
        
        function lp = update_y(lp, y_new)
           if size(y_new, 1) ~= lp.m
               error('LP: cannot set y - check the dimension.');
           else
               lp.y = y_new;
           end               
        end
        
        function lp = update_s(lp, s_new)
           if size(s_new, 1) ~= lp.n
               error('LP: cannot set s - check the dimension.');
           else
               lp.s = s_new;
           end               
        end        
    end
    
    
end