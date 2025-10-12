clear; close all; clc;

%% Define game
n = 3; % Number of players

% Characteristic function values for all coalitions
% Ordered by coalition index: {1}, {2}, {3}, {1,2}, {1,3}, {2,3}, {1,2,3}
v = [0; 0; 0; 60; 60; 72; 120]; 
game = createGame(n, v);
game.showCoalitions();

%% Properties confirmation
isConvex = isconvex(game);
disp(['Is the game convex? ', num2str(isConvex)]);
isSuperAdditive = issuperadditive(game);
disp(['Is the game superadditive? ', num2str(isSuperAdditive)]);

%% Compute Shapley values
[shap, matrix] = shapleyValue(game);
shap

