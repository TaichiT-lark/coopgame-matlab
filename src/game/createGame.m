classdef createGame
    %{
        createGame Class - Responsible for creating a new game instance
        ---------------------------------------

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

            obj.n = n;
            obj.v = v;
            obj.coalitionMat = obj.generateCoalitions(n);
        end

        function C = generateCoalitions(~, n)
            C = dec2bin(0:(2 ^ n) - 1) - '0';
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

            for i = 1:size(obj.coalitionMat, 1)
                members = find(obj.coalitionMat(i, :));

                if isempty(members)
                    fprintf('  {} : v = %.2f\n', obj.v(i));
                else
                    fprintf('  {%s} : v = %.2f\n', num2str(members, '%d,'), obj.v(i));
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
