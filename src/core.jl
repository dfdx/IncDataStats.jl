
using Docile
using Compat
import Base: minimum, maximum, mean, var, std, count, sum, hist
import Base: haskey, keys, values, show

include("varstats.jl")
include("groupby.jl")
