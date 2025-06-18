# -*- coding: utf-8 -*-
"""

Since the data is on a grid of lat/long you can make a datagrid with the code below!

"""

import geopandas as gpd
import pandas as pd
from netCDF4 import Dataset
import matplotlib.pyplot as plt
from shapely.geometry import Point
import numpy as np
import wrf

# File paths
metadata_path = "your-filepath-wrfinput"
coordinates_csv_path = "your-file-path-station_coord.csv"

# Load WRF metadata
metadata = Dataset(metadata_path)

# Load sampling points
coordinates_df = pd.read_csv(coordinates_csv_path)
lat_array = coordinates_df['lat'].values
lon_array = coordinates_df['lon'].values

# Find the nearest grid indices for sampling points
iii, jjj = wrf.ll_to_xy(metadata, lat_array, lon_array, timeidx=0, meta=True, stagger='m')

# Get the center lat/lon of the WRF grid cells
lat_centers = wrf.getvar(metadata, "XLAT", timeidx=0).data[jjj, iii]
lon_centers = wrf.getvar(metadata, "XLONG", timeidx=0).data[jjj, iii]

# Create a GeoDataFrame for the grid cell centers
grid_centers_gdf = gpd.GeoDataFrame(
    {'Latitude': lat_centers, 'Longitude': lon_centers},
    geometry=gpd.points_from_xy(lon_centers, lat_centers),
    crs="EPSG:4326"
)

# Create a GeoDataFrame for the original sampling points
sampling_points_gdf = gpd.GeoDataFrame(
    coordinates_df,
    geometry=gpd.points_from_xy(coordinates_df['lon'], coordinates_df['lat']),
    crs="EPSG:4326"
)

# File paths to save the shapefiles
grid_centers_shapefile = "your-file-path-grid_cell_centers.shp"

# Save the grid cell centers as a shapefile
grid_centers_gdf.to_file(grid_centers_shapefile)

# extract elevation information for each wrf grid cell center
elevation = wrf.getvar(metadata, "HGT", timeidx=0).data[jjj, iii]


# Add the elevation and WRF grid cell center coordinates to the DataFrame
coordinates_df['WRF_Latitude'] = lat_centers
coordinates_df['WRF_Longitude'] = lon_centers
coordinates_df['Elevation'] = elevation

# Save the updated table to a new CSV file
coordinates_df.to_csv("your-file-path-wrf_grid_cell_elevations.csv", index=False)


