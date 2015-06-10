
using Compat
import Base.min
import Base.max
import Base.mean
import Base.count
import Base.sum

include("groupby.jl")

typealias GroupKey @compat Tuple{Vararg{Float64}}


## type VarStats
##     n_obs::Int64
##     min::Float64
##     max::Float64
##     sum::Float64
    
##     VarStats() = new(0, 0, 0, 0)
## end



## type GroupBy
##     varnames::Vector{Symbol}
##     n2i::Dict{Symbol, Int}
##     groupvars::Vector{Int}   # indexes of vars to group by
##     aggvars::Vector{Int}     # indexes of vars to aggregate
##     groups::Dict{GroupKey, Vector{VarStats}}
## end


## function GroupBy(varnames::Vector{Symbol}, groupvarnames::Vector{Symbol})
##     n2i = Dict([(n, i) for (i, n) in enumerate(varnames)])
##     groupvars = map(name -> n2i[name], groupvarnames)
##     aggvars = filter(x -> !in(x, groupvars), [1:length(varnames)])
##     return GroupBy(varnames, n2i, groupvars, aggvars, Dict{}())
## end

## Base.show(io::IO, grb::GroupBy) =
##     print(io, "GroupBy($(grb.varnames),$(grb.varnames[grb.groupvars]))")


## groupkey(grb::GroupBy, x::Vector{Float64}) = tuple(x[grb.groupvars]...)


## function updatestats!(vs::VarStats, value::Float64)
##     vs.n_obs += 1
##     vs.sum += value
##     if value < vs.min
##         vs.min = value
##     end
##     if value > vs.max
##         vs.max = value
##     end    
## end

## function updatestats!(group::Vector{VarStats}, values::Vector{Float64})
##     for i=1:length(group)
##         updatestats!(group[i], values[i])
##     end
## end


## function updategroup!(grb::GroupBy, values::Vector{Float64})
##     key = groupkey(grb, values)    
##     if !haskey(grb.groups, key)
##         grb.groups[key] = [VarStats() for i=1:length(values)]
##     end
##     updatestats!(grb.groups[key], values)
## end


## groupkeys(grb) = keys(grb.groups)

## function mean(grb::GroupBy, gkey::@compat(Tuple{Vararg{Float64}}),
##               varname::Symbol)
##     varidx = grb.n2i[varname]
##     vs = grb.groups[gkey][varidx]
##     return vs.sum / vs.n_obs
## end




## function test_it()
##     grb = GroupBy([:a, :b, :c, :d], [:a, :c])       
##     updategroup!(grb, [1, 4.3, 2, 45])
##     updategroup!(grb, [-1, 42, 8, 3.5])
##     updategroup!(grb, [1., 17, 88, 55])
##     updategroup!(grb, [1., 2, 2, 5])
## end


