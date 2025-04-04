# 🚀 Quickstart Guide: Baldy Snowpack Project

This guide walks you through how to use the Baldy Snowpack project — even if you're new to coding or data science. Follow the steps below to get everything running smoothly.

---

## 🖥️ What You'll Need

- A computer with **Python** (v3.8+) and **R** (preferably through RStudio)
- Internet connection to download data and packages
- Git installed if you want to clone the repository

---

## 1️⃣ Download or Clone the Repository

You can clone using Git:
```bash
git clone https://github.com/YOUR_USERNAME/baldy-snowpack.git
cd Sierra-snowpack
```

---

## 2️⃣ Install Required Software

### Install Python packages
Open a terminal and run:

```bash
pip install netCDF4 xarray numpy pandas matplotlib cartopy wrf-python rasterio xesmf dask
```

> 💡 Tip: If you run into issues, try using Anaconda or Miniconda for easier environment setup.

### Install R packages
Open R or RStudio and run:

```r
install.packages(c("ggplot2", "dplyr", "lubridate", "tidyr", "ggpubr", 
                   "svglite", "DescTools", "extrafont", "purrr", "flextable", "officer"))
```

---

## 3️⃣ Extract Snow Data (Python)

### For Historical (ERA5) Data:

```bash
python scripts_python/wrf_era5_samplingscript_final.py
```

### For Model (GCM) Data:

```bash
python scripts_python/wrf_gcm_output_samplingscript_final.py
```

> These scripts will extract SWE (snow water equivalent) from NetCDF files and save them as CSVs.

---

## 4️⃣ Clean and Analyze the Data (R)

Open this file in RStudio:
```
scripts_r/SweData_Cleaning_Analysis_Visualization_Combined_Final_021425.R
```

Then run the script. It will:
- Clean the extracted snow data
- Calculate key snowpack metrics (accumulation, peak, melt)
- Create graphs and summary tables

---

## 5️⃣ View Your Results!

You’ll find:
- CSV files of cleaned snow data in `/outputs`
- Plots showing snow trends over time

---

## 🙋 Need Help?

- Check the README for more background on each file
- Look at `GLOSSARY.md` (coming soon!) for simple explanations of key terms
- Reach out or create an issue if you run into trouble!

Happy snow tracking! ❄️
