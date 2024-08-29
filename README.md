# Equipment-Investments-
To perform econometric analysis

**Introduction**

The main objective is to comprehensively test the effects of firm investments expenditures on training, capital equipment and other control variables. One of our main objectives is to conduct detailed econometric studies that will enable us to pin down the exact consequences of professionally trained employees and technologically updated equipment of companies on their profitability. This requires not just identifying and measuring the coefficients inside regression models but also evaluating these models in terms of their predictability across various sectors. Through a set of data cleaning procedures to handle outliers and missing values, running descriptive statistics and visualization techniques on data so as to know distribution and associations, we lay the groundwork for sophisticated analysis. 

The two models considered as simple and multiple regression analyses allow for in-depth investigation of interconnections between training, investments in equipment, and profits in order to highlight individual and combined effects. Lastly, we perform tests of homoscedasticity and use robust standard errors to ensure the validity of our results. Ultimately, the purpose is to aggregate these analyses into actionable insights and recommendations in order to provide companies with relevant information about training resources and equipment upgrades for improved profitability and operational efficiency. 

**Data and empirical approach** 
 
Describing the data 
The dataset is based on 962 firms which fall into Manufacturing, Services, and ICT sectors. The key variables are Log-transformed profit, training, equipment expenditure, Enterprise_Group and Firm_Age as company attributes. The purpose of the dataset is to assess the role of firm output and capital contributions in
determine productivity levels. A skewed distribution of the variables will be tackled by applying natural logarithms, so the issue will be resolved. The dataset particularly allows for the sector-based analysis and the inclusion of control variables. The project will be based on econometric analysis, enabling it to assess and show connections of training, equipment and profitability of firms as well as provide assistance to client firms in strategic decision-making. 
 
**Empirical Approach**
 
Data Preparation: 
• Installing and loading the packages for manipulating and analyzing data are conducted. 
• An analysis data is loaded from an Excel file, and appropriate labeling is done with the use of expss package. 
• Descriptive statistics are obtained to assess the distribution of variables and to search for possible problems such as zero profits or high leverage loans. 

Exploratory Data Analysis (EDA): 
• Descriptive statistics, box plots, histograms, and correlation matrices are generated to examine interrelationships among variables and spot possible outliers. 
• Scatterplots are plotted to depict the relationship between profits and training/equipment investments. 

Analysis of Associations: 
• Linear regression models are fitted to study the relationships of profits and training/equipment investments addressed separately (training_regression_model, equipment_regression_model) and as a whole (multiple_reg_model). 
• Control variables are added to multiple regression, in order to neutralize for possible interfering factors (control_var). 
• The small firm model (small_firm_model) and the large firm model (large_firm_model) are treated differently and are estimated in separate analyses.

**Descriptive Analysis**

Profits (log): The natural logarithm will provide this company with superbly high profits. The descriptive statistics display the profit levels spread in the data set with additional metrics such as mean and median to give a clear picture about the average of profit levels.  
Training Investments: Descriptive statistics on investments for training. These statistics give us an idea on the distribution and the variability of the training spending among firms indicating what the range is for investment and the measures of central tendency. 
Equipment Investments: Same as training, investment figures give the spread and concentrates distribution of investment in capital materials among the companies. Firm Age: Descriptive statistics for the age of firms. This component measures the time passed since the date of establishment of firms, and the data can be used to determine the number of firms in different age groups.  
Employees (log): The natural logarithm of the number of employees. These statistics inform on the firm size distribution, which is the number of employees that are used to measure the typical size of firms in the dataset.



