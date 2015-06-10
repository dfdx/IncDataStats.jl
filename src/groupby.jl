
type VarStats
    n_obs::Int64
    min::Float64
    max::Float64
    sum::Float64

    VarStats() = new(0, 0, 0, 0)
end


## type Index
##     lookup::Dict{Symbol, Int}
##     names::Vector{Symbol}
## end


type Aggregator
    # index::Index
    groups::Dict{Vector{Any}, Vector{VarStats}}
    Aggregator() = new(Dict())
end


function updatestats!(vs::VarStats, value::Real)
    vs.n_obs += 1
    vs.sum += value
    if value < vs.min
        vs.min = value
    end
    if value > vs.max
        vs.max = value
    end    
end


function updatestats!{T<:Real}(varstats::Vector{VarStats},
                                 values::Vector{T})
    for i=1:length(varstats)
        updatestats!(varstats[i], values[i])
    end
end


function aggregate!{T<:Real}(agg::Aggregator,
                               gkey::Vector{Any}, values::Vector{T})
    if !haskey(agg.groups, gkey)
        # init new varstats group to the length of first incoming values
        agg.groups[gkey] = [VarStats() for i=1:length(values)]
    end
    updatestats!(agg.groups[gkey], values)
end



# usage:
#  grb = GroupBy(names=[:a, :b, :c, :d],
#                groupers={Symbol, Function}[:b => identity, :d => stepfun(0.1)])
#  updategroup!(grb, [1, 74, 2, .33])
#  grb2 = where(grb, ??)
#  histogram(grb, :d)  ==> 1) find all groups; 2) get corresponding gkey values and n_obs from first VarStats
