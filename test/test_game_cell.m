clear;close all;clc;

% Definition of the cooperative game
n = 4;
game = createGame(n);

coalition = {
             {[], 0};
             {[1], 1};
             {[2], 1};
             {[3], 1};
             {[4], 1};
             {[1, 2], 3};
             {[1, 3], 3};
             {[1, 4], 3};
             {[2, 3], 2};
             {[2, 4], 2};
             {[3, 4], 2};
             {[1, 2, 3], 5};
             {[1, 2, 4], 5};
             {[1, 3, 4], 5};
             {[2, 3, 4], 4};
             {[1, 2, 3, 4], 6};
             };

for k = 1:length(coalition)
    game = game.setValues(coalition{k}{1}, coalition{k}{2});
end

% Display the game
game.showCoalitions();
