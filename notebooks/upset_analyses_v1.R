# a script to analyze the data from the online UpSet plot study
# last updated on 9_05_24 by MM

# load packages and read them
library(tidyverse)
library(readr)
library(janitor)
library(dplyr)
library(lmerTest)
library(psych)
library(performance)

rm(list=ls()) # clear working environment

setwd("./data/Online Quant Study") # set working directory to correct folder 

# ----------------------- LOAD & PROCESS DATA -----------------------

# load in data
both_data <- read_csv("Both_data.csv")
text_data <- read_csv("Text_data.csv")
vis_data <- read_csv("Vis_data.csv")

# create condition variable 
both_data <- both_data %>% mutate(condition = "both")
text_data <- text_data %>% mutate(condition = "text")
vis_data <- vis_data %>% mutate(condition = "vis")

both_data$responsePrompt <- as.factor(both_data$responsePrompt) # change responsePrompt variable to read as a factor

# rename response prompts to correspond to question number in the manuscript
both_data$responsePrompt <- dplyr::recode(both_data$responsePrompt, 'How many sets are there?' = 'Q1',
                              'What is the largest set?' = 'Q2',
                              'What is the largest intersection?' = 'Q3',
                              'How large is the largest intersection?' = 'Q4',
                              'How many sets make up the largest intersection?' = 'Q5',
                              'How similar are the set sizes?' = 'Q6',
                              'Is the largest set present in the largest intersection?' = 'Q7',
                              'Is the all-set intersection (intersection having all the sets) present?' = 'Q8',)

# create variable of what data (tennis, organizaiton, COVID) participants are responding to
both_data$data <- sapply(strsplit(as.character(both_data$trialId), "-"), `[`, 1)

# convert to wide
both_data_wide <- both_data %>%
  select(participantId, data, condition, responsePrompt, isCorrectlyAnswered) %>%  # select relevant columns
  pivot_wider(names_from = responsePrompt, values_from = isCorrectlyAnswered) %>%  # reshape to wide format
  group_by(condition)  # group by condition

# recode correct answers to binary
both_data_wide <- both_data_wide %>%
  mutate(across(Q1:Q8, ~ ifelse(. == "True", 1, 0)))

text_data$responsePrompt <- as.factor(text_data$responsePrompt)
text_data$responsePrompt <- dplyr::recode(text_data$responsePrompt, 'How many sets are shown in the description?' = 'Q1',
                                          'What is the largest set?' = 'Q2',
                                          'What is the largest intersection?' = 'Q3',
                                          'How large is the largest intersection?' = 'Q4',
                                          'How many sets make up the largest intersection?' = 'Q5',
                                          'How similar are the set sizes?' = 'Q6',
                                          'Is the largest set present in the largest intersection?' = 'Q7',
                                          'Is the all-set intersection (intersection having all the sets) present?' = 'Q8',)
text_data$data <- sapply(strsplit(as.character(text_data$trialId), "-"), `[`, 1)

text_data_wide <- text_data %>%
  select(participantId, data, condition, responsePrompt, isCorrectlyAnswered) %>%  # relect relevant columns
  pivot_wider(names_from = responsePrompt, values_from = isCorrectlyAnswered) %>%  # reshape to wide format
  group_by(condition)  # group by condition

text_data_wide <- text_data_wide %>%
  mutate(across(Q1:Q8, ~ ifelse(. == "True", 1, 0)))

vis_data$responsePrompt <- as.factor(vis_data$responsePrompt)
vis_data$responsePrompt <- dplyr::recode(vis_data$responsePrompt, 'How many sets are shown in the upset plot?' = 'Q1',
                                          'What is the largest set?' = 'Q2',
                                          'What is the largest intersection?' = 'Q3',
                                          'How large is the largest intersection?' = 'Q4',
                                          'How many sets make up the largest intersection?' = 'Q5',
                                          'How similar are the set sizes?' = 'Q6',
                                          'Is the largest set present in the largest intersection?' = 'Q7',
                                          'Is the all-set intersection (intersection having all the sets) present?' = 'Q8',)
