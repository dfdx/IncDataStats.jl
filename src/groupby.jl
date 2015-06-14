
type Index
    lookup::Dict{Symbol, Int}
    names::Vector{Symbol}    
end

function Index(names::Vector{Symbol})
    lookup = Dict{Symbol, Int}(zip(names, 1:length(names)))
    Index(lookup, names)
end


type GroupBy 
    index::Index
    gvars::Vector{Int}          # indexes of vars to group by
    groups::Dict{Any, Vector{VarStats}}
    groupers::Dict{Symbol, Function}
end

function GroupBy(names::Vector{Symbol}, groupers::Dict{Symbol, Function})
    index = Index(names)
    gnames = filter(x -> in(x, keys(groupers)), names)
    gvars = [index.lookup[name] for name in gnames]    
    return GroupBy(index, gvars, Dict{Any, Vector{VarStats}}(), groupers)
end

function GroupBy(names::Vector{Symbol}, groupby::Vector{Symbol})
    return GroupBy(names, Dict([(name, identity) for name in groupby]))
end

show(io::IO, grb::GroupBy) =
    print(io, "GroupBy($(grb.index.names),$(keys(grb.groupers)))")


function update!{T<:Real}(grb::GroupBy, values::Vector{T})
    key = values[grb.gvars]
    if !haskey(grb.groups, key)
        # init new varstats group to the length of first incoming values
        grb.groups[key] = [VarStats() for i=1:length(values)]
    end
    updatestats!(grb.groups[key], values)
end


function minimum(grb::GroupBy, name)
    idx = grb.index.lookup[name]
    minimum([minimum(grb.groups[k][idx]) for k in keys(grb.groups)])
end

function maximum(grb::GroupBy, name)
    idx = grb.index.lookup[name]
    maximum([maximum(grb.groups[k][idx]) for k in keys(grb.groups)])
end

function sum(grb::GroupBy, name::Symbol)
    idx = grb.index.lookup[name]    
    sum([sum(grb.groups[k][idx]) for k in keys(grb.groups)])
end

function count(grb::GroupBy, name::Symbol)
    idx = grb.index.lookup[name]
    sum([count(grb.groups[k][idx]) for k in keys(grb.groups)])
end

function mean(grb::GroupBy, name::Symbol)
    sum(grb, name) / count(grb, name)
end


function hist_from_counts{T<:Real}(counts::Dict{T, Int})
    sum_counts = Dict(zip(keys(counts), zeros(Int, length(counts))))
    for (v, c) in counts
        sum_counts[v] += c
    end
    sorted_counts = sort([(v, c) for (v, c) in sum_counts], by=b->b[1])
    bins = [v for (v, c) in sorted_counts]
    counts = [v for (v, c) in sorted_counts]
    return bins, counts
end


function hist(grb::GroupBy, name::Symbol)
    idx = grb.index.lookup[name]
    @assert in(idx, grb.gvars) "Can only build histogram on grouper variables"
    gidx = findin(grb.gvars, idx)[1]
    counts = Dict{Float64, Int}([(k[gidx], count(vss[idx]))
                                 for (k, vss) in grb.groups])
    return hist_from_counts(counts)
end


function quantile(grb::GroupBy, name::Symbol, q::Real)
    (bins, h) = hist(grb, name)
    qs = q * sum(h)
    
    

end

function do_test()
    grb = GroupBy([:a, :b, :c, :d], [:a, :c])    
    update!(grb, [1, 2, 3, 4])
    update!(grb, [1, 3.2, 3, 7])
    update!(grb, [2, 2, 1, 4])
    update!(grb, [2, 2, 7, 4])
end


