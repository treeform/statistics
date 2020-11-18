import statistics, tables, strformat, math

var emptySeq: seq[int]
var t1 = @[13, 13, 13, 13, 14, 14, 16, 18, 21]
assert total(emptySeq) == 0
assert total(@[1, 2, 3]) == 6
assert t1.total() == 135.0

assert mean(emptySeq).isNaN
assert mean(@[1, 2, 3]) == 2
assert t1.mean() == 15

assert median(emptySeq).isNaN
assert median(@[1, 2, 3]) == 2
assert median(@[1, 2, 3, 4]) == 3.5
assert median(@[1, 2, 3, 4, 5]) == 3
assert t1.median() == 14

assert mode(emptySeq).isNaN
assert mode(@[1, 2, 3, 4]) == 1
assert mode(@[1, 2, 2, 3, 3, 4, 5]) == 2
assert mode(@[1, 2, 2, 3, 3, 4, 4, 4, 5]) == 4
assert t1.mode() == 13

var mm = multiMode(@[1, 2, 2, 3, 3, 4, 5])
assert mm[2] == 2
assert mm[3] == 2
assert 1 notin mm

assert geometricMean(emptySeq).isNaN
assert geometricMean(@[-1]).isNaN
assert geometricMean(@[54, 24, 36]) ~= 36.0

assert harmonicMean(emptySeq).isNaN
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
assert quantiles(d, 10) ~= @[88.0, 136.0, 184.0, 220.0, 250.0, 292.0, 326.0,
    344.0, 362.0]
assert quantiles(d, 12) ~= @[80.0, 120.0, 160.0, 200.0, 225.0, 250.0, 285.0,
    320.0, 335.0, 350.0, 365.0]
assert quantiles(d, 15) ~= @[72.0, 104.0, 136.0, 168.0, 200.0, 220.0, 240.0,
    264.0, 292.0, 320.0, 332.0, 344.0, 356.0, 368.0]

assert variance(emptySeq) == 0
assert variance(@[1]) == 0
assert variance(@[1.13]) == 0
assert variance(@[600, 470, 170, 430, 300]) ~= 27130.0

assert pvariance(emptySeq) == 0
assert pvariance(@[1]) == 0
assert pvariance(@[1.13]) == 0
assert pvariance(@[600, 470, 170, 430, 300]) ~= 21704.0

assert stdev(emptySeq) == 0
assert stdev(@[1]) == 0
assert stdev(@[1.13]) == 0
assert stdev(@[600, 470, 170, 430, 300]) ~= 164.7118696390761

assert pstdev(emptySeq) == 0
assert pstdev(@[1]) == 0
assert pstdev(@[1.13]) == 0
assert pstdev(@[600, 470, 170, 430, 300]) ~= 147.3227748856232

assert newNormalDistribution(0, 1.0).mu == 0
assert newNormalDistribution(0, 1.0).sigma == 1.0

let n = newNormalDistribution(@[600, 470, 170, 430, 300])
assert n.mu ~= 394.0
assert n.sigma ~= 164.7118696390761

assert n.pdf(0) ~= 0.00013857457125276553
assert n.pdf(-1) ~= 0.00013657412437019452
assert n.pdf(1) ~= 0.00014059913683141543
assert n.pdf(1000) ~= 2.7851304298770717e-06

assert n.cdf(0) ~= 0.008377145133081743
assert n.cdf(-1) ~= 0.008239572786750249
assert n.cdf(1) ~= 0.008516729968818193
assert n.cdf(1000) ~= 0.9998829946017129

assert n.invCdf(0.001) ~= -114.99794076797434
assert n.invCdf(0.25) ~= 282.90353219280996
assert n.invCdf(0.5) ~= 394.0
assert n.invCdf(0.999) ~= 902.9979407679743

assert n.quantiles(0) ~= @[]
assert n.quantiles(1) ~= @[]
assert n.quantiles(2) ~= @[394.0]
assert n.quantiles(3) ~= @[323.0541012284553, 464.94589877154465]
assert n.quantiles(4) ~= @[282.90353219280996, 394.0, 505.09646780719004]
assert n.quantiles(10) ~= @[182.91324560026382, 255.37499309025975,
    307.6250111121685, 352.2707249748586, 394.0, 435.7292750251414,
    480.3749888878315, 532.6250069097403, 605.0867543997362]

let a = newNormalDistribution(2.4, 1.6)
let b = newNormalDistribution(3.2, 2.0)

assert a.overlap(b) ~= 0.8035050657330205
assert b.overlap(a) ~= 0.8035050657330205

assert (a + b).mu ~= 5.6
assert (a + b).sigma ~= 2.5612496949731396

assert (a - b).mu ~= -0.8
assert (a - b).sigma ~= 2.5612496949731396

assert (a * 2).mu ~= 4.8
assert (a * 2).sigma ~= 3.2

assert (a / 2).mu ~= 1.2
assert (a / 2).sigma ~= 0.8

