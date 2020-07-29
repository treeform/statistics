import algorithm, tables, math

type StatisticsError* = object of ValueError

proc isNaN*(v: float): bool =
  ## Is the current float a Nan or Inf.
  v.classify in {fcNaN, fcInf}

proc `~=`*(a, b: float): bool =
  ## Are the floats kind of equal?
  abs(a - b) < 1E-7

proc `~=`*(a, b: seq[float]): bool =
  ## Are the sequences of floats kind of equal?
  if a.len != b.len:
    return false
  else:
    for i in 0 ..< a.len:
      if abs(a[i] - b[i]) > 1E-7:
        return false
  return true

proc total*(s: seq[SomeNumber]): float =
  ## Computes total of a sequence.
  for v in s:
    result += v.float

proc average*(s: seq[SomeNumber]): float =
  ## Computes average (mean) of a sequence.
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
  exp(average(s.map(ln)))

proc harmonicMean*(s: seq[SomeNumber]): float =
  ## Computes the harmonic mean (subcontrary mean) of a sequence.
  if s.len == 0: return NaN
  let s2 = s.map(proc(x: float): float =
    if x < 0: NaN
    else: 1/x
  )
  s2.len.float/s2.total

proc quantiles*(s: seq[SomeNumber], n=4): seq[float] =
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
