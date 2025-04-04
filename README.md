# ❄️ Baldy Snowpack: Snow Water Equivalent Analysis in Southern California

**Repository for:**  
**_Preparing for Uncertain Water Futures: An Analysis of Intrannual Snowpack Processes in the Southern Sierra Nevada Under Climate Change_**

This repository provides the full codebase and datasets for extracting, cleaning, analyzing, and visualizing Snow Water Equivalent (SWE) data across the San Gabriel and San Bernardino mountain ranges, including Mt. Baldy. It integrates observational (instrumental), reanalysis (ERA5), and model (WRF-GCM) data to investigate trends in snowpack accumulation and melt under climate change.

---

## 📁 Repository Contents

### R Script

- **`SweData_Cleaning_Analysis_Visualization_Combined_Final_021425.R`**  
  The central script that:
  - Processes and cleans SWE data from instrumental, ERA5, and WRF-GCM sources
  - Aggregates SWE values by region
  - Calculates key seasonal metrics:
    - **SAD**: Snow Accumulation Date
    - **SPD**: Snowpack Peak Date
    - **CMD**: Complete Melt Date
  - Computes:
    - Accumulation and melt season durations (AS, MS)
    - SWE accumulation and melt rates (SAR, SMR)
  - Visualizes outputs and exports clean datasets

---

### Python Scripts

- **`wrf_gcm_output_samplingscript_final.py`**  
  Extracts SWE data from WRF-GCM output (NetCDF format), filtered by variable, model, and domain (e.g., `d03`). Used for CMIP6 future scenario analysis.

- **`wrf_era5_samplingscript_final.py`**  
  Extracts SWE data from WRF-ERA5 reanalysis output using similar logic as above, adapted for historical weather analysis.

- **`wrf_samplinggrid_pointfile_script.py`**  
  Compares WRF gridpoint elevations with field monitoring station elevations. Ensures representativeness between modeled and observed locations.

---

### CSV Datasets

| Filename                                           | Description                                                                 |
|----------------------------------------------------|-----------------------------------------------------------------------------|
| `instrumental_swe_data_regionaverage_1986_2005.csv` | Daily observed SWE across 34 monitoring stations (1986–2005)               |
| `era5_regionaverage.csv`                           | ERA5-derived SWE averaged over 34 WRF gridpoints (1986–2005)               |
| `swe_allmodels_9km_df_regionaverage.csv`           | WRF-GCM SWE from multiple models (1981–2100), averaged across 34 gridpoints|

---

## 📊 Outputs

The R script calculates and visualizes:
- **Demarcation dates** (SAD, SPD, CMD) for each dataset
- **Duration metrics** for accumulation (AS) and melt (MS) seasons
- **Rates** of SWE accumulation and melt (SAR, SMR)
- **Ensemble summaries** for WRF-GCM outputs across historical, mid-century, and end-of-century periods

Confidence intervals (95% CI) for medians are computed using exact statistics (`DescTools::MedianCI`).

---

## 📌 File Naming Conventions

Model-based data files follow this structure:
```
swe_<modelname>_9km_df_regionaverage_<period>.csv
```
Where:
- `modelname` = cesm, cnrm, ece, fgoals, etc.
- `period` = 1986_2005 (historical), 2040_2059 (mid-century), 2080_2099 (end-of-century)

---

## ⚙️ Getting Started

### R Requirements
Install necessary R packages:
```r
install.packages(c("ggplot2", "dplyr", "lubridate", "tidyr", "ggpubr", 
                   "svglite", "DescTools", "extrafont", "purrr", "flextable", "officer"))
```

### Python Requirements
Install necessary Python packages:
```bash
pip install netCDF4 xarray numpy pandas matplotlib cartopy wrf-python rasterio xesmf dask
```

---

## 📈 Example Visualizations

The R script generates:
- Temporal trends in SWE
- Bar plots comparing accumulation/melt timing
- Distribution plots for seasonal SWE rates
- Confidence interval ranges across model outputs

---

## 🧠 Citation

If you use this repository or datasets, please cite:

> *Greenspan, D. (2024). Preparing for Uncertain Water Futures: An Analysis of Intrannual Snowpack Processes in the Southern Sierra Nevada Under Climate Change.*

---

## 🙌 Acknowledgments

Special thanks to the creators of the WRF-GCM and ERA5 datasets and the monitoring networks that provided instrumental SWE data.
