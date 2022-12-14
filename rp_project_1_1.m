distribution_types = ["normal", "uniform", "exp"];
save_path = "C:\Users\sumuk\OneDrive\Desktop\NCSU_related\Courses_and_stuff\Courses_and_stuff\NCSU_courses_and_books\ECE_514\MiniProject\results\1_1";
samples = 100;
for i = 1: 3
    for j = 1: 3
        [mean_i, var_i] = simulate_random_variables(distribution_types(j), samples, save_path);
        if j == 1
            [mean_r, var_r] = rejection_method_normal(samples, save_path);
        elseif j == 2
            [mean_r, var_r] = rejection_method_uniform(samples, save_path);
        else
            [mean_r, var_r] = rejection_method_exp(samples, save_path);
        end
    end
    samples = samples * 10;
end


function [mean_dist, variance_dist] = simulate_random_variables(distribution_type, number_of_samples, save_path)
    if distribution_type == "normal"
        distribution = makedist('Normal','mu',2,'sigma', sqrt(2));
    elseif distribution_type == "uniform" 
        distribution = makedist('Uniform', "Lower", 2, "Upper", 4);
    else
        distribution = makedist('Exponential','mu', 0.5);
    end
    f = figure(1);
    samples = distribution.random(number_of_samples, 1);
    histogram(samples);
    title("pdf of " + distribution_type + " distribution from matlab routine" + " with " + string(number_of_samples) + " samples");
    xlabel("Random Variable Y");
    mean_dist = mean(samples);
    variance_dist = var(samples);
    img_name = distribution_type + "_" + string(number_of_samples) + "_matlab_routine_simulation.png";
    save_path = save_path + "/" + img_name;
    exportgraphics(f, save_path, 'Resolution', 600);
end    


function [mean_dist, variance_dist] = rejection_method_normal(number_of_samples, save_path)
    peak_value = 1/(2*sqrt(pi));
    samples = zeros(number_of_samples, 1);
    for i = 1: number_of_samples
        reject = true;
        while reject
            x_axis = -5 + 14.*rand();
            y_axis = rand();
            if y_axis * peak_value <= (1/(2 * sqrt(pi))) * (exp(-(x_axis - 2)^2/(4)))
                samples(i) = x_axis;
                reject = false;
            end
        end
    end
    f = figure(1);
    histogram(samples);
    mean_dist = mean(samples);
    variance_dist = var(samples);
    title("pdf of Normal distribution from rejection method" + " with " + string(number_of_samples) + " samples");
    xlabel("Random Variable Y");
    img_name = "normal_" + string(number_of_samples) + "_rejection_method.png";
    save_path = save_path + "/" + img_name;
    exportgraphics(f, save_path, 'Resolution', 600);
end


function [mean_dist, variance_dist] = rejection_method_uniform(number_of_samples, save_path)
    peak_value = 1/2;
    samples = zeros(number_of_samples, 1);
    for i = 1: number_of_samples
        reject = true;
        while reject
            x_axis = 2 + (2).*rand();
            y_axis = rand();
            if y_axis * peak_value <= peak_value
                samples(i) = x_axis;
                reject = false;
            end
        end
    end
    f = figure(1);
    histogram(samples);
    mean_dist = mean(samples);
    variance_dist = var(samples);
    title("pdf of Uniform distribution from rejection method" + " with " + string(number_of_samples) + " samples");
    xlabel("Random Variable Y");
    img_name = "uniform_" + string(number_of_samples) + "_rejection_method.png";
    save_path = save_path + "/" + img_name;
    exportgraphics(f, save_path, 'Resolution', 600);
end


function [mean_dist, variance_dist] = rejection_method_exp(number_of_samples, save_path)
    peak_value = 2;
    samples = zeros(number_of_samples, 1);
    for i = 1: number_of_samples
        reject = true;
        while reject
            x_axis = 4.*rand();
            y_axis = rand();
            if y_axis * peak_value <= 2*exp(-2*x_axis)
                samples(i) = x_axis;
                reject = false;
            end
        end
    end
    f = figure(1);
    histogram(samples);
    mean_dist = mean(samples);
    variance_dist = var(samples);
    title("pdf of Exponential distribution from rejection method" + " with " + string(number_of_samples) + " samples");
    xlabel("Random Variable Y");
    img_name = "exp_" + string(number_of_samples) + "_rejection_method.png";
    save_path = save_path + "/" + img_name;
    exportgraphics(f, save_path, 'Resolution', 600);
end