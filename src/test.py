from ctypes import *

statistics = cdll.LoadLibrary("/p/statistics/src/libstatistics.so")

print statistics._double(1)