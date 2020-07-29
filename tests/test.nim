import statistics, tables

var zero: seq[int]
var t1 = @[13, 13, 13, 13, 14, 14, 16, 18, 21]
assert total(zero) == 0
assert total(@[1, 2, 3]) == 6
assert t1.total() == 135.0

assert average(zero).isNaN
assert average(@[1, 2, 3]) == 2
assert t1.average() == 15

assert median(zero).isNaN
assert median(@[1, 2, 3]) == 2
assert median(@[1, 2, 3, 4]) == 3.5
assert median(@[1, 2, 3, 4, 5]) == 3
assert t1.median() == 14

assert mode(zero).isNaN
assert mode(@[1, 2, 3, 4]) == 1
assert mode(@[1, 2, 2, 3, 3, 4, 5]) == 2
assert mode(@[1, 2, 2, 3, 3, 4, 4, 4, 5]) == 4
assert t1.mode() == 13

var mm = multiMode(@[1, 2, 2, 3, 3, 4, 5])
assert mm[2] == 2
assert mm[3] == 2
assert 1 notin mm

assert geometricMean(zero).isNaN
assert geometricMean(@[-1]).isNaN
assert geometricMean(@[54, 24, 36]) ~= 36.0

assert harmonicMean(zero).isNaN
assert harmonicMean(@[-1]).isNaN
assert harmonicMean(@[40, 60]) ~= 48.0
assert harmonicMean(@[2.5, 3, 10]) ~= 3.6


let d = @[120, 200, 250, 320, 350]
assert quantiles(d, 2) ~= @[250.0]
assert quantiles(d, 3) ~= @[200.0, 320.0]
assert quantiles(d, 4) ~= @[160.0, 250.0, 335.0]
assert quantiles(d, 5) ~= @[136.0, 220.0, 292.0, 344.0]
assert quantiles(d, 6) ~= @[120.0, 200.0, 250.0, 320.0, 350.0]
assert quantiles(d, 8) ~= @[100.0, 160.0, 212.5, 250.0, 302.5, 335.0, 357.5]
assert quantiles(d, 10) ~= @[88.0, 136.0, 184.0, 220.0, 250.0, 292.0, 326.0, 344.0, 362.0]
assert quantiles(d, 12) ~= @[80.0, 120.0, 160.0, 200.0, 225.0, 250.0, 285.0, 320.0, 335.0, 350.0, 365.0]
assert quantiles(d, 15) ~= @[72.0, 104.0, 136.0, 168.0, 200.0, 220.0, 240.0, 264.0, 292.0, 320.0, 332.0, 344.0, 356.0, 368.0]
