classdef Counter < handle
% COUNTER Keeps tracking IPMs' iteration count.
%
% 16 September 2013
% Yiming Yan
% University of Edinburgh
    properties
        iterN = 0; % ipm iteration counter
    end
    
    methods
        function counter = Counter()
        end
        
        function incrementIterationCount(counter) 
        % incrementIterationCount - Increase ipm iteration count
        
            counter.iterN = counter.iterN + 1;
        end
        
    end
end
