clear;close all;clc;

%% Define subsidized game
n = 3; % Number of players
% Characteristic function values for all coalitions
% Ordered by coalition index: {1}, {2}, {3}, {1,2}, {1,3}, {2,3}, {1,2,3}
v = [0; 0; 0; 2; 6; 8; 10];
game = createGame(n, v);

game.showCoalitions();

%% Compute allocations
alpha = 0:0.05:1;

sol_original = zeros(n, length(alpha));
sol_subsidized = zeros(n, length(alpha));
subsidy_opt = zeros(1, length(alpha));

for i = 1:length(alpha)
    sol_original(:, i) = egalitarianShapley(game, alpha(i));

    subsidy = sdpvar(1, 1);
    game_subsidized = createGame(n, v + [zeros(2 ^ n - 2, 1); subsidy]);
    objective = subsidy;
    constraints = [
                   subsidy >= 0;
                   game_subsidized.coalitionMat * egalitarianShapley(game_subsidized, alpha(i)) >= game_subsidized.v; % Core constraints
                   ];
    optimize(constraints, objective);
    subsidy_opt(i) = value(subsidy);
    sol_subsidized(:, i) = egalitarianShapley(game_subsidized, alpha(i));

end

%% Plot results
figure;
hold on;
plot(alpha, sol_original(1, :), '-', 'DisplayName', 'Original');
plot(alpha, sol_subsidized(1, :), '--', 'DisplayName', 'Subsidized');
hold off;
grid on;
ylim([0 5]);
xlabel('Alpha');
ylabel('Allocation');
legend('show', 'Location', 'best');
title('Allocation vs Alpha for Player 1');
saveas(gcf, './fig/Player1_Allocation_vs_Alpha.png');

figure;
hold on;
plot(alpha, sol_original(2, :), '-', 'DisplayName', 'Original');
plot(alpha, sol_subsidized(2, :), '--', 'DisplayName', 'Subsidized');
hold off;
grid on;
ylim([0 5]);
xlabel('Alpha');
ylabel('Allocation');
legend('show', 'Location', 'best');
title('Allocation vs Alpha for Player 2');
saveas(gcf, './fig/Player2_Allocation_vs_Alpha.png');

figure;
hold on;
plot(alpha, sol_original(3, :), '-', 'DisplayName', 'Original');
plot(alpha, sol_subsidized(3, :), '--', 'DisplayName', 'Subsidized');
hold off;
grid on;
ylim([0 5]);
xlabel('Alpha');
ylabel('Allocation');
legend('show', 'Location', 'best');
title('Allocation vs Alpha for Player 3');
saveas(gcf, './fig/Player3_Allocation_vs_Alpha.png');

figure;
hold on;
plot(alpha, subsidy_opt, '-', 'DisplayName', 'Optimal Subsidy');
hold off;
grid on;
xlabel('Alpha');
ylabel('Subsidy Amount');
legend('show', 'Location', 'best');
title('Optimal Subsidy vs Alpha');
saveas(gcf, './fig/Optimal_Subsidy_vs_Alpha.png');
