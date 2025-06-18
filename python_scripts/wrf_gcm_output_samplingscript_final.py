# -*- coding: utf-8 -*-
"""

Hi friend! 

The code below is to load files from the Global Climate Models (GCMs).

The current GCM output is super big and not a very high resolution, so some
    really cool researchers use something they call "Dynamic Downscaling"
    using the Weather Research and Forecasting (WRF) model (which is one
    of the other python scripts included in this folder.)

Here are some great resources to learn a bit about the data:
    https://dept.atmos.ucla.edu/alexhall/downscaling-cmip6
    https://gmd.copernicus.org/articles/17/2265/2024/gmd-17-2265-2024.html


This dataset is being updated all the time, so I recommend when you do your
    research, you download the most recent dataset, as well as anything you are 
    wanting to compare it to.

    You can access the data here:
    https://registry.opendata.aws/wrf-cmip6/

    Using AWS Open Data Registry can be a bit confusing, because you might
    need to use the CLI (command line interface) to access it.

    I found this tutorial super helpful so you can download the data that you
    actually want: 
    https://www.researchgate.net/publication/374504614_Data_tier_descriptions_directory_structure_and_data_access_of_the_Western_US_Dynamically_Downscaled_Dataset_WUS-D3_version_1
    
    Pay attention to the fact that there are three data tiers!

    Another helpful tutorial is this Jupyter Notebook. I might guess that 
    Kyle used this Notebook as a model for the code below :). So, when you 
    do your data analysis, look this over and feel free to copy over any functions
    that will help you with your goals.
    https://nbviewer.org/urls/wrf-cmip6-noversioning.s3.amazonaws.com/Example_notebook/Notebook_example.ipynb


This should be enough info to get you started! Happy coding!
    -- Claire



"""

#%% necessary packages



####loading packages#######
# note: not all of these packages are used below, but Kyle was not 
# certain which ones are or which are dependencies so just kept all 
# to make sure the code works


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
# Make sure the NetCDF directory (dir) points to WRF files for San Gabriel area:

dir = "data_nc/era5_sangabriel/"

#grab all of the NetCDF files that match the criteria above and open them
var_wrf = _wrfread_gcm(model,gcm,variant,dir,var,domain)

# add a region variable
region = "sangabriel"

#%% extract SWE values at sampling points from NC files 

####point to wrf metadata file and coordinates csv file, then extract swe values at those coordinates######

#import csv file with sample coordinates
coordinates_df = pd.read_csv("/input/station_coords_sangabriel.csv") 

#file path to point to your wrfinput file, there are two metadata files--one for 9km data and one for 3km data
# Ensure metadata_path matches the correct domain (e.g., d02 for 9km resolution):
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
csv_file_path = "where-this-is-saved-on-your-computer.csv"

# Save the DataFrame to CSV at the specified path
swe_values_df.to_csv(csv_file_path)



