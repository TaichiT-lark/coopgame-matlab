function [isSuperAdditive, violatingPairs] = issuperadditivity(game)
    % ISSUPERADDITIVITY checks if a cooperative game is superadditive.
    % Syntax:
    %   [isSuperAdditive, violatingPairs] = issuperadditivity(game)
    %
    % Inputs:
    %   game - Cooperative game object created using createGame(n)
    %
    % Outputs:
    %   isSuperAdditive - Boolean flag (true if superadditive, false otherwise)
    %   violatingPairs  - Cell array of {S, T} pairs that violate superadditivity

    n = game.n;
    v = game.v(:); % ensure column vector
    coalitionMat = game.coalitionMat;
    s_n = size(coalitionMat, 1);

    % Convert binary coalition matrix to integer indices (0-based)
    powers = 2 .^ ((n - 1):-1:0);
    idxVals = coalitionMat * powers';

    % Compute bitwise OR (union) and AND (intersection)
    unionIdx = bitor(idxVals, idxVals'); % matrix of S ∪ T
    interIdx = bitand(idxVals, idxVals'); % matrix of S ∩ T

    % Evaluate condition only for disjoint pairs
    isDisjoint = (interIdx == 0);

    % Matrix forms
    vS = repmat(v, 1, s_n);
    vT = repmat(v', s_n, 1);
    vUnion = v(unionIdx + 1);

    % Superadditivity condition: v(S ∪ T) ≥ v(S) + v(T) for disjoint S, T
    condMat = (vUnion >= (vS + vT)) | ~isDisjoint;

    % Only check upper triangle (S<T) and disjoint pairs
    upperMask = triu(true(s_n), 1);
    condHalf = condMat(upperMask);
    isSuperAdditive = all(condHalf);

    % Output violating pairs (if any)
    if nargout > 1
        [S_idx, T_idx] = find(~condMat & upperMask & isDisjoint);
        violatingPairs = cell(length(S_idx), 2);

        for k = 1:length(S_idx)
            S = find(coalitionMat(S_idx(k), :));
            T = find(coalitionMat(T_idx(k), :));
            violatingPairs{k, 1} = S;
            violatingPairs{k, 2} = T;
        end

    end

end
