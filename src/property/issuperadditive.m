function [isSuperAdditive, violatingPairs] = issuperadditive(game)
    % ISSUPERADDITIVE checks if a cooperative game is superadditive.
    % Syntax:
    %   [isSuperAdditive, violatingPairs] = issuperadditive(game)
    %
    % Inputs:
    %   game - Cooperative game object created using createGame(n)
    %
    % Outputs:
    %   isSuperAdditive - Boolean flag (true if superadditive, false otherwise)
    %   violatingPairs  - Cell array of {S, T} pairs that violate superadditivity
    % Description:
    %   The function checks whether the game satisfies
    %       v(S) + v(T) <= v(S ∪ T)
    %   for all disjoint coalitions S, T ⊆ N.

    n = game.n;
    v = game.v(:); % ensure column vector
    coalitionMat = game.coalitionMat;
    s_n = size(coalitionMat, 1);

    violatingPairs = {};
    isSuperAdditive = true;

    for i = 1:s_n
        for j = i:s_n
            S = coalitionMat(i, :);
            T = coalitionMat(j, :);

            if isempty(find(S & T, 1)) % disjoint coalitions
                if v(i) + v(j) > v(find(S | T, 1))
                    isSuperAdditive = false;
                    violatingPairs = [violatingPairs; {S, T}];
                end
            end
        end
    end
end