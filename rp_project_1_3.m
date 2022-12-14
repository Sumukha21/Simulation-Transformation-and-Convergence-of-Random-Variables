clc
clear all
close all
save_path = "C:\Users\sumuk\OneDrive\Desktop\NCSU_related\Courses_and_stuff\Courses_and_stuff\NCSU_courses_and_books\ECE_514\MiniProject\results\1_3";
M = 500;
N = 2000;
dsistribution_types = ["normal", "uniform", "expo"];
Y_ex = modes_of_convergence(M, N, "exp", save_path);

function transformed_X = new_transform(X)
    length_X = length(X);
    transformed_X = zeros(1, length_X);
    summation = 0;
    for i = 1: 1: length_X
        summation = summation + X(i);
        transformed_X(i) = summation/i;
    end
end

function Y = modes_of_convergence(M, N, distribution_type, save_path)
    if distribution_type == "normal"
        distribution = makedist('Normal','mu',2,'sigma',sqrt(2));
        mean_val = 2;
    elseif distribution_type == "uniform" 
        distribution = makedist('Uniform', "Lower", 2, "Upper", 4);
        mean_val = 3;
    else
        distribution = makedist('Exponential','mu', 0.5);
        mean_val = 0.5;
    end
    Y = zeros(M, N);
    f1 = figure(1);
    for i = 1: M
        X_i = distribution.random(1, N);
        Y(i, :) = new_transform(X_i);
        plot(1: N, Y(i, :))
        ylabel("X_n(w) - X(w)");
        xlabel("N: Number of samples per realization");
        title("Realizations");
        hold on
    end
    hold off
    exportgraphics(f1 ,save_path + "\realizations_M_" + string(M) + "_N_" + string(N) + "_" + distribution_type + ".png", "Resolution", 300);
    p_deviations = convergence_in_probability(Y, mean_val);
    as_deviations = almost_sure_convergence(Y, mean_val);
    ms_deviations = convergence_in_ms(Y, mean_val);
    [cdf_Y, x_range] = convergence_in_distribution(Y, mean_val);
    f2 = figure(2);
    plot(1: length(p_deviations), p_deviations, "b");
    hold on
    plot(1: length(as_deviations), as_deviations, "g");
    hold on
    plot(1: length(ms_deviations), ms_deviations, "r");
    legend("p", "as", "ms");
    xlabel("Number of samples N");
    title("Modes of Convergence");
    exportgraphics(f2,save_path + '\convergence_M_' + string(M) + '_N_' + string(N) + "_" + distribution_type + '.png','Resolution',300);
    f3 = figure(3);
    plot(x_range, cdf_Y);
    title("CDF of Y");
    exportgraphics(f3, save_path + '\cdf_M_' + string(M) + '_N_' + string(N) + "_" + distribution_type + '.png','Resolution',300);
end

function deviations = convergence_in_probability(Y, mean)
    [M, N] = size(Y);
    e = 0.05;
    deviations = zeros(N, 1);
    for i = 1: N
        deviation_count = 0;
        for j = 1: M
            if abs((Y(j, i) - mean)) > e
                deviation_count = deviation_count + 1;
            end
        end
        deviations(i) = deviation_count / M;
    end
end

function deviations = almost_sure_convergence(Y, mean)
    k = 0.5;
    [M, N] = size(Y);
    e = 0.05;
    deviations = zeros(k*N, 1);
    for i = 1: k*N
        deviation_count = 0;
        for j = 1: M
            for l = i: N
                if abs(Y(j, l) - mean) > e
                    deviation_count = deviation_count + 1;
                    break
                end
            end
        end
        deviations(i) = deviation_count / M;
    end
end

function deviations = convergence_in_ms(Y, mean)
    [M, N] = size(Y);
    deviations = zeros(1, N);
    for i = 1: N
        deviation_i = 0;
        for j = 1: M
            deviation_i = deviation_i + ((Y(j, i) - mean)^2);
        end
        deviations(1, i) = deviation_i / M;
    end
end

function [cdf, x_range] = convergence_in_distribution(Y, mean)
    t = mean - 1: 0.00001: mean + 1;
    [M, N] = size(Y);
    x_range = t;
    cdf = zeros(1, length(t));
    for i = 1: length(t)
        cdf_i = 0;
        for j = 1: M
            if Y(j, N) <= t(i)
                cdf_i = cdf_i + 1;
            end
        end
        cdf(1, i) = cdf_i / M;
    end
end
