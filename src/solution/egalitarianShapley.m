function sol = egalitarianShapley(game, alpha)
    % EGALITARIANSHAPLEY computes the Egalitarian Shapley value of a cooperative game.
    % Syntax: sol = egalitarianShapley(game,alpha)
    % Input:
    %   game - A cooperative game object created using createGame(n)
    %   alpha - A parameter for the egalitarian approach (if possible, 0 <= alpha <= 1)
    % Output:
    %   sol - A allocation vector representing the Egalitarian Shapley value for each player

    % Compute the Shapley value
    [shap, ~] = shapleyValue(game);

    % Compute the equal allocation
    n = game.n;
    totalValue = game.v(end); % Value of the grand coalition
    equalShare = totalValue / n;

    % Compute the Egalitarian Shapley value
    sol = (1 - alpha) * shap + alpha * equalShare;
end
