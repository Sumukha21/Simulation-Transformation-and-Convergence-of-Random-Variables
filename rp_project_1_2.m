distribution_types = ["normal", "uniform", "exp"];
T_values = [100, 1000, 10000];
save_path = "C:\Users\sumuk\OneDrive\Desktop\NCSU_related\Courses_and_stuff\Courses_and_stuff\NCSU_courses_and_books\ECE_514\MiniProject\results";
for i = 1: 3
    for j = 1: 3
        [mean_i, var_i] = compute_characteristics(distribution_types(i), T_values(j), save_path);
    end
end

function [mean_Y, var_Y] = compute_characteristics(distribution_type, T, save_path)
    if distribution_type == "normal"
        distribution = makedist('Normal','mu',2,'sigma',sqrt(2));
    elseif distribution_type == "uniform" 
        distribution = makedist('Uniform', "Lower", 2, "Upper", 4);
    else
        distribution = makedist('Exponential','mu', 0.5);
    end
    Y = compute_transformation(distribution, T);
    mean_Y = mean(Y);
    var_Y = var(Y);
    f = figure(1);
    histogram(Y);
    xlabel("Y")
    title("Transformation of " + distribution_type + " distribution" + " with " + string(T) + " samples");
    save_path = save_path + "/" + "Transformation of " + distribution_type + " distribution" + " with " + string(T) + " samples.png";
    exportgraphics(f, save_path, "Resolution", 600);
end

function Y = compute_transformation(source_distribution, T)
    Y = sum(source_distribution.random(T, T))/T;    
end