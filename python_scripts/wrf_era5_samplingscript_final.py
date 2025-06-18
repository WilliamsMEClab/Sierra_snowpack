# -*- coding: utf-8 -*-
"""

Hey there!

The code below is an effor to help you with data extraction from the ERA5 Dataset.
ERA5 looks at global climate/weather data, updating every hour. It is usually about
5 days behind real time, though, and goes back to 1940.

An oveview of all the information of the ERA5 dataset can be found here:
    https://confluence.ecmwf.int/display/CKB/The+family+of+ERA5+datasets
    (although personally I found this documentation dry + overwhelming)

A more friendly overview is here:
    https://cds.climate.copernicus.eu/datasets/reanalysis-era5-pressure-levels-monthly-means?tab=overview

To download the ERA5 dataset, follow this official tutorial:
    https://confluence.ecmwf.int/display/CKB/How+to+download+ERA5

The data is gridded, so looking at latitude and longitude. You'll need to specify
    where you want to focus your research.

We can use a WRF model to access the ERA5 too, which I found easier.
    WRF stands for Weather Rsearch and Forcasting. 
    You can read an overview here: 
        https://www.mmm.ucar.edu/models/wrf
    Here is a nice step-by-step on downloading and accessing: 
        https://github.com/moptis/era5-for-wrf

Good luck!

    -- Claire

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


def _wrfread_simple(gcm, dir, var, domain):
    all_files = sorted(os.listdir(dir))
    anal_files = []
    for file in all_files:
        # Check if file starts with the var, and contains the GCM and domain
        if file.startswith(var + ".daily.") and gcm in file and domain in file:
            anal_files.append(os.path.join(dir, file))

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
                                    'lat2d': ('lat2d', var_read.lat2d.values),
                                    'lon2d': ('lon2d', var_read.lon2d.values)
                                },
                                dims=['day', 'lat2d', 'lon2d'])

    return new_var_read

print("Function loaded")




#%% load the NC files with the raw data

#####open the NetCDF data files containing the raw data######

#criteria for selecting NetCDF files in the _wrfread_gcm function, need to adjust gcm and variant fields pending gcm, need to adjust model field pending time period/emissions scenario
domain = "d02" #domain is spatial resolution, d02 is the 9km grid data and d03 is the 3km grid data
var = 'snow' #var does not change, we are only interested in snow water equivalent data, which they call 'snow'
gcm = 'era5'

#point to the directory that contains the raw NetCDF files, this needs to be adjusted pending gcm and time period/emissions scenario
dir = "data_nc/era5_sangabriel/"

#grab all of the NetCDF files that match the criteria above and open them
var_wrf = _wrfread_simple(gcm,dir,var,domain)

# region specification:
region = "sangabriel"


#%% extract SWE values at sampling points from NC files 

####point to wrf metadata file and coordinates csv file, then extract swe values at those coordinates######

#import csv file with sample coordinates
coordinates_df = pd.read_csv("input/station_coords_sangabriel.csv") 

# specify the output filename
output_csv = f"data_raw/era5_sangabriel.csv"


#file path to point to your wrfinput file, there are two metadata files--one for 9km data and one for 3km data
metadata_path = "input/wrfinput_d02"

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
csv_file_path = "put-your-file-path-here.csv"

# Save the DataFrame to CSV at the specified path
swe_values_df.to_csv(csv_file_path)



