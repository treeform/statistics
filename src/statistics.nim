import algorithm, math, tables

proc isNaN*(v: float): bool =
  ## Is the current float a Nan or Inf.
  v.classify in {fcNaN, fcInf}

proc `~=`*(a, b: float): bool =
  ## Are the floats kind of equal?
  abs(a - b) < 1E-5

proc `~=`*(a, b: seq[float]): bool =
  ## Are the sequences of floats kind of equal?
  if a.len != b.len:
    return false
  else:
    for i in 0 ..< a.len:
      if abs(a[i] - b[i]) > 1E-5:
        return false
  return true

proc total*(s: seq[SomeNumber]): float =
  ## Computes total of a sequence.
  for v in s:
    result += v.float

# TODO maybe rename to mean?
proc mean*(s: seq[SomeNumber]): float =
  ## Computes mean (average) of a sequence.
  if s.len == 0: return NaN
  s.total / s.len.float

proc median*(s: seq[SomeNumber]): float =
  ## Computes the median.
  if s.len == 0: return NaN
  let s2 = s.sorted()
  if s.len mod 2 == 1:
    s2[s.len div 2].float
  else:
    s2[s.len div 2].float * 0.5 + s2[s.len div 2 + 1].float * 0.5

proc mode*(s: seq[SomeNumber]): float =
  ## Computes the mode of a sequence.
  if s.len == 0: return NaN
  var table: CountTable[float]
  for v in s:
    table.inc(v.float)
  table.largest().key

proc multiMode*(s: seq[SomeNumber]): CountTable[float] =
  ## Returns all modes of > 1.
  var table: CountTable[float]
  for v in s:
    table.inc(v.float)
  for k, v in pairs(table):
    if v > 1:
      result[k] = v

proc map*(s: seq[SomeNumber], fn: proc(v: float): float): seq[float] =
  ## Maps a function onto a sequence of floats.
  result = newSeq[float](s.len)
  for i, v in s:
    result[i] = fn(v.float)

proc geometricMean*(s: seq[SomeNumber]): float =
  ## Computes the geometric mean of a sequence.
  exp(mean(s.map(ln)))

proc harmonicMean*(s: seq[SomeNumber]): float =
  ## Computes the harmonic mean (subcontrary mean) of a sequence.
  if s.len == 0: return NaN
  let s2 = s.map(proc(x: float): float =
    if x < 0: NaN
    else: 1/x
  )
  s2.len.float/s2.total

proc quantiles*(s: seq[SomeNumber], n = 4): seq[float] =
  ## Divide the s into N regions with equal probability.
  if s.len < 2:
    return
  let s = s.sorted()
  let m = s.len + 1
  for i in 1 ..< n:
    var j = i * m div n
    if j < 1:
      j = 1
    else:
      if j > s.len - 1:
        j = s.len - 1
    let
      delta = i*m - j*n
      interpolated = (
        s[j-1].float * (n - delta).float + s[j].float * delta.float
      ) / n.float
    result.add(interpolated)

proc variance*(s: seq[SomeNumber]): float =
  ## Computes the sample variance of a sequence.
  if s.len <= 1:
    return
  let a = s.mean()
  for v in s:
    result += (v.float - a) ^ 2
  result /= (s.len.float - 1)

proc pvariance*(s: seq[SomeNumber]): float =
  ## Computes the population variance of a sequence.
  if s.len <= 1:
    return
  let a = s.mean()
  for v in s:
    result += (v.float - a) ^ 2
  result /= s.len.float

proc stdev*(s: seq[SomeNumber]): float =
  ## Computes the sample standard deviation of a sequence.
  sqrt(s.variance)

proc pstdev*(s: seq[SomeNumber]): float =
  ## Computes the population standard deviation of a sequence.
  sqrt(s.pvariance)

type NormalDistribution* = object
  mu*: float    # Mean.
  sigma*: float # Standard deviation.

