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
    %   for all S, T ⊆ N using pure matrix operations.
    %   If violated, it returns the violating (S, T) pairs.

    n = game.n;
    v = game.v(:);
    coalitionMat = game.coalitionMat;
    s_n = size(coalitionMat, 1); % number of coalitions

    violatingPairs = {};
    isConvex = true;
    for i = 1:s_n
        for j = i:s_n
            S = coalitionMat(i, :);
            T = coalitionMat(j, :);

            S_union_T = S | T;
            S_inter_T = S & T;

            idx_union = find(all(coalitionMat == S_union_T, 2));
            idx_inter = find(all(coalitionMat == S_inter_T, 2));

            if v(idx_union) + v(idx_inter) < v(i) + v(j)
                isConvex = false;
                violatingPairs = [violatingPairs; {S, T}];
            end
        end
    end
end