vis_data$data <- sapply(strsplit(as.character(vis_data$trialId), "-"), `[`, 1)

vis_data_wide <- vis_data %>%
  select(participantId, data, condition, responsePrompt, isCorrectlyAnswered) %>%  # select relevant columns
  pivot_wider(names_from = responsePrompt, values_from = isCorrectlyAnswered) %>%  # reshape to wide format
  group_by(condition) # group by condition

vis_data_wide <- vis_data_wide %>%
  mutate(across(Q1:Q8, ~ ifelse(. == "True", 1, 0)))

all_upset_data <- bind_rows(both_data, text_data, vis_data) # combine into one working data frame

# create separate data frame for after-survey questions
qual_questions <- all_upset_data %>%
  filter(isCorrectlyAnswered == "undefined")

# create separate data frame for all factual questions to eventually calculate correctness
factual_questions <- all_upset_data %>%
  filter(isCorrectlyAnswered != "undefined")

# recode correctness into binary for logistic regression
factual_questions <- factual_questions %>%
  mutate(isCorrectlyAnswered_rc = ifelse(isCorrectlyAnswered == "True", 1, 0))

# Assuming your dataframe is called factual_questions
factual_questions_wide <- factual_questions %>%
  select(participantId, condition, responsePrompt, isCorrectlyAnswered, data, trialOrder) %>%  # select relevant columns
  pivot_wider(names_from = responsePrompt, values_from = isCorrectlyAnswered) %>%  # reshape to wide format
  group_by(condition)  # group by condition

# recode answers into binary
factual_questions_wide <- factual_questions_wide %>%
  mutate(across(c(Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8), 
                ~ ifelse(. == "True", 1, 0), 
                .names = "{.col}_rc"))

# convert to wide formate
factual_questions_wide <- factual_questions_wide %>%
  group_by(participantId, condition) %>%
  mutate(correctness = mean(c_across(Q1_rc:Q8_rc), na.rm = TRUE)) %>%
  ungroup()

# remove questions from level 
factual_questions$responsePrompt <- droplevels(factual_questions$responsePrompt)

# convert from decimal to percentage 
factual_questions$isCorrectlyAnswered_rc <- 100*factual_questions$isCorrectlyAnswered_rc

# convert milliseconds into minutes
factual_questions$duration_mins <- factual_questions$cleaned_times/1000/60

# create new data frame of the qualitative questions
qual_questions$responsePrompt <- dplyr::recode(qual_questions$responsePrompt, 'How confident are you in your answers?' = 'confidence',
                                         'How effective was the content at conveying information?' = 'effectiveness',
                                         'How well did you understand the information presented?' = 'understanding',
                                         'How effective was the description of the data at conveying information?' = 'effectiveness',
                                         'How effective was the plot at conveying information?' = 'effectiveness')

# convert shape to wide
qual_questions_wide <- qual_questions %>%
  select(participantId, condition, responsePrompt, answer, data) %>%  # Select relevant columns
  pivot_wider(names_from = responsePrompt, values_from = answer) %>%  # Reshape to wide format
  group_by(condition)  # Group by condition if you need to further analyze by condition



# ----------------------- ANALYSIS: CORRECTNESS -----------------------

# run intercept only model to get between-subject variability
intercept_model <- lmer(isCorrectlyAnswered_rc ~ (1|participantId),
                            data = factual_questions)
icc(intercept_model) # to get intra-class correlation coefficient (ICC)


# MODEL 1: condition as only predictor
# dummy code with both as a reference
factual_questions$condition <- as.factor(factual_questions$condition) # convert to factor
factual_questions$data <- as.factor(factual_questions$data) # convert to factor
factual_questions$condition <- relevel(factual_questions$condition, ref = "both") # reference group set to both (combined)

