# CPI Analysis Tool

## Description
The CPI Analysis Tool is a Shiny application that allows users to analyze the Consumer Price Index (CPI) over time. It provides visualizations of CPI trends and enables users to convert dollar values between different periods, facilitating an understanding of inflation and the real value of money.

## Features
- **CPI Evolution Visualization**: View CPI trends over selected time periods.
- **Dollar Value Converter**: Convert dollar amounts between different base and current periods.

## How to Run the App
1. Make sure you have R and RStudio installed on your machine.

2. Install the required packages if you haven’t already:
   ```R
   install.packages(c("shiny", "ggplot2"))

3. Open RStudio and set the working directory to the project folder:
setwd("path/to/your/project/folder")

4.Run the app using the following command:
shiny::runApp()