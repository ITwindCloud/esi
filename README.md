# Simulation Project Associated with Sensor Density and Trial Count

# Description
This repository contains the simulation codes for the study:
"Electromagnetic Source Imaging with Few sensors and Limited Trials" in review.

## Key Features
- Implementation of six inverse algorithms
- Simulation of various sensor and trial configurations
- Gaussian white noise and real-world noise
- Spatio-temporal correlations

## Usage
- simu_source_activity.m: simulate source activity based on a given MEG model (saved in data/msp_nuts.mat).
- simu_constraints_with_real_noise.m : evaluate performance of algorithms under four sensor- and trial-related constraints overlapped with **Gaussian white nosie**, including **number of sensors, regional bad sensors, random bad sensors and number of trials** (see gaussian_simu_chans.m,gaussian_simu_region.m,gaussian_simu_chans.m and gaussian_simu_chans.m, respectively).
- simu_constraints_with_real_noise.m : evaluate performance of algorithms under four sensor- and trial-related constraints overlapped with **real-world nosie**, including **number of sensors, regional bad sensors, random bad sensors and number of trials**(see gaussian_simu_chans.m,gaussian_simu_region.m,gaussian_simu_chans.m and gaussian_simu_chans.m, respectively).
- compute_two_correlations_gaussion.m: compute spatio-temporal correlations under the **Gaussian white noise** condition.
- compute_two_correlations_raw.m: compute spatio-temporal correlations under the **real-world noise** condition.
- algorithm/bmn.m, champagne.mm, lcmv.m, mxne.m, sbl_bf.m and sLORETA: core codes of six algorithms: BMN, Champagne, LCMV, MXNE, SBL-BF and sLORETA. Their usage can see performan_six_methods.m