proc newNormalDistribution*(mu, sigma: float): NormalDistribution =
  ## Creates a new NormalDistribution from mean and standard deviation.
  result.mu = mu
  result.sigma = sigma

proc newNormalDistribution*(s: seq[SomeNumber]): NormalDistribution =
  ## Creates a new NormalDistribution from a sequence.
  result.mu = s.mean
  result.sigma = s.stdev

proc pdf*(n: NormalDistribution, v: float): float =
  ## Probability density function.
  let variance = n.sigma ^ 2
  exp((v - n.mu) ^ 2 / (-2.0 * variance)) / sqrt(TAU * variance)

proc cdf*(n: NormalDistribution, v: float): float =
  ## Cumulative distribution function.
  return 0.5 * (1.0 + erf((v - n.mu) / (n.sigma * sqrt(2.0))))

proc invCdf*(n: NormalDistribution, p: float): float =
  ## Cumulative distribution (percent point, quantile) function.
  # Wichura, M.J. (1988). "Algorithm AS241: The Percentage Points of the
  # Normal Distribution".  Applied Statistics. Blackwell Publishing. 37
  # (3): 477–484. doi:10.2307/2347330. JSTOR 2347330.
  let q = p - 0.5
  var x, r, num, den: float
  if abs(q) <= 0.425:
    r = 0.180625 - q * q
    num = (((((((
      2.50908_09287_30122_6727e+3 * r +
      3.34305_75583_58812_8105e+4) * r +
      6.72657_70927_00870_0853e+4) * r +
      4.59219_53931_54987_1457e+4) * r +
      1.37316_93765_50946_1125e+4) * r +
      1.97159_09503_06551_4427e+3) * r +
      1.33141_66789_17843_7745e+2) * r +
      3.38713_28727_96366_6080e+0) * q
    den = (((((((
      5.22649_52788_52854_5610e+3 * r +
      2.87290_85735_72194_2674e+4) * r +
      3.93078_95800_09271_0610e+4) * r +
      2.12137_94301_58659_5867e+4) * r +
      5.39419_60214_24751_1077e+3) * r +
      6.87187_00749_20579_0830e+2) * r +
      4.23133_30701_60091_1252e+1) * r +
      1.0)
    x = num / den
    return n.mu + (x * n.sigma)
  if q <= 0.0:
    r = p
  else:
    r = 1.0 - p
  r = sqrt(-ln(r))
  if r <= 5.0:
    r = r - 1.6
    num = (((((((
      7.74545_01427_83414_07640e-4 * r +
      2.27238_44989_26918_45833e-2) * r +
      2.41780_72517_74506_11770e-1) * r +
      1.27045_82524_52368_38258e+0) * r +
      3.64784_83247_63204_60504e+0) * r +
      5.76949_72214_60691_40550e+0) * r +
      4.63033_78461_56545_29590e+0) * r +
      1.42343_71107_49683_57734e+0)
    den = (((((((
      1.05075_00716_44416_84324e-9 * r +
      5.47593_80849_95344_94600e-4) * r +
      1.51986_66563_61645_71966e-2) * r +
      1.48103_97642_74800_74590e-1) * r +
      6.89767_33498_51000_04550e-1) * r +
      1.67638_48301_83803_84940e+0) * r +
      2.05319_16266_37758_82187e+0) * r +
      1.0)
  else:
    r = r - 5.0
    num = (((((((
      2.01033_43992_92288_13265e-7 * r +
      2.71155_55687_43487_57815e-5) * r +
      1.24266_09473_88078_43860e-3) * r +
      2.65321_89526_57612_30930e-2) * r +
      2.96560_57182_85048_91230e-1) * r +
      1.78482_65399_17291_33580e+0) * r +
      5.46378_49111_64114_36990e+0) * r +
      6.65790_46435_01103_77720e+0)
    den = (((((((
      2.04426_31033_89939_78564e-15 * r +
      1.42151_17583_16445_88870e-7) * r +
      1.84631_83175_10054_68180e-5) * r +
      7.86869_13114_56132_59100e-4) * r +
      1.48753_61290_85061_48525e-2) * r +
      1.36929_88092_27358_05310e-1) * r +
      5.99832_20655_58879_37690e-1) * r +
      1.0)
  x = num / den
  if q < 0.0:
    x = -x
  return n.mu + (x * n.sigma)

