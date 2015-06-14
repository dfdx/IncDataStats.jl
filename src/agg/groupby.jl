

function updategroup!{N<:Number}(grb::GroupBy, values::Vector{N})
    aggregate!(grb.agg, values[grb.gvars], values[grb.avars])    
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



function min(grb::StatsGroupBy, name::Symbol)
    ks = keys(grb.agg.groups)
    idx = grb.index.lookup[name]
    return minimum([min(grb.agg.groups[k][idx]) for k in ks])
end



function do_test()
    grb = StatsGroupBy([:a, :b, :c, :d], [:a, :c])
    aggregate!(grb.agg, [1, 3], [2, 4])
    updategroup!(grb, [1, 2, 3, 4])
    updategroup!(grb, [1, 3.2, 3, 7])
    updategroup!(grb, [2, 2, 1, 4])
end

