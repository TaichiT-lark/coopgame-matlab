classdef createGame
    %{
        createGame Class - Responsible for creating a new game instance
        ---------------------------------------
        Syntax: game = createGame(n, v) or game = createGame(n)
        Input:
            n - Number of players
            v - (Optional) Value function as a vector of length 2^n
                If not provided, initializes to zeros.
        Output:
            game - An instance of the createGame class
        Methods:
            generateCoalitions - Generates the coalition structure matrix
            getValue - Retrieves the value of a specific coalition
            showCoalitions - Displays all coalitions and their values
            setValues - Sets values for specified coalitions
            setValuesFromMatrix - Sets values from a coalition binary matrix and corresponding values

        ---------------------------------------
    %}
    properties
        n % Number of players
        coalitionMat % Coalition structure matrix
        v % Value function
    end

    methods

        function obj = createGame(n, v)

            if nargin < 2
                v = zeros(2 ^ n, 1);
            end

            if length(v) ~= 2 ^ n - 1
                error('Value function length must be 2^n-1.');
            end

            obj.n = n;
            obj.v = v;
            obj.coalitionMat = obj.generateCoalitions(n);
        end

        function C = generateCoalitions(~, n)
            % coalitionMat: (2^n - 1) x n matrix
            % Ordered by number of players (1,2,...,n) and lexicographically by player index

            C = [];
            for k = 1:n
                combos = nchoosek(1:n, k);  % all k-player coalitions
                temp = zeros(size(combos,1), n);
                for i = 1:size(combos,1)
                    temp(i, combos(i,:)) = 1;
                end
                C = [C; temp]; %#ok<AGROW>
            end
        end

        function val = getValue(obj, binaryCoalition)

            if length(binaryCoalition) ~= obj.n
                error('Coalition binary vector length must match number of players.');
            end

            idx = coalition2idx(obj, find(binaryCoalition));
            val = obj.v(idx);
        end

        function showCoalitions(obj)
            fprintf('All coalitions for n = %d players:\n', obj.n);

            % calculate sizes of each coalition
            coalitionSizes = sum(obj.coalitionMat, 2);

            % Sort order: first by coalition size (ascending), then lexicographically
            [~, sortIdx] = sortrows([coalitionSizes -obj.coalitionMat]);

            % Output in sorted order
            for idx = sortIdx'
                members = find(obj.coalitionMat(idx, :));

                if isempty(members)
                    fprintf('  {} : v = %.2f\n', obj.v(idx));
                else
                    fprintf('  {%s} : v = %.2f\n', num2str(members, '%d,'), obj.v(idx));
                end

            end

        end

        function obj = setValues(obj, coalitions, values)
            % coalitions: cell array of coalitions or vector of single coalition, e.g., {[1,2], [2,3]}, [1,2]
            % values: corresponding values for the coalitions

            if isnumeric(coalitions)

                if size(coalitions, 1) > 1
                    error('For numeric input, coalitions must be a single coalition vector.');
                end

                coalitions = {coalitions};

            elseif ~iscell(coalitions)
                error('Coalitions must be a numeric vector or a cell array.');
            end

            if length(coalitions) ~= length(values)
                error('Coalitions and values must have the same length.');
            end

            for i = 1:length(coalitions)
                coalition = coalitions{i};
                value = values(i);

                if any(coalition > obj.n) || any(coalition < 1)
                    error('Coalition members must be between 1 and %d.', obj.n);
                end

                idx = coalition2idx(obj, coalition);

                obj.v(idx) = value;
            end

        end

        function obj = setValuesFromMatrix(obj, coalitionMat, values)
            % data: matrix with n columns for representing coalitions in binary form and 1 column for characteristic function values
            if size(coalitionMat, 2) ~= obj.n
                error('Coalition binary matrix must have %d columns.', obj.n);
            end

            if ~all(ismember(coalitionMat(:), [0 1]))
                error('Coalition part must be binary (0 or 1).');
            end

            powers = 2 .^ ((obj.n - 1):-1:0);
            idxs = coalitionMat * powers' + 1;

            obj.v(idxs) = values;

        end

    end

end
