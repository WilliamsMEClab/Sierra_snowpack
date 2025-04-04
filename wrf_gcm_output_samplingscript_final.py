# -*- coding: utf-8 -*-
"""
Created on Fri Mar  1 09:40:01 2024

@author: DavGreenspan
"""

#%% necessary packages



####loading packages#######
#note: not all of these packages are used below, but I am not certain which ones are or which are dependencies so just keep all to make sure the code works


#import necessary packages
import netCDF4
from netCDF4 import Dataset
import numpy as np
from numpy import ma
from numpy import dtype
import matplotlib
import pylab as P
import cartopy
import cartopy.crs as ccrs
import cartopy.feature as cfeature
from cartopy.mpl.ticker import LongitudeFormatter, LatitudeFormatter
from matplotlib.colors import ListedColormap, LinearSegmentedColormap
import matplotlib.colors as colors
import matplotlib.ticker as mticker
import matplotlib.gridspec as gridspec
import matplotlib.pyplot as plt
import xarray as xr
import rioxarray 
import pandas as pd
import os
import scipy
from scipy.interpolate import griddata
import wrf
from wrf import (getvar, to_np, vertcross, smooth2d, CoordPair, GeoBounds, get_cartopy, latlon_coords, cartopy_xlim, cartopy_ylim)
import xesmf as xe
import dask
import gc
import datetime
import time
from scipy import stats
import regionmask
import rasterio
from rasterio.transform import from_origin

print("Packages Loaded")


#%% necessary functions, adjust pending which GCM 

########defining functions#####


'''
def _wrfread_gcm(model, gcm, variant, dir, var, domain):
    all_files = sorted(os.listdir(dir))

    anal_files = []
    for ii in all_files:
        if ii.startswith(var + ".") and model in ii and gcm in ii \
                and variant in ii and domain in ii:
            if domain in ii:
                anal_files.append(dir + str(ii))

    del all_files

    nf = len(anal_files)
    if nf == 0:
        raise ValueError("No files found matching the criteria.")

    data = xr.open_mfdataset(anal_files, combine="by_coords")
    var_read = data.variables[var]
    day = data.variables["day"].values

    # Convert days to datetime, coerce errors to NaT
    day_dates = pd.to_datetime(day, format='%Y%m%d', errors='coerce')

    # Filter out NaT values
    valid_dates = day_dates.dropna()

    # Calculate and print the number of removed observations
    removed_count = len(day_dates) - len(valid_dates)
    print(f"{removed_count} observations removed due to invalid dates.")

    if len(valid_dates) == 0:
        raise ValueError("No valid dates found after filtering.")

    dates = pd.date_range(start=valid_dates.min(), end=valid_dates.max(), freq="D")

    # Mask array setting leap years = True, these two lines need to be commented out for cnrm and ece, they should be active for cesm2 and fgoals
    # Remember to run the lines of code that defines this function after commenting/uncommenting before using the function
    #is_leap_day = (dates.month == 2) & (dates.day == 29)
    #dates = dates[~is_leap_day]

    var_read = xr.DataArray(var_read, dims=['day', 'lat2d', 'lon2d'])
    var_read['day'] = dates  # Year doesn't matter here

    return var_read

print("Functions loaded")
'''

def _wrfread_gcm(model, gcm, variant, dir, var, domain):
    all_files = sorted(os.listdir(dir))

    anal_files = []
    for ii in all_files:
        if ii.startswith(var + ".") and model in ii and gcm in ii \
                and variant in ii and domain in ii:
            if domain in ii:
                anal_files.append(dir + str(ii))

    if not anal_files:
        raise ValueError("No files found matching the criteria.")

    data = xr.open_mfdataset(anal_files, combine="by_coords")
    var_read = data[var]
    day = data.day.values  # assuming 'day' is already a coordinate in the dataset

    # Convert days to datetime, coerce errors to NaT
    day_dates = pd.to_datetime(day, format='%Y%m%d', errors='coerce')

    # Calculate and print the number of removed observations
    removed_count = len(day) - day_dates.notna().sum()
    print(f"{removed_count} observations removed due to invalid dates.")

    if day_dates.notna().sum() == 0:
        raise ValueError("No valid dates found after filtering.")

    # Create a new DataArray with only valid dates
    valid_indices = day_dates.notna()
    valid_data = var_read.isel(day=valid_indices)  # Filter to valid days
    valid_dates = day_dates[valid_indices]  # Get valid dates

    new_var_read = xr.DataArray(valid_data.values,
                                coords={
                                    'day': ('day', valid_dates),
                                    'lat2d': ('lat2d', var_read.lat2d.values),  # Extract the raw data using .values
                                    'lon2d': ('lon2d', var_read.lon2d.values)  # Extract the raw data using .values
                                },
                                dims=['day', 'lat2d', 'lon2d'])

    return new_var_read

print("Functions loaded")




#%% load the NC files with the raw data

#####open the NetCDF data files containing the raw data######

#criteria for selecting NetCDF files in the _wrfread_gcm function, need to adjust gcm and variant fields pending gcm, need to adjust model field pending time period/emissions scenario
domain = "d02" #domain is spatial resolution, d02 is the 9km grid data and d03 is the 3km grid data
var = 'snow' #var does not change, we are only interested in snow water equivalent data, which they call 'snow'
gcm = 'mpi-esm1-2-hr'
variant = 'r3i1p1f1'
model = 'ssp370' #'model' here means time period/emissions scenario, either 'historical' or 'ssp370'

#point to the directory that contains the raw NetCDF files, this needs to be adjusted pending gcm and time period/emissions scenario
dir = "C:/Users/DavGreenspan/Box/Southern Sierra SWE Data Collection and Processing/Data files/Raw bias corrected 9km wrf output/mpi-esm1-2-hr_r3i1p1f1_ssp370_9km_raw/"

#grab all of the NetCDF files that match the criteria above and open them
var_wrf = _wrfread_gcm(model,gcm,variant,dir,var,domain)



#%% extract SWE values at sampling points from NC files 

####point to wrf metadata file and coordinates csv file, then extract swe values at those coordinates######

#import csv file with sample coordinates
coordinates_df = pd.read_csv("C:/Users/DavGreenspan/Box/Southern Sierra SWE Data Collection and Processing/Input files for data extraction at points/station_coord.csv") 

#file path to point to your wrfinput file, there are two metadata files--one for 9km data and one for 3km data
metadata_path = "C:/Users/DavGreenspan/Box/Southern Sierra SWE Data Collection and Processing/Input files for data extraction at points/wrfinput_d02"

# Open the wrfinput_d02 file
metadata = Dataset(metadata_path)

#grab lat and lon values from the coordinates df
lat_array = coordinates_df['lat'].values
lon_array = coordinates_df['lon'].values

# Convert lat/lon to WRF grid indices
iii, jjj = wrf.ll_to_xy(metadata, lat_array, lon_array, timeidx=0, meta=True, stagger='m')

# Extract SWE values at the specified indices
swe_values_at_points = var_wrf.isel(lat2d=jjj, lon2d=iii)
swe_values_df = swe_values_at_points.to_dataframe(name="SWE")

# Specify the full path for the CSV file, adjust pending gcm/variant, period/emissions scenario, and spatial resolution
csv_file_path = "C:/Users/DavGreenspan/Box/Southern Sierra SWE Data Collection and Processing/Data files/Raw csv files containing model data extracted at points 9km/mpi-esm1-2-hr_r3i1p1f1_ssp370_9km.csv"

# Save the DataFrame to CSV at the specified path
swe_values_df.to_csv(csv_file_path)



