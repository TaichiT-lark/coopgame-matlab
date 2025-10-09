function [shap, matrix] = shapleyValue(game)
    % shapleyValue - Calculate the Shapley value for a cooperative game
    % Syntax: [shap, matrix] = shapleyValue(game)
    % Input:
    %   game - A cooperative game object created using createGame(n)
    % Output:
    %   shap   - A vector containing the Shapley values for each player
    %   matrix - A matrix representing the weights of each coalition for each player

    n = game.n;
    v = game.v;
    coalitionMat = game.coalitionMat;

    shapMatrix = zeros(n, length(v))

    for S = 1:length(v)
        members = find(coalitionMat(S, :));
        S_n = length(members);

        if isempty(members)
            continue;
        end

        for i = 1:n

            if ismember(i, members)
                shapMatrix(i, S) = factorial(S_n - 1) * factorial(n - S_n) / factorial(n);
            else
                shapMatrix(i, S) = -factorial(S_n) * factorial(n - S_n - 1) / factorial(n);
            end

        end

    end

    shap = shapMatrix * v;

    if nargout > 1
        matrix = shapMatrix;
    end

end
