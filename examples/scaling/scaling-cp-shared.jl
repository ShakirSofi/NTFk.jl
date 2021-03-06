import TensorDecompositions
import NTFk
import Random
import SharedArrays

Random.seed!(1)
trank = 3
for m = 1:5
	tsize = (5 * m, 10 * m, 20 * m)
	factors_orig = NTFk.rand_candecomp(trank, tsize, lambdas_nonneg=true, factors_nonneg=true)
	T = SharedArrays.SharedArray{Float64}(tsize)
	NTFk.composeshared!(T, factors_orig)
	tranks = [1, 2, 3, 4, 5]
	for t in tranks
		factors_initial_guess = tuple([randn(dim, t) for dim in tsize]...)
		@info("CP Shared Decomposition: Tensor rank $t")
		@time factors = TensorDecompositions.candecomp(T, t, factors_initial_guess; compute_error=true, method=:ALS)
		@time T_est = NTFk.composeshared(factors)
	end
end