
count(vs::VarStats) = vs.n_obs
sum(vs::VarStats) = vs.sum
min(vs::VarStats) = vs.min
max(vs::VarStats) = vs.max
mean(vs::VarStats) = vs.sum / vs.n_obs
var(vs::VarStats) = vs.var
std(vs::VarStats) = sqrt(vs.var)


function updatestats!(vs::VarStats, value::Real)
    vs.n_obs += 1
    vs.sum += value
    if value < vs.min
        vs.min = value
    end
    if value > vs.max
        vs.max = value
    end
    if vs.n_obs > 2
        n = vs.n_obs
        vs.var = (n - 2) / (n - 1) * vs.n_obs + 1 / n * (value - mean(vs))^2
    end
end


function updatestats!{T<:Real}(varstats::Vector{VarStats}, values::Vector{T})
    for i=1:length(varstats)
        updatestats!(varstats[i], values[i])
    end
end


function aggregate!{K,N<:Number}(agg::StatsAggregator{K},
                               key::K, values::Vector{N})
    if !haskey(agg.groups, key)
        # init new varstats group to the length of first incoming values
        agg.groups[key] = [VarStats() for i=1:length(values)]
    end
    updatestats!(agg.groups[key], values)
end

keys(agg::StatsAggregator) = keys(agg.groups)
values(agg::StatsAggregator) = values(agg.groups)
getindex{K}(agg::StatsAggregator{K}, k::K) = getindex(agg.groups, k)

