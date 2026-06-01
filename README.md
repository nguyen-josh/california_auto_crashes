# California Auto Crash Analytics

An interactive [R Shiny](https://shiny.posit.co/) dashboard for exploring traffic
collision data in California. The app lets you filter crashes by year, cause, city,
and collision type, then visualize the results through summary charts and an
interactive map.

The data comes from California's
[Statewide Integrated Traffic Records System (SWITRS)](https://iswitrs.chp.ca.gov/),
maintained by the California Highway Patrol.

https://github.com/user-attachments/assets/3c312ad2-6498-4196-9280-4578585e8f54

---

## Features

The dashboard is organized into two tabs:

**Explore**
- Crashes per year (interactive Plotly bar chart)
- Crashes by day of week
- Crashes faceted by day of week and collision severity
- Filters: year range, PCF violation category, and one or more collision types

**Map**
- Interactive [Leaflet](https://leafletjs.com/) map plotting individual crashes by
  latitude/longitude
- Each point shows the date, collision type, cause, and severity on hover
- Points can be color-coded by collision type or collision severity
- Filters: year, city, and PCF violation category

---

## Data

This repository ships with `crashes_california.csv`.

> **Note on the dataset:** The full SWITRS extract contains **1.7+ million rows**,
> which is too large to host on GitHub. The file in this repo is the
> **first 100,000 rows** of that dataset, taken with pandas (`df.head(100000)`).
> Because those rows were not sorted by date before slicing, the sample happens to
> cover crashes from **2014 through mid-2021** rather than the full 2014–2023 range
> of the complete dataset. The app and charts work the same way on the sample; you
> just won't see the most recent years unless you supply the full file.

The CSV has 31 columns covering the time, location, conditions, severity, and cause
of each collision. See [`DATA_DICTIONARY.md`](DATA_DICTIONARY.md) for a description
of every field.

If you have access to the full extract, you can drop it in place of the sample file
(see the setup notes below).

---

## Requirements

- [R](https://www.r-project.org/) (version 4.1 or newer recommended — the script uses
  the native `|>` pipe)
- The following R packages:

```r
install.packages(c("shiny", "tidyverse", "lubridate", "leaflet", "plotly"))
```

---

## Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/nguyen-josh/california_auto_crashes.git
   cd california_auto_crashes
   ```

2. **Install the R packages** listed above (if you haven't already).

3. **Point the script at the data.** Change the script to read the file in the repo.

   - **Line 13** reads the data file by name:
     ```r
     file = "crashes_california_2014_2023.csv",
     ```
     The sample file in this repo is named `crashes_california.csv`, so update this to
     match (or rename the CSV).

4. **Run the app.** From R or RStudio:

   ```r
   shiny::runApp("california_auto_crash_analytics.R")
   ```

   Or open the file in RStudio and click **Run App**.

---

## Project Structure

```
.
├── california_auto_crash_analytics.R   # The Shiny app (UI + server)
├── crashes_california.csv              # Sample data (first 100k rows)
├── DATA_DICTIONARY.md                  # Description of all 31 columns
├── .gitignore
└── README.md
```

---

## Built With

- **R** — language and environment for statistical computing
- **Shiny** — interactive web application framework
- **tidyverse** (dplyr, ggplot2, readr) — data wrangling and plotting
- **lubridate** — date handling
- **leaflet** — interactive maps
- **plotly** — interactive charts

---

## Acknowledgments

- Crash data sourced from the California Highway Patrol's
  [SWITRS](https://iswitrs.chp.ca.gov/) program.
