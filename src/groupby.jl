
using Docile

type VarStats
    n_obs::Int64
    min::Float64
    max::Float64
    sum::Float64

    VarStats() = new(0, 0, 0, 0)
end


type Aggregator
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


function updatestats!{T<:Real}(varstats::Vector{VarStats}, values::Vector{T})
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


type Index
    names::Vector{Symbol}
    lookup::Dict{Symbol, Int}
    Index(names::Vector{Symbol}) =
        Index(names, Dict([(n, i) for (i, n) in enumerate(names)]))
end


@doc """
Create grouper that adjusts value to the nearest multiple of step.
Usage:
    grouper = stepgrouper(5)
    grouper(75) ==> 75
    grouper(78) ==> 80
    grouper(80) ==> 80
""" ->
function stepgrouper(step::Float64)
    function grouper(value)
        round(value / step) * step
    end
    return grouper
end


type GroupBy
    vindex::Index
    gindex::Index
    aindex::Index
    agg::Aggregator
end


@doc "Object for incremental grouping by some vars and aggreating the others" ->
function GroupBy(names::Vector{Symbol}, groupers::Dict{Symbol, Function})
    gkeys = keys(groupers)
    gvars = filter(x -> in(x, gkeys), names)
    avars = filter(x -> !in(x, gkeys), names)
    vindex = Index(names)
    gindex = Index(gvars)
    aindex = Index(avars)
    return GroupBy(vindex, gindex, aindex, Aggregator())
end

function GroupBy(names::Vector{Symbol}, groupfields::Vector{Symbol})
    # shortcut with all groupers set to identity()
end

function getgroup(grb::GroupBy, values::Vector{Float64})
    # select needed vars
    # run groupers on each of them
end
    

function getagg(grb::GroupBy, values::Vector{Float64})
    
end

function updategroup!(grb::GroupBy, values::Vector{Float64})
    # get group
    # get aggregation vars
    # run aggregator
end


# usage:
#  grb = GroupBy(names=[:a, :b, :c, :d],
#                groupers={Symbol, Function}[:b => identity, :d => stepfun(0.1)])
#  updategroup!(grb, [1, 74, 2, .33])
#  grb2 = where(grb, ??)
#  histogram(grb, :d)  ==> 1) find all groups; 2) get corresponding gkey values and n_obs from first VarStats
