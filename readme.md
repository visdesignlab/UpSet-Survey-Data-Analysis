# UpSet Descriptive Text Supplementary Materials

This repo contains the supplementary materials for our paper "Accessible Text Descriptions for UpSet Plots".
There are three major components to this repo:

- Data
- Analysis Notebooks
- LLM Study Artifact

# Data



# Notebooks / Analysis

The notebooks in this repo are used to generate the data and figures in the paper. 
There are 5 notebooks in this repo:

- notebooks/data-analysis-pilot.ipynb: This notebook contains the analysis of the pilot data. Generally this focuses on correctness of different formats
- notebooks/data-analysis.ipynb: This notebook contains the analysis of the main study data. This includes analysis of correctness, time, and preference data.
- notebooks/survey-analysis.ipynb: This notebook contains the analysis of the survey data. This includes analysis of preferences, demographics, and correlation between correctness and expertise. In addition it include analysis of the LLM study data.
- notebooks/time-analysis.ipynb: This notebook contains the analysis of the time data from the survey. 
- notebooks/upset_analyses_v1.R: This R script contains the code used to do significance testing on the data.

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

# LLM Study Artifact

Finally, we include the artifact for the LLM study. This includes the prompts used in the study and the coded responses. It is LLM-Study-Artifact.pdf The contents of this data are summarized in the data/LLM-Study.tsv file.
