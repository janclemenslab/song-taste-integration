# song-taste-integration
Code for Palacios et al. 2025

# Installation

For training and testing of GLM models, we used *R* (v4.2.3), together with the *glmmTMB* (v1.1.5, https://cran.r-project.org/web/packages/glmmTMB/index.html) and *parallel* packages (part of *R core*). For installation of *R*, follow corresponding instructions in https://www.r-project.org/. For installation of *glmmTMB* (v1.1.5) simply use `install.packages("glmmTMB")` within *R*.

# File description

- `README.md`: All relevant information.
- `master_script`: To execute all individual model scripts.
- `*.r`: Individual model scripts, which will generate the corresponding `*_chisq.csv` and `*_coeffs.- csv` tables per model. Can be run individually or through `master_script`.
- `dat\*_all.csv`: Table of model inputs for the corresponding genotype (*CS*: *Canton S*, *ppk23*:*ppk23-GtACR1*).
- `dat\*_annotated.csv`: Table of model inputs for wing annotations (UWE/BWE) of the corresponding genotype (*CS*: *Canton S*, *ppk23*:*ppk23-GtACR1*).
- `res\*_chisq.csv`: Table of model selection outputs, comparing all models for the corresponding analysis (analysis names for each corresponding model and figure panel detailed in the following section).
- `res\*_coeffs.csv`: Table of model coefficients for all corresponding analysis (analysis names for each corresponding model and figure panel detailed in the following section).
- `check_tables.ipynb`: python jupyter notebook to compile and rename tables for better readability and interpretation.

# Related figures

Scripts, inputs and outputs for models used in Figures 1E (*CS_males_interaction_index*), 2B (*CS_males_BWE*), 3C (*ppk23_females_interaction_index*), 4B (*ppk23IPIs_females_interaction_index*) and 5C (*ppk23_females_UWE*).

# Table descriptions

## dat
- `dat\*_all.csv`:
    - *datename*: Experiment identifier.
    - *box*: Box identifier (individual behavior arena).
    - *taste*: False if males were removed of tarsiless, True otherwise.
    - *social_experience*: False if fly was housed in isolation, True otherwise (group housed). Always False in this study, since all flies were housed in isolation.
    - *sex_target*: Sex of the target fly.
    - *playlist*: If True/False, False indicates silence, and True indicates playback of courtship song with conspecific IPI (36ms). Otherwise a string that indicates the type of playback (silence/IPI16/IPI36/IPI96).
    - *interaction_index*: Social interaction index for the given fly in the given experiment.
    - *led_intensity* (only in `ppk23_*` tables): Value of 525nm LED intensity (0: 0%, 0.02: 10%, 0.16: 100%, where 100% corresponds to $2.5W/m^2$, see Methods).
- `dat\*_annotated.csv`: for experiments in `dat\*_all.csv` which were annotated for wing movements (UWE or BWE). Same columns as in `dat\*_all.csv`, without *datename* and *box*, and with their corresponding measures in additional columns named *UWE* (unilateral wing extension) and *BWE* (bilateral wing extension).


## res
- `res\*_chisq.csv`:
    - *name*: Model type.
    - *Df*: Degrees of freedom.
    - *AIC*: Akaike Information Criterion.
    - *BIC*: Bayesian Information Criterion.
    - *logLik*: Log-likelihood.
    - *deviance*: Change in deviance.
    - *Chisq*: Chi-squared statistic.
    - *Chi Df*: Degrees of freedom associated with the Chi-squared test.
    - *Pr(>Chisq)*: p-value for the Chi-squared test
    - *strain*: Genotype of the flies used in the experiment.
    - *y*: Variable predicted in the model.
    - *analysis*: Identifier name to distinguish different playlist protocols (simple: only used silence or IPI of 36 ms; IPIs: used silence and IPIs of 16, 36 and 96 ms)
- `res\*_coeffs.csv`:
    - *Estimate*: Estimated weight for the corresponding variable.
    - *Std. Error*: Standard deviation on the weight estimate.
    - *z value*: Test statistic (Estimate / Std. Error).
    - *Pr(>|z|)*: p-value for the z-test
    - *model*: Model type.
    - *names*: Variable name.
    - *strain*: Genotype of the flies used in the experiment.
    - *y*: Variable predicted in the model.
    - *analysis*: Identifier name to distinguish different playlist protocols (simple: only used silence or IPI of 36 ms; IPIs: used silence and IPIs of 16, 36 and 96 ms).