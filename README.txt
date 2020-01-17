README for WaterColumnParams

This project contains two functions for analyzing 1D data with corresponding depths from a water column

getisoxdepth determines the iso-depth for a parameter (e.g. isotherm depth, isohaline depth), given the parameter, depth, and target value. For example, given an array of temperatures and depths, 26C isotherm depth can be calculated as d26 = getisoxdepth(temperatures,depths,26)

getohc calculates the ocean heat content for a water column. Optional arguments allow the user to specify the max depth over which to calculate (e.g. calculating OHC for the upper 100 m), or reference temperature from which to calculate heat content (e.g. 26C to determine tropical cyclone heat potential).

Note that both of these functions require temperature information in degC and depths in meters (positive down).