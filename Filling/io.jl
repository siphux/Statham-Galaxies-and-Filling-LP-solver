function readInputFile(path::String)
	if isfile(path)
		myFile = open(path)
		data = readlines(myFile)
		n, m = parse(Int, data[1]), parse(Int, data[2])
		res = Matrix{Int}(undef, n, m)
		i = 1
		for line in data[3:end]
			t = parse.(Int, split(line, ","))
			res[i, :] = t
			i += 1
		end
		close(myFile)
		return res
	end
	return -1
end
