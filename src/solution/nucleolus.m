function [nuc, epsilon_seq] = nucleolus(game)
    % nucleolus - Calculate the nucleolus for a cooperative game
    % Syntax: nuc = nucleolus(game)
    % Input:
    %   game - A cooperative game object created using createGame(n)
    % Output:
    %   nuc  - A vector representing the nucleolus values for each player
    %   epsilon_seq - Sequence of maximum excess values during iterations

    n = game.n;
    v = game.v;
    coalitionMat = game.coalitionMat;
    N = length(v);

    % Remove empty set and grand coalition from constraints
    coalitions = coalitionMat;
    values = v;

    % objective: minimize the maximum excess
    f = [zeros(1, n), 1]; % [x1, x2, ..., xn, epsilon]

    % Efficiency constraint: sum(x) = v(N)
    Aeq = ones(1, n);
    beq = v(end);

    % dissatisfaction constraints: x(S) >= v(S) - epsilon for all S
    A = -coalitions;
    b = -values;

    % Adjustment to linprog
    Aeq_lp = [Aeq, 0];
    beq_lp = beq;
    A_lp = [A, -ones(size(A, 1), 1)];
    b_lp = b;

    options = optimoptions('linprog', 'Display', 'off');

    epsilon_seq = [];
    activeIdx = [];
    fixedConstraints = [];
    tol = 1e-8;

    % Iterative refinement
    while true
        [sol, fval, exitflag, ~, lambda] = linprog(f, A_lp, b_lp, Aeq_lp, beq_lp, [], [], options);

        if exitflag ~= 1
            error('Linear program did not converge');
        end

        nuc = sol(1:n);
        epsilon = sol(end);
        epsilon_seq = [epsilon_seq; epsilon];

        % Identify active constraints
        excess = A * nuc - b; % v(S) - x(S) = - (A * nuc - b)
        newActive = find(abs(excess + epsilon) < tol);

        % Stop if no new active constraints or solution stabilized
        if isempty(setdiff(newActive, activeIdx))
            break;
        end

        activeIdx = union(activeIdx, newActive);

        % Fix active constraints
        Aeq_new = [- coalitions(activeIdx, :), -ones(length(activeIdx), 1)];
        beq_new = -values(activeIdx);

        % Update constraints for next iteration
        Aeq_lp = [Aeq_lp; Aeq_new];
        beq_lp = [beq_lp; beq_new];
        A_lp(activeIdx, :) = [];
        b_lp(activeIdx) = [];

        % Stop if determined uniquely
        if rank(Aeq_lp(:, 1:n)) == n
            break;
        end

    end

    nuc = nuc(:); % Ensure column vector
end
