function [isConvex, violatingPairs] = isconvex(game)
    % ISCONVEX - Check convexity of a cooperative game using matrix operations
    % Syntax:
    %   [isConvex, violatingPairs] = isconvex(game)
    % Inputs:
    %   game - Cooperative game object created using createGame(n)
    % Outputs:
    %   isConvex        - Boolean flag (true if convex, false otherwise)
    %   violatingPairs  - Cell array of {S, T} pairs that violate convexity
    % Description:
    %   The function checks whether the game satisfies
    %       v(S ∪ T) + v(S ∩ T) >= v(S) + v(T)
    %   for all S, T ⊆ N using pure matrix operations (no loops).
    %   If violated, it returns the violating (S, T) pairs.

    n = game.n;
    v = game.v(:);
    coalitionMat = game.coalitionMat;
    s_n = size(coalitionMat, 1); % number of coalitions

    % Convert binary coalition matrix to integer indices (0-based)
    powers = 2 .^ ((n - 1):-1:0);
    idxVals = coalitionMat * powers';

    % -------------------------------
    % Compute all pairwise unions & intersections
    % -------------------------------
    unionIdx = bitor(idxVals, idxVals'); % matrix of v(S ∪ T)
    interIdx = bitand(idxVals, idxVals'); % matrix of v(S ∩ T)

    % Retrieve v-values for all pairs
    vS = repmat(v, 1, s_n);
    vT = repmat(v', s_n, 1);
    vUnion = v(unionIdx + 1);
    vInter = v(interIdx + 1);

    % -------------------------------
    % Convexity condition check
    % -------------------------------
    condMat = (vUnion + vInter) >= (vS + vT);
    upperMask = triu(true(s_n));
    condHalf = condMat(upperMask);

    isConvex = all(condHalf);

    % -------------------------------
    % Extract violating pairs if any
    % -------------------------------
    if nargout > 1
        [S_idx, T_idx] = find(~condMat & upperMask);
        violatingPairs = cell(length(S_idx), 2);

        for k = 1:length(S_idx)
            S = find(coalitionMat(S_idx(k), :));
            T = find(coalitionMat(T_idx(k), :));
            violatingPairs{k, 1} = S;
            violatingPairs{k, 2} = T;
        end

    end

end
