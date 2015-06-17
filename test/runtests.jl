
using IncDataStats
using Base.Test


grb = GroupBy([:a, :b, :c, :d], [:a, :c])    
update!(grb, [1, 2, 3, 4])
update!(grb, [1, 3.2, 3, 7])
update!(grb, [2, 2, 1, 4])
update!(grb, [2, 2, 7, 4])

@test mean(grb, :a) == 1.5
@test mean(grb, :b) == 2.3
@test sum(grb, :c) == 14
@test count(grb, :d) == 4

bins, h = hist(grb, :c)
@test bins == [1.0,3.0,7.0]
@test h == [1,2,1]


@test quantile(grb, :c, .25) == 1
@test quantile(grb, :c, .5) == 3
@test quantile(grb, :c, .75) == 3
@test quantile(grb, :c, .9) == 7

# groupers test

grb = GroupBy([:a, :b, :c, :d], [:a => identity, :c => stepgrouper(3)])
update!(grb, [1, 2, 3, 4])
update!(grb, [1, 3.2, 3, 7])
update!(grb, [2, 2, 1, 4])
update!(grb, [2, 2, 7, 4])
