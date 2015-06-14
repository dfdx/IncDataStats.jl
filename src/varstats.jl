
type VarStats
    n_obs::Int64
    min::Float64
    max::Float64
    var::Float64
    sum::Float64

    VarStats() = new(0, +Inf, -Inf, 0, 0)
end


count(vs::VarStats) = vs.n_obs
sum(vs::VarStats) = vs.sum
minimum(vs::VarStats) = vs.min
maximum(vs::VarStats) = vs.max
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