correctness_model1 <- lmer(isCorrectlyAnswered_rc ~ condition + (1|participantId), data = factual_questions) 
summary(correctness_model1) # regression coefficients here!


# MODEL 2: add question number as second predictor
# effect code question/response prompt
factual_questions$responsePrompt <- as.factor(factual_questions$responsePrompt) # convert to factor
contrasts(factual_questions$responsePrompt) <- contr.sum(length(levels(factual_questions$responsePrompt))) # effect code
colnames(contrasts(factual_questions$responsePrompt)) <- levels(factual_questions$responsePrompt)[-length(levels(factual_questions$responsePrompt))] # keeps questions' name

correctness_model2 <- lmer(isCorrectlyAnswered_rc ~ condition * responsePrompt + (1|participantId), data = factual_questions) 
summary(correctness_model2) # regression coefficients here!

anova(correctness_model1, correctness_model2, test = "Chisq") # likelihood ratio test to compare model 1 to model 2


# MODEL 3: add data set as third predictor
# effect code question/response prompt
factual_questions$data <- as.factor(factual_questions$data)
factual_questions$data <- relevel(factual_questions$data, ref = "Tennis")

contrasts(factual_questions$data) <- contr.sum(length(levels(factual_questions$data)))
colnames(contrasts(factual_questions$data)) <- levels(factual_questions$data)[-length(levels(factual_questions$data))]

correctness_model3 <- lmer(isCorrectlyAnswered_rc ~ condition * responsePrompt * data + (1|participantId), data = factual_questions) 
summary(correctness_model3) # regression coefficents here!

anova(correctness_model2, correctness_model3, test = "Chisq") # likelihood ratio test to compare model 2 to model 3



# ----------------------- ANALYSIS: ORDER EFFECTS -----------------------

factual_questions$trialOrder <- as.factor(factual_questions$trialOrder) # convert to factor
factual_questions$condition <- relevel(factual_questions$condition, ref = "both") # set reference group as both (combined)

# effect code condition to interpret to grand mean
contrasts(factual_questions$condition) <- contr.sum(length(levels(factual_questions$condition)))
colnames(contrasts(factual_questions$condition)) <- levels(factual_questions$condition)[-length(levels(factual_questions$condition))]

factual_questions$trialOrder <- relevel(factual_questions$trialOrder, ref = "7") # set reference group to 7 (condition seen first)

order_effect <- lmer(isCorrectlyAnswered_rc ~ condition * trialOrder + (1|participantId), data = factual_questions) 
summary(order_effect) # regression coefficients here!



# ----------------------- ANALYSIS: COMPLETION TIME -----------------------

# run intercept only model to get between-subject variability
intercept_model_time <- lmer(duration_mins ~ (1|participantId), data = factual_questions)
icc(intercept_model_time) # to get intra-class correlation coefficient (ICC)

# MODEL: COMPLETION TIME
time_regression <- lmer(duration_mins ~ condition + (1|participantId), data = factual_questions) 
summary(time_regression) # regression coefficients here!



# ----------------------- ANALYSIS: CONFIDENCE, EFFECTIVENESS, UNDERSTANDABILITY  -----------------------

# MODEL: confidence
qual_questions_wide$condition <- as.factor(qual_questions_wide$condition) # convert to factor
qual_questions_wide$condition <- relevel(qual_questions_wide$condition, ref = "both") # set reference group to both (combined)

confidence_regression <- lm(confidence ~ condition, data = qual_questions_wide) 
summary(confidence_regression) # regression coefficients here!


# MODEL: understandability
understand_regression <- lm(understanding ~ condition, data = qual_questions_wide) 
summary(understand_regression) # regression coefficients here!


# MODEL: effectiveness
effectiveness_regression <- lm(effectiveness ~ condition, data = qual_questions_wide) 
summary(effectiveness_regression) # regression coefficients here!s