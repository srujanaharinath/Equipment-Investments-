# The project focuses on multiple regression analysis, using firm level data.
# To complete the project, you need to have the following packages installed.


#Step 1 Install packages 
# Please note, the installations are commented out with # (take this out and the codes will run)

install.packages("tidyverse")
install.packages("magrittr")
install.packages("stargazer")
install.packages ("dplyr")

install.packages("writexl")

install.packages("car")
install.packages("lmtest")
install.packages("RCurl")
install.packages("readxl")
install.packages("expss")
install.packages("maditr")
install.packages("broom") 
install.packages("mosaic")



# Step 2: Loading packages (library command)
library(tidyverse)
library(magrittr)
library(stargazer)
library(dplyr)
library(writexl)
library(lmtest)
library (car)
library(readxl)
library(expss)
library(maditr)
library(broom) 
library(mosaic)
                
# import the function to calculate Robust Standard Erro from the Repo.

url_robust <- "https://raw.githubusercontent.com/IsidoreBeautrelet/economictheoryblog/master/robust_summary.R"
eval(parse(text = getURL(url_robust, ssl.verifypeer = FALSE)),
   envir=.GlobalEnv)

#don't worry if you get an error message. If you have an object names url_robust, you are okay!


# Step 3: set your directory and load the data (Ensure to save the data file in this folder)

setwd("C:/Users/Srujana/OneDrive/Desktop/Econometrics")

list.files()  #Do you see the data file?

data <- read_excel("Firm-profits_Data.xlsx")


# Apply the following labels to the data with package expss

data = apply_labels(data, 
                    ID = "Unique Identifier",
                    log_profits = "Firms profits in 2024 in Natural Logs",
                    log_training = "Total investments in Training between 2022 and 2023 in Logs",
                    log_equipment = "Total investments in Capital Equipment between 2022 and 2023 in Logs",
                    Enterprise_Group = "Does the firm belong to an Enterprise Group, 1 = Yes",
                    Firm_Age = "Year of the firm since registration to 2024",
                    Export_yes_no = "The firm is an exporting firm, 1= Yes",
                    Small_Firm = "The firm has fewer than 50 employees",
                    Industrial_sector = "Industrial Sector codes",
                    innovation_yes = "The firm introduced new products or services to market during 2022 ans 2023",
                    Employees_log = "Total number of employees in logs in 2024",
                    R_D_yes = "The firm invested in RD during 2022 and 2023, 1 = yes"
)

#Your a now set.Let's begin by populating the field for each of the points in the Instructions

#POINT 2:  Explore your data by running some descriptive statistics. 
#Do you sport anything that makes no sense? For example, can a firm have no profits? Are there any extreme values in our data?
#Tip if you want to exclude some observations, use the subset function.  Please ensure to justify why you are excluding them.

# to check the nulls values in the entire data frame
null_values <- colSums(is.na(data))
print(null_values)

head(data) #Display the first few rows of the dataset

summary(data) # summary statistics for all variables

# Check if there are firms with zero profits
if (any(data$log_profits == 0)) {
  print("There are firms with zero profits:")
} else {
  print("No firms with zero profits.")
}

# Summary statistics for all the variable
profits_summary <- summary(data$log_profits)
training_summary <- summary(data$log_training)
equipment_summary <- summary(data$log_equipment)
firm_age_summary <- summary(data$Firm_Age)
employees_summary <- summary(data$Employees_log)

# Combine summary statistics into a data frame
summary_table <- rbind(profits_summary, training_summary, equipment_summary, firm_age_summary, employees_summary)
rownames(summary_table) <- c("Profits", "Training Investments", "Equipment Investments", "Firm Age", "Employees (log)") # Add row names
print(summary_table)

# Create box plots for profits, training, and equipment investments and identify outliers
boxplot_firmage <- boxplot(data$Firm_Age, main = "Firm_Age", ylab = "Firm_Age (log scale)")
outliers_firmage <- boxplot_firmage$out
print("Outliers:")
print(paste("Firm_Age:", outliers_firmage))
data_filtered <- subset(data, !(Firm_Age %in% outliers_firmage))

boxplot_employees_log <- boxplot(data_filtered$Employees_log, main = "Employees_log", ylab = "Employees_log (log scale)")
outliers_employees_log <- boxplot_employees_log$out
print("Outliers:")
print(paste("Employees_log:", outliers_employees_log))

# Remove outliers from the dataset by using subset
data_filtered <- subset(data_filtered, !(Employees_log %in% outliers_employees_log))

# Create box plot for Firm Age without outliers
boxplot(data_filtered$Firm_Age, main = "Firm Age (Outliers Removed)", ylab = "Firm Age (log scale)")

# Create box plot for Employees log without outliers
boxplot(data_filtered$Employees_log, main = "Employees_log (Outliers Removed)", ylab = "Employess_log (log scale)")

