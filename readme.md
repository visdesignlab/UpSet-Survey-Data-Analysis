# UpSet Descriptive Text Supplementary Materials

This repo contains the supplementary materials for our paper "Accessible Text Descriptions for UpSet Plots".
There are three major components to this repo:

- Data
- Analysis Notebooks
- LLM Study Artifact

# Data

We include both raw data and processed data used in the analysis.

| data file   | description |
| -------- | ------- |
| data/Both_data.csv | correctness  data for 'both' condition  |
| data/LLM-Study.tsv | the aggregated counts from the llm study |
| data/Survey_data.csv | responses of post survey questionnaire |
| data/Text_data.csv | correctness data for 'text' condition |
| data/Vis_data.csv | correctness  data for 'vis' condition |
| data/final-study-raw-2 | all the raw data for all the completed/ rejected/ returned participants |
| data/final-study.csv | data for all the participants who completed |
| data/participants/*.json | unmodified participant from Reivist |
| data/prep-pilot.csv | data having only prepilot and pilot participants (10) |
| data/prepilot-pilot-raw.csv | all the participants only in prepilot and pilot (returned/ completed/ rejected) |
| data/prolific-data/*.csv | unmodified data from Prolific |
| data/qual-coding.csv | coding of qualitative responses |
| data/qualitative-responses | qualitative responses from the survey |
| data/time-correctness-condition | correctness by condition (vis, text, both) and time duration spent per condition |
| data/notebook-data/*(.json or .csv) | datasets for python implementation notebook |


# Notebooks / Analysis

The notebooks in this repo are used to generate the data and figures in the paper or as a python implementation proof of concept.
There are 6 notebooks in this repo:

- notebooks/data-analysis-pilot.ipynb: This notebook contains the analysis of the pilot data. Generally this focuses on correctness of different formats
- notebooks/data-analysis.ipynb: This notebook contains the analysis of the main study data. This includes analysis of correctness, time, and preference data.
- notebooks/survey-analysis.ipynb: This notebook contains the analysis of the survey data. This includes analysis of preferences, demographics, and correlation between correctness and expertise. In addition it include analysis of the LLM study data.
- notebooks/time-analysis.ipynb: This notebook contains the analysis of the time data from the survey. 
- notebooks/upset_analyses_v1.R: This R script contains the code used to do significance testing on the data.
- notebooks/supplimentary_upsetplot.ipynb: This notebook contains a python implementation of UpSet (UpSetPlot) and a demonstration of text description generation through this package.

## Installation

Python requirements for the notebooks are described by the requirements.txt file. Installation of them occurs in the standard fashion:

```sh
# make a virtual environment
python3 -m venv venv
# activate it
source venv/bin/activate
# install the requirements
pip install -r requirements.txt
```

Notebooks were developed using the VSCode Jupyter notebook extension, but should work in other environments as well. For instance, to run the notebooks in Jupyter Lab, you can do the following:

```sh
jupyter-lab notebooks/survey-analysis.ipynb 
```

*Note*: The python implementation notebook (supplimentary_upsetplot.ipynb) is not able to be run due to the version of UpSetPlot used in the notebook being a fork of the main repository. For anonymity reasons during review, this fork will not be shared. We hope that the fork will be merged into the main package soon.

# LLM Study Artifact

Finally, we include the artifact for the LLM study. This includes the prompts used in the study and the coded responses. It is /LLM-Study-Artifact.pdf The contents of this data are summarized in the data/LLM-Study.tsv file.
