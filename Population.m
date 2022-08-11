classdef Population
    %   A population of genomes that can perform
    %   crossover, mutation, sorting and plotting training curve
    

    properties
        popSize
        sideLength
        mutationRate
        group
        fitness
        allSpeeds
    end
    

    methods
        function obj = Population(popSize, sideLength)
            %POPULATION Construct an instance of this class
            obj.popSize = popSize;
            obj.sideLength = sideLength;
            obj.mutationRate = 1.5 / sideLength ^ 3;
            obj.group = obj.generateGroup();
            obj.fitness = obj.group{1, 2};
            obj.allSpeeds = cell2mat(obj.group(:, 2));
            disp('population generated')
        end
        

        function group = generateGroup(obj)
            %   Make an array of cells with size (popSize x 2)
            %   with genomes in first column and speed in second column
            group = cell(obj.popSize, 2);
            genomes = randi(3, [obj.popSize, obj.sideLength, obj.sideLength, obj.sideLength]) - 1;
            speeds = zeros(obj.popSize, 1);
            parfor i = 1 : obj.popSize
                sim = Simulation(genomes(i, :, :, :));
                speeds(i) = sim.evaluate();
            end
            for i = 1:obj.popSize
                group{i, 1} = squeeze(genomes(i, :, :, :));
                group{i, 2} = speeds(i);
            end
            group = sortrows(group, 2, "descend");
        end
        
        
        function obj = insertSortSelect(obj, newChildren, newSpeeds)
            %   Sort new generated genomes into the population by speeds
            %   and keep the top popSize of genomes
            nNew = length(newSpeeds);
            for i = 1:nNew
                obj.group{obj.popSize+i, 1} = squeeze(newChildren(i, :, :, :));
                obj.group{obj.popSize+i, 2} = newSpeeds(i);
            end
            obj.group = sortrows(obj.group, 2, "descend");
            obj.group = obj.group(1:obj.popSize, :);
            obj.allSpeeds(:, end + 1) = cell2mat(obj.group(:, 2));
        end

        
        function child = crossover(obj,parent1,parent2)
            %   Crossover two genomes

            %swap parent1 and parent2by prob:
            if rand(1) < 0.5
                temp = parent1;
                parent1 = parent2;
                parent2 = temp;
            end
            
            %crossover
            child = parent1;
            orient = randi(3);
            index = randi(obj.sideLength);
            if index > 1
                if orient == 1
                    child(index:end, :, :) = parent2(index:end, :, :);
                elseif orient == 2
                    child(:, index:end, :) = parent2(:, index:end, :);
                else
                    child(:, :, index:end) = parent2(:, :, index:end);
                end
            end
        end
        

        function genome = mutate(obj, genome)
            %   Mutate one genome
            for i = 1:obj.sideLength
                for j = 1:obj.sideLength
                    for k = 1:obj.sideLength
                        if rand(1) < obj.mutationRate
                            genome(i, j, k) = randi(3) - 1;
                        end
                    end
                end
            end
        end
        

        function obj = plotCurve(obj)
            %   Plot the training curve with individual speeds
            iteration = size(obj.allSpeeds, 2);
            iterationAxis = 1 : iteration;
            figure(1)
            plot(iterationAxis, obj.allSpeeds(1, :), 'b')
            hold on
            title('Fitness Curve')
            xlabel('Iteration')
            ylabel('Velocity on X Direction')
            grid on
            for i = 1:iteration
                plot(ones(obj.popSize, 1) * i, obj.allSpeeds(:, i), 'k.')
            end
            hold off
        end


        function obj = save(obj)
            %   Save the current genomes and speeds of population
            popGroup = obj.group;
            disp('logging')
            save saved_population/population.mat popGroup
        end
    end
end