proc quantiles*(nd: NormalDistribution, n = 4): seq[float] =
  ## Divide the normal distribution into N regions with equal probability.
  if n < 2:
    return
  if n == 2:
    return @[nd.mu]
  for i in 1 ..< n:
    result.add(nd.invCdf(i / n))

proc variance*(nd: NormalDistribution): float =
  ## Computes the sample variance of a normal distribution.
  nd.sigma ^ 2

proc overlap*(a, b: NormalDistribution): float =
  # Compute the overlapping coefficient (OVL) between two normal distributions.
  # See: "The overlapping coefficient as a measure of agreement between
  # probability distributions and point estimation of the overlap of two
  # normal densities" -- Henry F. Inman and Edwin L. Bradley Jr
  # http://dx.doi.org/10.1080/03610928908830127
  var
    a = a
    b = b
  if (b.sigma, b.mu) < (a.sigma, a.mu):
    (a, b) = (b, a)
  if a.variance == 0 or b.variance == 0:
    return NaN
  let
    dv = b.variance - a.variance
    dm = abs(b.mu - a.mu)
  if dv == 0:
    return 1.0 - erf(dm / (2.0 * a.sigma * sqrt(2.0)))
  let
    xa = a.mu * b.variance - b.mu * a.variance
    xb = a.sigma * b.sigma * sqrt(dm ^ 2 + dv * ln(b.variance / a.variance))
    x1 = (xa + xb) / dv
    x2 = (xa - xb) / dv
  return 1.0 - (abs(b.cdf(x1) - a.cdf(x1)) + abs(b.cdf(x2) - a.cdf(x2)))

proc `+`*(a, b: NormalDistribution): NormalDistribution =
  ## Adds two NormalDistributions.
  newNormalDistribution(a.mu + b.mu, hypot(a.sigma, b.sigma))

proc `-`*(a, b: NormalDistribution): NormalDistribution =
  ## Subtracts two NormalDistributions.
  newNormalDistribution(a.mu - b.mu, hypot(a.sigma, b.sigma))

proc `*`*(a: NormalDistribution, b: float): NormalDistribution =
  ## Multiplies two NormalDistributions.
  newNormalDistribution(a.mu * b, a.sigma * b.abs)

proc `/`*(a: NormalDistribution, b: float): NormalDistribution =
  ## Divide two NormalDistributions.
  newNormalDistribution(a.mu / b, a.sigma / b.abs)

proc zScore*(mu, sigma, x: float): float =
  ## Computes z score (z statistic).
  (x - mu) / sigma

proc zScore*(nd: NormalDistribution, x: float): float =
  ## Computes z score (z statistic) of normal distribution and a test.
  zScore(nd.mu, nd.sigma, x)

proc zScore*(a, b: seq[float]): float =
  ## Computes z score (z statistic) of two sequencies.
  zScore(a.mean, a.stdev, b.mean)

proc zScoreToPValue*(zScore: float): float =
  ## Computes p-value from a z-score
  return 1 - 0.5 * (1.0 + erf(zScore / sqrt(2.0)))

proc zScore*(muA, muB, sigmaA, sigmaB, numA, numB: float): float =
  return (muB - muA)/sqrt(sigmaB^2 / numB + sigmaA^2 / numA)

proc zScore*(rateA, rateB, numA, numB: float): float =
  ## Proportional zTest.
  let
    varB = rateB * (1-rateB)
    varA = rateA * (1-rateA)
  return (rateA - rateB)/sqrt(varB/numB + varA/numA)

