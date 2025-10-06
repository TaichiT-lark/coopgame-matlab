function idx = coalition2idx(game, coalition)
    % coalition2idx - Convert coalition set to index of the corresponding index in the coalition matrix
    % e.g., coalition: [1 3] -> idx: 6 for n=3 players

    idx = sum(2 .^ (game.n - coalition)) + 1;
end