boxplot(data_filtered[c('log_profits','log_training','log_equipment','Firm_Age', 'Employees_log')], main = 'Boxplot of Numerical Variables')

summary(data_filtered)
#POINT 3: Now that you have sorted your data, you can check for associations between the dependent and independent variables
#Do you see anything strange happening? Please keep in mind that a firm may decide not to invest in training. 

correlation_matrix <- cor(data_filtered)
print(correlation_matrix)

# Calculate correlation between log_profits and every other variable
profits_correlation <- cor(data_filtered$log_profits, data_filtered)
print(profits_correlation)

firm_scatterplot <- ggplot(data = data_filtered, aes(x = log_training, y = log_profits)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Association between Training and Profits",
       x = "Training (log scale)",
       y = "Profits (log scale)")

print(firm_scatterplot)

equipment_scatterplot <- ggplot(data = data_filtered, aes(x = log_equipment, y = log_profits)) +
  geom_point()+
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Association between Equipment and Profits",
       x = "Equipment (log scale)",
       y = "Profits (log scale)")

print(equipment_scatterplot)

histogram_equipment <- ggplot(data, aes(x = log_equipment)) +geom_histogram()
print(histogram_equipment)

# Select categorical variables
categorical_vars <- data_filtered %>%
  select(Enterprise_Group, Export_yes_no, Small_Firm, Industrial_sector, innovation_yes, R_D_yes)

# Function to plot bar chart for each categorical variable
plot_bar_chart <- function(column_name) {
  # Calculate frequencies
  frequency_table <- table(data_filtered[[column_name]])
  
  # Convert frequency table to data frame
  frequency_df <- as.data.frame(frequency_table)
  colnames(frequency_df) <- c("Category", "Frequency")
  
  # Plot bar chart
  bar_chart <- ggplot(frequency_df, aes(x = Category, y = Frequency, fill = Category)) +
    geom_bar(stat = "identity") +
    labs(title = paste("Bar Chart for", column_name),
         x = "Category",
         y = "Frequency") +
    theme_minimal()
  
  return(bar_chart)
}

# Plot bar charts for each categorical variable
bar_charts <- lapply(names(categorical_vars), function(var) plot_bar_chart(var))


for (chart in bar_charts) {
  print(chart)
}

#POINT 4: Great, your data is ready. Time time to run some analysis.

#Y= Profits and X = training

training_regression_model <- ggplot(data_filtered, aes(x = log_training, y = log_profits)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "green") +
  labs(title = "Analysis between Profits and Training",
       x = "Training (log scale)",
       y = "Profits (log scale)")

print(training_regression_model)

# Fit linear regression model for Profits vs. Training
training_model_lm <- lm(log_profits ~ log_training, data = data_filtered)

#Y= Profits and X= Equipment

equipment_regression_model <- ggplot(data_filtered, aes(x = log_equipment, y = log_profits)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Analysis between Profits and Equipment",
       x = "Equipment (log scale)",
       y = "Profits (log scale)")

print(equipment_regression_model)

# Fit linear regression model for Profits vs. Equipment
equipment_lm <- lm(log_profits ~ log_equipment, data = data_filtered)

#Point 5: Y= Profits and X1 = training and X2 = Equipment.

multiple_reg_model <- lm(log_profits ~ log_training + log_equipment, data = data_filtered)

#Point 6: Do point 5 with all other (suitable) control variables

control_var <- lm(log_profits ~ log_training + log_equipment + Enterprise_Group+
                            Small_Firm + Export_yes_no + innovation_yes+ Firm_Age + Employees_log + R_D_yes, data = data_filtered)

data_small_firm <- subset(data_filtered, Small_Firm == 1)
data_large_firm <- subset(data_filtered, Small_Firm == 0)

small_firm_model <- lm(log_profits ~ log_training + log_equipment + Enterprise_Group+
                        Export_yes_no + innovation_yes+ Firm_Age + Employees_log + R_D_yes, data = data_small_firm)

large_firm_model <- lm(log_profits ~ log_training + log_equipment + Enterprise_Group+
                          Export_yes_no + innovation_yes+ Firm_Age + Employees_log + R_D_yes, data = data_large_firm)

#Point 7: For model in Point 6, check for Heteroskedasticity.

residual <- rstandard(control_var)
fit <- fitted(control_var)
plot(residual,fit)
hist(residual)

bp_test <- bptest(control_var, studentize = TRUE)
print(bp_test)
 

#Finally, produce a regression table with all outputs from Points 4 to 6, and ensure to use Robust Standard Errors.
#tip, to obtain robust standard errors, use the "summary(model_name, robust=T). this will use the URl_robust function to compute them.

summary(training_model_lm, robust=T)
summary(equipment_lm, robust=T)
summary(multiple_reg_model, robust=T)
summary(control_var, robust=T)
summary(small_firm_model, robust=T)
summary(large_firm_model, robust=T)


