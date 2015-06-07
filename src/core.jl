
using Compat

typealias GroupKey @compat Tuple{Vararg{Float64}}

## type GroupStats
##     n_obs::Int64
##     min::Float64
##     max::Float64
##     sum::Float64
    
##     GroupStats() = new(0, 0, 0, 0)
## end

type VarStats
    n_obs::Int64
    min::Float64
    max::Float64
    sum::Float64
    
    VarStats() = new(0, 0, 0, 0)
end



type GroupBy
    varnames::Vector{Symbol}
    n2i::Dict{Symbol, Int}
    groupvars::Vector{Int}   # indexes of vars to group by
    aggvars::Vector{Int}     # indexes of vars to aggregate
    groups::Dict{GroupKey, Vector{VarStats}}
end


function GroupBy(varnames::Vector{Symbol}, groupvarnames::Vector{Symbol})
    n2i = Dict([(n, i) for (i, n) in enumerate(varnames)])
    groupvars = map(name -> n2i[name], groupvarnames)
    aggvars = filter(x -> !in(x, groupvars), [1:length(varnames)])
    return GroupBy(varnames, n2i, groupvars, aggvars, Dict{}())
end

Base.show(io::IO, grb::GroupBy) =
    print(io, "GroupBy($(grb.varnames),$(grb.varnames[grb.groupvars]))")


groupkey(grb::GroupBy, x::Vector{Float64}) = tuple(x[grb.groupvars]...)


function updatestats!(gs::VarStats, xagg::Vector{Float64})
    
end


function updategroup!(grb::GroupBy, x::Vector{Float64})
    key = groupkey(grb, x)
    xagg = x[grb.aggvars]
    if !haskey(grb.groups, key)
        grb.groups[key] = VarStats()
    end
    updatestats!(grb.groups[key], xagg)
end
