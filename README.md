# Common and uncommon statitics functions.

# API: statistics

```nim
import statistics
```

## **proc** isNaN

Is the current float a Nan or Inf.

```nim
proc isNaN(v: float): bool 
```

## **proc** `~=`

Are the floats kind of equal?

```nim
proc `~=`(a, b: float): bool 
```

## **proc** `~=`

Are the sequences of floats kind of equal?

```nim
proc `~=`(a, b: seq[float]): bool 
```

## **proc** total

Computes total of a sequence.

```nim
proc total(s: seq[SomeNumber]): float
```

## **proc** mean

Computes mean (average) of a sequence.

```nim
proc mean(s: seq[SomeNumber]): float
```

## **proc** median

Computes the median.

```nim
proc median(s: seq[SomeNumber]): float
```

## **proc** mode

Computes the mode of a sequence.

```nim
proc mode(s: seq[SomeNumber]): float
```

## **proc** multiMode

Returns all modes of > 1.

```nim
proc multiMode(s: seq[SomeNumber]): CountTable[float]
```

## **proc** map

Maps a function onto a sequence of floats.

```nim
proc map(s: seq[SomeNumber]; fn: proc (v: float): float): seq[float]
```

## **proc** geometricMean

Computes the geometric mean of a sequence.

```nim
proc geometricMean(s: seq[SomeNumber]): float
```

## **proc** harmonicMean

Computes the harmonic mean (subcontrary mean) of a sequence.

```nim
proc harmonicMean(s: seq[SomeNumber]): float
```

## **proc** quantiles

Divide the s into N regions with equal probability.

```nim
proc quantiles(s: seq[SomeNumber]; n = 4): seq[float]
```

## **proc** variance

Computes the sample variance of a sequence.

```nim
proc variance(s: seq[SomeNumber]): float
```

## **proc** pvariance

Computes the population variance of a sequence.

```nim
proc pvariance(s: seq[SomeNumber]): float
```

## **proc** stdev

Computes the sample standard deviation of a sequence.

```nim
proc stdev(s: seq[SomeNumber]): float
```

## **proc** pstdev

Computes the population standard deviation of a sequence.

```nim
proc pstdev(s: seq[SomeNumber]): float
```

## **type** NormalDistribution


```nim
NormalDistribution = object
  mu*: float
  sigma*: float

```

## **proc** newNormalDistribution

Creates a new NormalDistribution from mean and standard deviation.

```nim
proc newNormalDistribution(mu, sigma: float): NormalDistribution 
```

## **proc** newNormalDistribution

Creates a new NormalDistribution from a sequence.

```nim
proc newNormalDistribution(s: seq[SomeNumber]): NormalDistribution
```

## **proc** pdf

Probability density function.

```nim
proc pdf(n: NormalDistribution; v: float): float 
```

## **proc** cdf

Cumulative distribution function.

```nim
proc cdf(n: NormalDistribution; v: float): float 
```

## **proc** invCdf

Cumulative distribution (percent point, quantile) function.

```nim
proc invCdf(n: NormalDistribution; p: float): float 
```

## **proc** quantiles

Divide the normal distribution into N regions with equal probability.

```nim
proc quantiles(nd: NormalDistribution; n = 4): seq[float] 
```

## **proc** variance

Computes the sample variance of a normal distribution.

```nim
proc variance(nd: NormalDistribution): float 
```

## **proc** overlap


```nim
proc overlap(a, b: NormalDistribution): float 
```

## **proc** `+`

Adds two NormalDistributions.

```nim
proc `+`(a, b: NormalDistribution): NormalDistribution 
```

## **proc** `-`

Subtracts two NormalDistributions.

```nim
proc `-`(a, b: NormalDistribution): NormalDistribution 
```

## **proc** `*`

Multiplies two NormalDistributions.

```nim
proc `*`(a: NormalDistribution; b: float): NormalDistribution 
```

## **proc** `/`

Divide two NormalDistributions.

```nim
proc `/`(a: NormalDistribution; b: float): NormalDistribution 
```

## **proc** zScore

Computes z score (z statistic).

```nim
proc zScore(mu, sigma, x: float): float 
```

## **proc** zScore

Computes z score (z statistic) of normal distribution and a test.

```nim
proc zScore(nd: NormalDistribution; x: float): float 
```

## **proc** zScore

Computes z score (z statistic) of two sequencies.

```nim
proc zScore(a, b: seq[float]): float 
```

## **proc** zScoreToPValue

Computes p-value from a z-score

```nim
proc zScoreToPValue(zScore: float): float 
```

## **proc** zScore


```nim
proc zScore(muA, muB, sigmaA, sigmaB, numA, numB: float): float 
```

## **proc** zScore

Proportional zTest.

```nim
proc zScore(rateA, rateB, numA, numB: float): float 
```

## **proc** pValue

Computes p-value from a z-score

```nim
proc pValue(zScore: float): float 
```

## **proc** normalcdf


```nim
proc normalcdf(minZ, maxZ, mean, std: float): float 
```

## **proc** tStatistic

Same thing as zScore???

```nim
proc tStatistic(muA, muB, sigmaA, sigmaB, numA, numB: float): float 
```

## **proc** degreeOfFreedom


```nim
proc degreeOfFreedom(varA: float; varB: float; numA: float; numB: float): float 
```

## **proc** integrate

Calculate the integral of f using an adaptive Simpson's rule. Based on the work of Hugo Granström Copyright (c) 2019 MIT License <a class="reference external" href="https://github.com/HugoGranstrom/numericalnim">https://github.com/HugoGranstrom/numericalnim</a>

```nim
proc integrate(f: proc (x: float): float; xStart, xEnd: float; errorTolerance = 1e-08): float 
```

## **proc** tPdf


```nim
proc tPdf(x: float; df: int): float 
```

## **proc** tCdf


```nim
proc tCdf(x: float; df: int): float 
```

