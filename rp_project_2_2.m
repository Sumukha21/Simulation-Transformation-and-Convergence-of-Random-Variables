cov_mat = [11/144, -1/96
           -1/96, 73/960];
s_size = 1000;
v_dim = 2;
expectation = [7/12, 5/8];
X_s = generate_constrained_vector(cov_mat, s_size, v_dim, expectation);
cov_X_s = cov(X_s);

function X_s = generate_constrained_vector(covariance_matrix, sample_size, vector_dimension, mean)
X = randn(sample_size, vector_dimension);
[eigen_vectors, eigen_matrix] = eig(covariance_matrix);
eigen_vectors_transposed = eigen_vectors.';
chalf = eigen_vectors * sqrt(eigen_matrix) * eigen_vectors_transposed;
X_s = X * chalf + mean;
end

