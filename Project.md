## T echnical and Scientific P rogramming

P royect

## Delivery date

D ecember 10, 2025

## Instructions

T he project involves completing the initial 4 stages of the scientific data process, which include p roblem framing, as well as data collection, preparation, and visualisation. The following steps w ill guide the completion of this task:

- 1 . Selecting the dataset. A dataset of interest should be chosen from well-known r epositories introduced in class, such as Kaggle or WHO.

- 2 . Loading the dataset into the environment. In class, we learned about various methods o f loading information based on the file type. It is important to select the most suitable o ption for each case along with the optimal parameters.

- 3 . Data cleaning. Any type of cleaning required by the chosen data should be carried out. C heck for missing data (both explicitly and implicitly) and, if so, choose one of the a pproaches discussed in class to deal with them. Also, check for the presence of outliers a nd deal with them appropriately. If no missing values or outliers are detected, this shall b e reflected in the documentation.

- 4 . Data integration. If several files have been chosen, their integration must be carried out c orrectly.

- 5 . Data transformation. At this stage, it is essential to prepare the data effectively for s ubsequent analysis, and all required transformations should be done using the dplyr p ackage. At least 3 functions should be used.

- 6 . Data exploration. During the data exploration phase, a deeper understanding of the d ataset will be achieved. This involves identifying correlations between variables and d rawing insightful conclusions. Various graphs using tools such as ggplot2 must also be g enerated to facilitate comprehension of the data, with each graph leading to meaningful i nterpretations or explanations based on its findings. (3 different graphs at least)

- 7 . Web application. Create a web application for visualising the graphics generated in the p revious section. The graphics must be dynamic.

## Delivery

All R scripts needed to implement the sections, as well as documentation detailing the basis for the dataset selection, a description of the dataset, and an explanation of each of the stages mentioned above, must be given.

## Proposed index of documentation

- 1. Introduction: What is this document? What is it for? What is its structure? (max 1 page)

- 2. Dataset: Complete description of the dataset and the reason for its choice.

- 3. Dataset loading: Explanation of the functions and parameters used for loading and the reasoning followed.

- 4. Data cleaning: Explanation of all the steps followed and not followed for data cleaning (If I did not need to deal with missing values, explain why not).


## T echnical and Scientific P rogramming

- 5. (Optional) Data integration: this section is only necessary if more than one data file has been used. Explain the criteria followed to merge them into a single data frame.

- 6. Data transformation*: The transformations made and the reasons behind them are described.

- 7. Data exploration: Explanation of the graphs to be extracted and why. Captures of all the graphs and conclusions obtained from each one of them. *(If data transformations were carried out to create the graphs, they might be included in this section).

- 8. Web application: Description of the application and pictures of its interface.

## E valuation Rubric

E ach section will be scored on a scale from 0 to 2 :

- 0 = Not completed

- 1 = Partially completed or unfinished

- 2 = Well done and fully completed

N ote: When the instructions specify a minimum requirement , that minimum corresponds to t he level expected for a score of 5 (pass) , not for the highest score (10).

| S ection | C riterion | D escription |
| --- | --- | --- |
| D ata Preparation | L oading | D ata are correctly imported from the source with |
|   |   | a ppropriate file handling and format verification. |
|   | C leaning | M issing values, duplicates, and inconsistencies |
|   |   | a re properly handled. |
|   | T ransformation | D ata are correctly formatted, encoded, and |
|   |   | s tructured for analysis and modelling. |
| E xploratory Data | E xploration | R elevant descriptive statistics and visualisations |
| A nalysis (EDA) |   | a re provided. Patterns, anomalies, and |
|   |   | r elationships are identified and discussed. |
| W eb App | F unctionality | T he web application runs correctly, is |
|   |   | u ser-friendly, and allows meaningful interaction |
|   | w ith the data. |   |
|   | F eatures | A ll key features required in the project |
|   |   | d escription are implemented. |


|   |   | T echnical and Scientific P royect |
| --- | --- | --- |
|   |   | P rogramming |
| D ocumentation | C larity | C lear explanations of data preparation, analysis |
|   |   | p rocess, and application functionality. |
|   | S tructure | D ocumentation is well-organized, complete, and |
|   |   | e asy to follow. |
