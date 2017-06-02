# Getting and Cleaning Data Course Project

## Overview
Repository with programming assignment from Coursera`s course project. From description:
>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

This project works with measurements data received from experiments that were performed by 'Human Activity Recognition Using Smartphones' group
Description from site:
>One of the most exciting areas in all of data science right now is wearable computing... Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

## Content
This repository contains next files:
1. R language script run_analysis.R that will do the following:
  - Download zip archive with 'Human Activity Recognition Using Smartphones Dataset'
  - unzip it
  - Read labels for measurements
  - Read train and test data measurements
  - Combine labels with mesurments datasets
  - Combine training and test datasets in one table
  - Filter only necessary for assignment measurements in result table
  - Perform calculation to groups of subject and their activities to determine final tidy data set
  - Save result dataset in file called tidy_data.txt
2. Code book CODEBOOK.md that describes variables and mesurments that were used in result tidy_data.txt file.