proc pValue*(zScore: float): float =
  ## Computes p-value from a z-score
  return 0.5 * (1.0 + erf(zScore / sqrt(2.0)))

proc normalcdf*(minZ, maxZ, mean, std: float): float =
  # Two sided CDF (two tailed CDF).
  let nd = newNormalDistribution(mean, std)
  return nd.cdf(minZ) + (1 - nd.cdf(maxZ))

type TDistribution* = object
  mu*: float             # Mean.
  sigma*: float          # Standard deviation.
  df*: int               # Degrees of Freedom.

proc tStatistic*(muA, muB, sigmaA, sigmaB, numA, numB: float): float =
  ## Same thing as zScore???
  return (muB - muA)/sqrt(sigmaB^2 / numB + sigmaA^2 / numA)

proc degreeOfFreedom*(
  varA: float,
  varB: float,
  numA: float,
  numB: float
): float =
  (varB/numA + varA/numA) ^ 2 / (
    (varB / numB) ^ 2 / (numB - 1) +
    (varA / numA) ^ 2 / (numA - 1)
  )

proc integrateInner(
  f: proc(x: float): float,
  xStart, xEnd: float,
  n = 500
): float =
  ## Calculate the integral of f using Simpson's rule.
  ## Based on the work of Hugo Granström Copyright (c) 2019 MIT License
  ## https://github.com/HugoGranstrom/numericalnim

  assert n >= 2
  let dx = (xEnd - xStart) / n.float
  var n = n
  var xStart = xStart
  result = f(xStart) - f(xStart)
  if n mod 2 != 0:
      result += 3 / 8 * dx * (f(xStart) +
        3 * f(xStart + dx) +
        3 * f(xStart + 2 * dx) +
        f(xStart + 3 * dx))
      xStart = xStart + 3 * dx
      n = n - 3
      if n == 0:
          return result
  var resultTemp = f(xStart) + f(xEnd)
  var res1 = f(xStart) - f(xStart)
  var res2 = res1
  for j in 1 .. (n / 2 - 1).toInt:
      res1 += f(xStart + dx * 2 * j.float)
  for j in 1 .. (n / 2).toInt:
      res2 += f(xStart + dx * (2 * j.float - 1))

  resultTemp += 2.0 * res1 + 4.0 * res2
  resultTemp *= dx / 3.0
  result += resultTemp

proc integrate*(
  f: proc(x: float): float,
  xStart, xEnd: float,
  errorTolerance = 1e-8
): float =
  ## Calculate the integral of f using an adaptive Simpson's rule.
  ## Based on the work of Hugo Granström Copyright (c) 2019 MIT License
  ## https://github.com/HugoGranstrom/numericalnim

  let zero = f(xStart) - f(xStart)
  let value1 = integrateInner(f, xStart, xEnd, n = 2)
  let value2 = integrateInner(f, xStart, xEnd, n = 4)
  let error = (value2 - value1) / 15
  var errorTolerance = errorTolerance
  if errorTolerance < 1e-15:
      errorTolerance = 1e-15
  if abs(error - zero) < errorTolerance or abs(xEnd - xStart) < 1e-5:
      return value2 + error
  let m = (xStart + xEnd) / 2
  let newN = errorTolerance / 2
  let left = integrate(f, xStart, m, errorTolerance = newN)
  let right = integrate(f, m, xEnd, errorTolerance = newN)
  return left + right

#                                  gamma((df+1)/2)
#    t.pdf(x, df) = ---------------------------------------------------
#                   sqrt(pi*df) * gamma(df/2) * (1+x**2/df)**((df+1)/2)

proc pdf*(d: TDistribution, x: float): float =
  let df = d.df.float
  gamma((df + 1) / 2) / (
    sqrt(PI * df) *
    gamma(df / 2) *
    pow(1 + x ^ 2 / df, (df + 1) / 2)
  )

proc cdf*(d: TDistribution, x: float): float =
  func f(x: float): float =
    d.pdf(x)
  integrate(f, -1E10, x)