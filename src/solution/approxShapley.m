function phi_hat = approxShapley(game, sampleSize)
% APPROXSHAPLEY - Approximate the Shapley value using sampling (Castro et al., 2009)
%
% Syntax:
%   phi_hat = approxShapley(game, sampleSize)
%
% Inputs:
%   game - createGame object
%   sampleSize    - number of random permutations (sample size)
%
% Output:
%   phi_hat - approximate Shapley value (n×1 vector)
%
% Description:
%   The algorithm samples sampleSize random player orders (permutations)
%   and computes the marginal contribution of each player in each sample.
%   The result is the unbiased Monte Carlo estimate of the Shapley value.
%
% Reference:
%   Castro, J., Gómez, D., & Tejada, J. (2009).
%   "Polynomial calculation of the Shapley value based on sampling."
%   Computers & Operations Research, 36(5), 1726–1730.

    n = game.n;
    v = game.v;
    phi_hat = zeros(n, 1); % initialize Shapley value estimate
    powers = 2 .^ ((n - 1):-1:0);

    % --- Sampling loop ---
    for t = 1:sampleSize
        order = randperm(n); % random permutation of players

        % Predecessor coalition (starts empty)
        coalition_bin = zeros(1, n);

        for pos = 1:n
            i = order(pos);
            % coalition before adding player i
            idx_pre = coalition_bin * powers' + 1;
            v_pre = v(idx_pre);

            % add player i
            coalition_bin(i) = 1;
            idx_post = coalition_bin * powers' + 1;
            v_post = v(idx_post);

            % marginal contribution
            phi_hat(i) = phi_hat(i) + (v_post - v_pre);
        end
    end

    % Average over samples
    phi_hat = phi_hat / sampleSize;
end
