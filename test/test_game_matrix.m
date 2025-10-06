clear;close all;clc;

% Definition of the cooperative game
n = 3;
game = createGame(n);

coalitionMat = [% players 1, 2, 3
                0 0 0;
                1 0 0;
                0 1 0;
                0 0 1;
                1 1 0;
                1 0 1;
                0 1 1;
                1 1 1;
                ];
values = [0; 1; 1; 1; 3; 3; 2; 5];

% Set the values for the game
game = game.setValuesFromMatrix(coalitionMat, values);

% Display the game
game.showCoalitions();

%% Calculate the Shapley value
shap = shapleyValue(game)
