function sol = approxES(game, alpha, sampleSize)

    % APPROXES computes an approximation of the Egalitarian Shapley value using random sampling.
    % Syntax: sol = approxES(game, alpha, sampleSize)
    % Input:
    %   game - A cooperative game object created using createGame(n)
    %   alpha - A parameter for the egalitarian approach (if possible, 0 <= alpha <= 1)
    %   sampleSize - The number of random samples to use for approximation
    % Output:
    %   sol - An approximate allocation vector representing the Egalitarian Shapley value for each player

    
    n = game.n;
    totalValue = game.v(end); % Value of the grand coalition
    equalShare = totalValue / n;

    hat_shap = approxShapley(game, sampleSize); % Approximate Shapley value using random sampling

    % Compute the approximate Egalitarian Shapley value
    sol = (1 - alpha) * hat_shap + alpha * equalShare;
    
    
end
