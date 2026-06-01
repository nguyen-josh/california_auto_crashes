# Data Dictionary — `crashes_california.csv`

Each row represents a single reported traffic collision in California. Fields follow
the California Highway Patrol's
[SWITRS](https://iswitrs.chp.ca.gov/) schema. The sample in this repo contains the
first 100,000 rows of the full dataset (see the README for details).

| # | Column | Type | Description |
|---|--------|------|-------------|
| 1 | `CASE_ID` | numeric | Unique identifier for the collision record. |
| 2 | `ACCIDENT_YEAR` | numeric | Calendar year the collision occurred. |
| 3 | `COLLISION_DATE` | date | Date of the collision (`YYYY-MM-DD`). |
| 4 | `COLLISION_TIME` | numeric | Time of the collision in 24-hour `HHMM` form (e.g. `855` = 08:55, `1926` = 19:26). |
| 5 | `HOUR` | numeric | Hour of day the collision occurred (0–23). |
| 6 | `DAY_OF_WEEK` | integer | Day of week as a number (1 = Monday … 7 = Sunday). |
| 7 | `WEATHER_1` | character | Primary weather condition (e.g. `clear`, `raining`, `fog`). |
| 8 | `WEATHER_2` | character | Secondary weather condition, if any (often `unknown`). |
| 9 | `STATE_HWY_IND` | character | Whether the collision occurred on a state highway (`yes` / `no` / `unknown`). |
| 10 | `COLLISION_SEVERITY` | character | Severity of the collision: `possible injury`, `minor injury`, `severe injury`, or `fatal injury`. |
| 11 | `NUMBER_KILLED` | integer | Number of people killed in the collision. |
| 12 | `NUMBER_INJURED` | integer | Number of people injured in the collision. |
| 13 | `PARTY_COUNT` | integer | Number of parties (vehicles, pedestrians, etc.) involved. |
| 14 | `PCF_VIOL_CATEGORY` | character | Primary Collision Factor — the main cause/violation category (e.g. `unsafe speed`, `DUI`, `improper turning`). |
| 15 | `TYPE_OF_COLLISION` | character | Manner of collision: `rear end`, `broadside`, `sideswipe`, `head-on`, `hit object`, `overturned`, `vehicle/pedestrian`, `other`, `unknown`. |
| 16 | `ROAD_SURFACE` | character | Road surface condition: `dry`, `wet`, `snowy or icy`, `slippery (muddy, oily)`, `unknown`. |
| 17 | `ROAD_COND_1` | character | Primary roadway condition (e.g. `no unusual condition`, `construction`, `holes`). |
| 18 | `ROAD_COND_2` | character | Secondary roadway condition, if any. |
| 19 | `LIGHTING` | character | Lighting conditions: `daylight`, `dusk-dawn`, `dark street lights`, `dark no street lights`, `dark street lights not working`, `unknown`. |
| 20 | `PEDESTRIAN_ACCIDENT` | character | Whether a pedestrian was involved (`yes` / `no`). |
| 21 | `BICYCLE_ACCIDENT` | character | Whether a bicyclist was involved (`yes` / `no`). |
| 22 | `MOTORCYCLE_ACCIDENT` | character | Whether a motorcycle was involved (`yes` / `no`). |
| 23 | `TRUCK_ACCIDENT` | character | Whether a truck was involved (`yes` / `no`). |
| 24 | `NOT_PRIVATE_PROPERTY` | character | Whether the collision occurred on a public roadway rather than private property (`yes` / `no`). |
| 25 | `ALCOHOL_INVOLVED` | character | Whether alcohol was a factor (`yes` / `no`). |
| 26 | `COUNTY` | character | County where the collision occurred. |
| 27 | `CITY` | character | City code/name associated with the collision. |
| 28 | `PO_NAME` | character | Post office / place name (used as the city label in the app's filters). |
| 29 | `ZIP_CODE` | numeric | ZIP code of the collision location. |
| 30 | `POINT_X` | numeric | Longitude of the collision (used for mapping). |
| 31 | `POINT_Y` | numeric | Latitude of the collision (used for mapping). |

## Sample dataset summary

- **Rows:** 100,000
- **Columns:** 31
- **Years present in sample:** 2014 – 2021
- **Counties:** 58
- **Distinct place names (`PO_NAME`):** ~1,036
- **PCF violation categories:** 22
- **Collision types:** 9
- **Severity levels:** 4

> Categorical fields frequently include an `unknown` value where the information was
> not recorded in the original report.
