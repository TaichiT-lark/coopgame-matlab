function [isMono, violatingCoalitions] = ismonotonicity(game)
% ISMONOTONICITY - Check monotonicity of a cooperative game
% Syntax:
%   [isMono, violatingCoalitions] = ismonotonicity(game)
% Inputs:
%   game - Cooperative game object created using createGame(n)
% Outputs:
%   isMono - Boolean flag (true if monotonic, false otherwise)
%   violatingCoalitions - Cell array of coalitions that violate monotonicity
% Description:
%   The function checks whether the game satisfies
%       v(S) <= v(T) for all S ⊆ T ⊆ N
%   If violated, it returns the violating coalitions.   

    n = game.n;
    v = game.v(:);
    coalitionMat = game.coalitionMat;
    s_n = size(coalitionMat, 1); % number of coalitions

    violatingCoalitions = {};
    isMono = true;
    for i = 1:s_n
        for j = i+1:s_n
            S = coalitionMat(i, :);
            T = coalitionMat(j, :);

            if all(S <= T) && v(i) > v(j) + 1e-8
                isMono = false;
                violatingCoalitions{end+1} = find(S); %#ok<AGROW>
            elseif all(T <= S) && v(j) > v(i) + 1e-8
                isMono = false;
                violatingCoalitions{end+1} = find(T); %#ok<AGROW>
            end
        end
    end
end