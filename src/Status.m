classdef Status < handle
    % Status Data collection to recod status changes during the algorithm.
    % This class will be replaced by a listener class in the future.
    %
    % September 20, 2013
    % Yiming Yan
    % University of Edinburgh
    
    properties(SetAccess = private)
        exitflag;            % Exit status of the ipm procedure
                             % Default value NaN;
                             % 0, terminted by relative residual
                             % 1, terminated as reaching maxIter
    end
    
    methods
        % Constructor
        function status = Status()
            
            % Reset all status
            status.exitflag = NaN;
        end
        
        
        function updateExtflg(status, stat)
            % updateExtflg - Update the exit status of the IPM procedure
            %    stat:
            %        'terminatedByRelResidual', 'terminatedByMu_cap',
            %        'terminatedByMaxIter'
            switch strtrim(stat)
                case 'terminatedByRelResidual'
                    status.exitflag = 0;
                case 'terminatedByMaxIter'
                    status.exitflag = 1;
            end
        end
    end
    
end

