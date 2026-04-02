using JuMP
using CPLEX


function cplexSolve(board::Matrix)
	Ti = time()
	model = Model(CPLEX.Optimizer)
	n, m = size(board)
	K = 9

	@variable(model, x[1:n, 1:m, 1:K], Bin)
	
	for i in 1:n
		for j in 1:m
			if board[i, j] != -1
				@constraint(model, x[i, j, board[i,j]] == 1)
			end
		end
	end

	@constraint(model, [i in 1:n, j in 1:m], sum(x[i, j, k] for k in 1:K) == 1)
	
	@objective(model, Min, 42)
	
	set_time_limit_sec(model, 60.0)
	optimize!(model)
	isOptimal = termination_status(model) == MOI.OPTIMAL
	solutionFound = primal_status(model) == MOI.FEASIBLE_POINT
	Tf = time() - Ti

	if solutionFound
		res = Matrix{Int}(undef, n, m)
        	for i in 1:n, j in 1:m, k in 1:K
            		if value(x[i,j,k]) > 0.5
                		res[i,j] = k
			end
		end
		return (solution = res, time_taken = Tf, sol_var = x, optimality = isOptimal)
	else
		println("solution not found")
		return (solution = nothing, time_taken = Tf, sol_var = x, optimality = false)
	end
end
