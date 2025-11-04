clear;close all;clc;

%% Define subsidized game
n = 3; % Number of players
% Characteristic function values for all coalitions
% Ordered by coalition index: {1}, {2}, {3}, {1,2}, {1,3}, {2,3}, {1,2,3}
v = [0; 0; 0; 2; 6; 8; 10];
game = createGame(n, v);

game.showCoalitions();

%% Compute allocations
alpha = 0:0.1:1;

sol_original = zeros(n, length(alpha));
sol_subsidized = zeros(n, length(alpha));
tax_opt = zeros(nchoosek(n, 2), length(alpha));

for i = 1:length(alpha)
    sol_original(:, i) = egalitarianShapley(game, alpha(i));

    tax = sdpvar(nchoosek(n, 2), 1);
    game_taxed = createGame(n, v - [zeros(n, 1); tax; zeros(1, 1)]);
    objective = sum(tax);
    constraints = [
                   tax >= 0;
                   game_taxed.coalitionMat * egalitarianShapley(game_taxed, alpha(i)) >= game_taxed.v; % Core constraints
                   ];
    optimize(constraints, objective);
    tax_opt(:, i) = value(tax);
    sol_subsidized(:, i) = egalitarianShapley(game_taxed, alpha(i));

end

%% plot results
figure;
hold on;
plot(alpha, sol_original(1, :), '-', 'DisplayName', 'Original');
plot(alpha, sol_subsidized(1, :), '--', 'DisplayName', 'Taxed');
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
plot(alpha, sol_subsidized(2, :), '--', 'DisplayName', 'Taxed');
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
plot(alpha, sol_subsidized(3, :), '--', 'DisplayName', 'Taxed');
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

plot(alpha, tax_opt(1, :), 'DisplayName', sprintf('Tax on Coalition 12'));
plot(alpha, tax_opt(2, :), 'DisplayName', sprintf('Tax on Coalition 13'));
plot(alpha, tax_opt(3, :), 'DisplayName', sprintf('Tax on Coalition 23'));

hold off;
grid on;
xlabel('Alpha');
ylabel('Tax Amount');
legend('show', 'Location', 'best');
title('Optimal Tax vs Alpha');
saveas(gcf, './fig/Optimal_Tax_vs_Alpha.png');
