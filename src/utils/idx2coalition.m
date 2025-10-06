function coalition = idx2coalition(game, idx)
    % idx2coalition - Convert index of the coalition matrix to coalition set
    % e.g., idx: 6 -> coalition: [1 3] for n=3 players

    bin = dec2bin(idx - 1, game.n) == '1';
    coalition = find(bin);
end
