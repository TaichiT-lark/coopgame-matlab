function [isCore, violatingCoalitions] = iscore(game, x)
% ISCORE - Check if an allocation vector x belongs to the Core
% Syntax:
%   [isCore, violatingCoalitions] = iscore(game, x)
%
% Inputs:
%   game - Cooperative game object created using createGame(n)
%   x    - Allocation vector (1 x n)
%
% Outputs:
%   isCore - Boolean flag (true if x ∈ Core, false otherwise)
%   violatingCoalitions - Cell array of violating coalitions (if any)
%
% Core conditions:
%   1. Efficiency: sum(x) == v(N)
%   2. Coalitional rationality: sum(x(S)) >= v(S) for all S ⊂ N

    n = game.n;
    v = game.v;
    C = game.coalitionMat;

    % --- 1. Efficiency condition ---
    vN = v(end); % v(N)
    if abs(sum(x) - vN) > 1e-8
        isCore = false;
        violatingCoalitions = {'Efficiency condition violated'};
        return;
    end

    % --- 2. Coalitional rationality ---
    violatingCoalitions = {};
    for s = 2:(2^n - 1)  % exclude empty set and full coalition
        members = find(C(s, :));
        if sum(x(members)) < v(s) - 1e-8
            violatingCoalitions{end+1} = members; %#ok<AGROW>
        end
    end

    isCore = isempty(violatingCoalitions);
end