block:
  # z-test
  assert zScore(469, 119, 650) ~= 1.521008403361344
  let nd = newNormalDistribution(66.01624559725403, 2.889791503580723)
  assert nd.zScore(67.440471) ~= 0.492847
  assert nd.zScore(65.599034) ~= -0.144374
  assert nd.zScore(67.878297) ~= 0.644355
  assert nd.zScore(70.416787) ~= 1.522788
  assert nd.zScore(65.320955) ~= -0.240602
  let
    a = @[1.0, 2.0, 3.0, 4.0]
    b = @[2.0, 3.0, 4.0, 5.0]
  assert zScore(a, a) ~= 0
  assert zScore(a, b) ~= 0.7745966
  assert 1 - zScore(a, b).zScoreToPValue ~= 0.780710

  let
    muA = 60.0
    muB = 62.0
    sigmaA = 40.0
    sigmaB = 45.0
    numA = 6000.0
    numB = 4000.0

  let
    z = zScore(muA, muB, sigmaA, sigmaB, numA, numB)
  assert z ~= 2.2749070654279993
  assert z.zScoreToPValue ~= 0.011455752709549046

block display:
  echo "Normal Distribution"
  let n = newNormalDistribution(0, 1)
  for i in -30 .. 30:
    let x = i.float/10.0
    var s = ""
    for j in 0 .. (n.pdf(x) * 100).int:
      s.add "*"
    echo &"{x:>10} ", s

block display:
  echo "Student's t-distribution"
  let d = TDistribution(mu: 0, sigma: 1, df: 1)
  for i in -30 .. 30:
    let x = i.float/10.0
    var s = ""
    for j in 0 .. (d.pdf(x) * 100).int:
      s.add "*"
    echo &"{x:>10} ", s

block integration:
  func tt(x: float): float =
    TDistribution(mu: 0, sigma: 1, df: 1).pdf(x)
  let xStart = -1E10
  let xEnd = 0.0
  assert integrate(tt, xStart, xEnd) ~= 0.5

  let d1 = TDistribution(mu: 0, sigma: 1, df: 1)
  let d3 = TDistribution(mu: 0, sigma: 1, df: 3)

  assert d1.pdf(0)  ~= 0.31830988618379075
  assert d1.pdf(1)  ~= 0.15915494309189537
  assert d1.pdf(-1) ~= 0.15915494309189537
  assert d1.pdf(PI) ~= 0.029284403961554437
  assert d3.pdf(0)  ~= 0.36755259694786135
  assert d3.pdf(1)  ~= 0.20674833578317203
  assert d3.pdf(-1) ~= 0.20674833578317203
  assert d3.pdf(PI) ~= 0.019972462315558128

  assert d1.cdf(0)  ~= 0.5
  assert d1.cdf(1)  ~= 0.7500000000000002
  assert d1.cdf(-1) ~= 0.24999999999999978
  assert d1.cdf(PI) ~= 0.9019067380477064
  assert d3.cdf(0)  ~= 0.5
  assert d3.cdf(1)  ~= 0.8044988905221148
  assert d3.cdf(-1) ~= 0.19550110947788527
  assert d3.cdf(PI) ~= 0.9742000757096718


block integration:

  let d1 = TDistribution(mu: 0, sigma: 1, df: 1)
  let d3 = TDistribution(mu: 0, sigma: 1, df: 3)

  assert d1.sf(0) * 2 ~= 1.0
  assert d1.sf(1) * 2 ~= 0.5
  assert d1.sf(-1) * 2 ~= 1.5
  assert d1.sf(-1) * 2 ~= 1.5
  assert d1.sf(PI) * 2 ~= 0.1961865239045873

  assert d3.sf(0) * 2 ~= 1.0
  assert d3.sf(1) * 2 ~= 0.39100221895577053
  assert d3.sf(-1) * 2 ~= 1.6089977810442295
  assert d3.sf(PI) * 2 ~= 0.051599848580656235

  assert d3.pValue(0)  ~= 1.0
  assert d3.pValue(1)  ~= 0.39100221895577053
  assert d3.pValue(-1) ~= 1.6089977810442295
  assert d3.pValue(PI) ~= 0.051599848580656235


block power:

  assert powerForProportion(
    nA=1000,
    nB=1020,
    pA=0.65,
    pB=0.85,
    kappa=1,
    alpha=0.05,
    beta=0.20
  ) ~= 1.0

  assert powerForProportion(
    nA=1000,
    nB=1001,
    pA=0.650,
    pB=0.651,
    kappa=1,
    alpha=0.05,
    beta=0.20
  ) ~= 0.050257

  assert powerForRate(
    nA = 1000,
    nB = 1001,
    muA=10.2,
    muB=10.1,
    kappa=1,
    sd=10,
    alpha=0.05,
    beta=0.20,
  ) ~= 0.05575302

  assert powerForRate(
    nA = 5000,
    nB = 5001,
    muA=30.2,
    muB=30.1,
    kappa=1,
    sd=10,
    alpha=0.05,
    beta=0.20,
  ) ~= 0.07910344


block:
  let
    nA = 5_407_800
    nB = 5_324_140

    nPA = 901_220
    nPB = 904_004

    alpha = 0.05

  # proportional z test
  echo proportionalZTestPValue(nPA / nA, nPB / nB, nA.float, nB.float)

block:
  let
    nA = 5_407_800
    nB = 5_324_140

    nPA = 5_312_870
    nPB = 5_004_799

    alpha = 0.05

  # proportional z test
  echo proportionalZTestPValue(nPA.float / nA.float, nPB.float / nB.float, nA.float, nB.float)