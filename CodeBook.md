# Code book
The original data on which this analysis was performed came from [UCI's machine learning repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). A description of this data can be found at `data/README.txt` after running the `download_dataset.R` script.

The resulting dataset can be found at `uci_har_analysis.csv` after running `run_analysis.R`

Data from subjects in test and training groups were combined. For each measurement in the original data, only the means and standard deviations were included. The activity codes were given a more verbose name (based on `data/activity_labels.txt`). For each subject and each activity, an average was calculated for each original feature measurement. Signal types, spatial coordinates and measurement types were seperated from the original feature names. Features which do not have an associated coordinate (e.g. magnitudes of 3-dim signals) were given `NA` coordinate values.

The resulting dataset (`uci_har_analysis.csv`) contains 7 columns:
- __subject__: Identifier for one of the 30 subjects on which the experiment was performed.
- __activity__: The activity the subject was performing when the measurement was obtained.
- __feature__: The measured feature. All features were derived from the accerometer and gyroscope raw signals in every spatial dimension in the origin data.
- __signaltype__: The type of measurement for each feature (time or frequency).
- __coordinate__: Spatial dimension of measured feature, if applicable.
- __measurement__: Type of measurement for each feature (mean or std).
- __average__: Average of measurements for each subject, each activity and each feature.

