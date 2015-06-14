
# among other things, this file is a workaround to allow simpler
# interactive development without the need to replace Main module
# on each file reload; please, don't merge it into other files


abstract Aggregator  # aggregator of data vectors using custom logic


type VarStats
    n_obs::Int64
    min::Float64
    max::Float64
    var::Float64
    sum::Float64

    VarStats() = new(0, 0, 0, 0)
end


type StatsAggregator <: Aggregator
    
end

StatsAggregator() = StatsAggregator(Dict{Any, Vector{VarStats}}())

show(io::IO, agg::StatsAggregator) =
    print(io, "StatsAggregator($(keys(agg.groups)))")


type Index
    lookup::Dict{Symbol, Int}
    names::Vector{Symbol}    
end

function Index(names::Vector{Symbol})
    lookup = Dict{Symbol, Int}(zip(names, 1:length(names)))
    Index(lookup, names)
end


abstract GroupBy

type StatsGroupBy <: GroupBy
    index::Index
    gvars::Vector{Int}  # indexes of vars to group by
    avars::Vector{Int}  # indexes of vars to aggregate
    agg::StatsAggregator
    groupers::Dict{Symbol, Function}
end

function StatsGroupBy(names::Vector{Symbol}, groupers::Dict{Symbol, Function})
    index = Index(names)
    gnames = filter(x -> in(x, keys(groupers)), names)
    gvars = [index.lookup[name] for name in gnames]
    anames = filter(x -> !in(x, keys(groupers)), names)
    avars = [index.lookup[name] for name in anames]
    agg = StatsAggregator()
    return StatsGroupBy(index, gvars, avars, agg, groupers)
end

function StatsGroupBy(names::Vector{Symbol}, groupby::Vector{Symbol})
    return StatsGroupBy(names, Dict([(name, identity) for name in groupby]))
end

show(io::IO, grb::StatsGroupBy) =
    print(io, "StatsGroupBy($(grb.index.names),$(keys(grb.groupers)))")

