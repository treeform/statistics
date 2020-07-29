# Common and uncommon statitics functions.

# API: statistics

```nim
import statistics
```

## **type** StatisticsError


```nim
StatisticsError = object of ValueError
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

## **proc** average

Computes average (mean) of a sequence.

```nim
proc average(s: seq[SomeNumber]): float
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
