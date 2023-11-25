![Image](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-Machine_Learning-PYTHON/blob/main/Imagem1.jpg)
# PROJECT 1
# _Machine Learning & Python_

# My Intro
At the end of my postgraduation we have to do two projects to apply the knowledge we have acquired.

This first project is done in groups, will use CRISP-DM methodology and involves using Power BI to interpret the data, SQL to prepare it and Python to run machine learning models.

## Intro
For the development of this project we will use a [dataset](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/tree/main/Dataset) from an ecommerce company and we will have to solve 2 problems:
- Predict Next Order - Classification
- Client Segmentation - RFM Analysis

## Structure
The project must have this structure:
- CRISP-DM Methodology (without the Deployment)
- 2 algorithm minimum
- Confusion Matrix
- Performance measures: Accuracy, recall, precision, f1
- ROC curve (ROC score)
- Iteration: Cross-Validation, resampling; Play with Hyperparameters

## Business Understanding
We don't have any background on the business, but from the data provided we can assume that it is an e-commerce company selling a variety of products (from food to electronics).

The aim of the business is to increase sales and build customer loyalty.

The purpose of our work is to have a global view of customers by predicting whether past customers will buy in the future (6 months) and to suggest segmented marketing strategies for one or more identified customer groups.

To do this, we will use Power BI, SQL to check and prepare the data and Python to carry out the clustering (K-Mean) and classification models (Decision Trees, Random Forest, KNN and Logistic Regression).

## Data Understanding
### [_Power BI_](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Report/Relat%C3%B3rio%20Project%20I.pbix)
We imported all the tables into Power BI to check their data and relationships.

This is our dataset:
| **DIM_CUSTOMER** | |
| ------ | ------ |
| _Customer_id_ | It has the customer_id which is associated with the fct_orders table, but we can't use this column, otherwise it would mean that each order had a different customer, and there would be no "repetition" of customers |
| _Customer_unique_id_ | This column has duplicate ids |

| **DIM_PAYMENTS** | |
| ------ | ------ |
| _Order_id_ | Order id |
| _Payment_sequential_ | Order in which the different types of payment were made |
| _Payment_type_ | Type of payment method |
| _Payments_installments_ | ?? |
| _Payment_value_ | Total payment amount (price + freight value) |

| **DIM_PRODUCT** | |
| ------ | ------ |
| _Product_id_ | Product id |
| _Product_category_name_ | Product category name |
| _Product_name_lenght_ | Product name length |
| _Product_description_lenght_ | Length of product description |
| _Product_photos_qty_ | Number of product photos |
| _Product_weight_g_ | Product weight in grams |
| _Product_lenght_cm_ | Product length in centimeters |
| _Product_height_cm_ | Product height in centimeters |
| _Product_width_cm_ | Product width in centimeters |

| **FCT_ORDER_ITEM** | |
| ------ | ------ |
| _Order_id_ | Order id (has duplicate values) |
| _Order_item_id_ | ?? |
| _Product_id_ | Id of product sold in that order |
| _Seller_id_ | Seller id |
| _Shipping_limit_date_ | Deadline for sending the order |
| _Price_ | Order price |
| _Freight_value_ | Shipping costs |

| **FCT_ORDERS** | |
| ------ | ------ |
| _Order_id_ | Order id (99441 orders) |
| _Customer_id_ | Id of the customer, but there are no duplicates, so the connection must be made by customer_unique_id |
| _Order_status_ | Order status |
| _Order_purchase_timestamp_ | Date and time of order |
| _Order_approved_at_ | Date and time of order approval |
| _Order_delivered_carrier_date_ | Date and time of delivery to the carrier |
| _Order_delivered_customer_date_ | Date and time of delivery to the customer |
| _Order_estimated_delivery_date_ | Estimated delivery date |

**Conclusions**

- We found that for customer identification the column to use was _customer_unique_id_, because _customer_id_ had unique values in the _fct_orders_ table, which would mean that orders were always placed by a new customer
- This means that we need to remove the duplicate _customer_unique_id_ in the _dim_customer_ table:

![Count](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Count.png)

- We checked the types of order status and decided, in this first instance, to analyze only delivered orders:

![Order_status](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Order_status.png)

- We checked the number of products per order and added this feature to our analysis:

![Product_qty](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Product_qty.png)

- We checked the total number of orders per year and month to decide on the best cut-off point (orders from September 2016 to October 2018)
- Taking this analysis into account, the cut-off date was 01/03/2018. That's about 7 months earlier, since October orders are not very significant:

![Sales_year_month](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Sales_year_month.png)
![Cut-Off](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Cut-Off.png)


## Data Preparation & Exploration
### SQL & Python

- We made an analysis of the quality of the data provided through data profiling:

![Data_Profiling](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Data_Profiling.png)

- In SQL we created a dataset with all the tables and relationships between them (fct with dim)
- As the most relevant information for our analysis is found in the fact tables (_orders_ and _order_item_) we decided to join both tables and work from there to create our dataset:

![SQL](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/SQL.png)
![SQL](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/SQL1.png)
![SQL](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/SQL2.png)
![SQL](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/SQL3.png)

After that union:
- We changed the timestamp to date only, as the time will be irrelevant to our analysis
- We filtered the results only for the order status "delivered", because we want to analyze the orders that have gone through their entire process successfully so far
- We sorted the table by the most recent order date, because you can't sort by _order_id_ (these are - apparently - random sequences of numbers and letters)

![RFM](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/RFM.png)

- Since we are going to make a segmentation of customers, we are going to do an RFM analysis with the following variables: **Recency**, **Frequency** and **Monetary**
- All the other columns have been eliminated and we have a new dataset
- We did the data profiling of the new dataset and found that we have many duplicate lines. After analysis, we found that the duplication was due to the union of the two fact columns, because _fct_order_item_ records one line for each product purchased in the order. So if an order has more than one product, it will be represented by more than one line
- The joins have been revised and updated to left joins
- Query for creating the new dataset:

![Query_new_dataset](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Query_new_dataset.png)

- New dataset:

![New_dataset](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/New_dataset.png)

- Creation of target column (_match_): Binary variable (customer buys _"1"_ or does not buy _"0"_ in future block)
- Split the table (past and future) at the defined cut-off (01/03/2018)
- Creation of a new table (_"match"_) only with customers from the "past" who placed orders in the "future" (after the cut-off)
- Creation of the remaining features:

_Recency_ - Difference between the current date and the order date (in days) for each customer

_Frequency_ - number of _order_id_ per customer

_Monetary_ - sum of _total_paid_ per customer

_Products_ - number of products purchased per customer

- New dataset to be used for segmentation and classification models:

![Dataset_classification](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Dataset_classification.png)

- Data profiling of the new dataset:

![Data_Profiling_New](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Data_Profiling_New.png)


## Modeling - Customer Segmentation
### Python
[Notebook](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Notebooks/notebooks_customer_segmentation_notebook.html)

- Drop the _match_ column (not necessary for this study)
- Minimizing the skewness of features
- A skewness analysis showed that Frequency > 1 has very little weight (less than 3%):

![Skewness](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Skewness.png)

**First iteration**

- Removal of outliers (IQR method):

![Handling_Outliers](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Handling_Outliers.png)

- Data standardization:

![Standardization](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Standardization.png)

- Two methods were used to define the number of groups (K) - the _Elbow Method_ and the _Silhouette Score_ - which indicated that there were 3 groups:

![K](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/K.png)

- Application of K-Means (K = 3):

![Clusters](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Clusters.png)

![Clients_Clusters](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Clients_Clusters.png)

Snake plot analysis:
- The feature Frequency has no influence on the results
- Cluster 2 represents customers who have been buying for less 
time ago and have spent a lot of money (cluster with 18811 customers)
- It might be interesting to target a marketing campaign 
in order to further encourage purchases from these customers
- Customer segmentation was fairly even and balanced, 
i.e. the number of customers in each group is not too different


**Second iteration**

- Without removing outliers:

![With_Outliers](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/With_Outliers.png)

- Silhouette Score indicates that the best K is 2:

![Silhouette_Score](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Silhouette_Score.png)

- Application of K-Means: although the Silhouette Method indicates K=2, looking at the the data itself, it made sense to use K=3:

![K-Means](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/K-Means.png)

![Snake_Plot](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Snake_Plot.png)

Snake plot analysis

_Cluster 0_:
- Bought **recently**
- **Infrequently**
- Spent **some** money
- Bought **many** products

_Cluster 1_:
- **Most recently** bought
- **Infrequently**
- Spent **little** money
- Bought **few** products

_Cluster 2_:
- Bought **longer ago**
- **Very often**
- Spent a **lot** of money
- Bought a **lot** of products


## Evaluation
Considering the last two models analyzed (2 and 3), we found that cluster 2, which corresponds to 1,694 customers, although it seems insignificant in a universe of more than 50,000, are recent customers who place larger orders and "consume" more products. So we thought it would be important for marketing to retain them by running a campaign giving them a discount for their hundredth (for example) order.

**Start a marketing campaign for customers of Cluster 2 (encourage consumption by this group)**


## Data Preparation & Exploration
### Python
- For classification, three new features were added corresponding to the clusters obtained from segmentation (one hot encoding):

![Features](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Features.png)

- Outliers were removed, skewness and data were standardized


## Modeling - Next purchase predicted
### Python
[Notebook](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Notebooks/notebooks_Prediction.html)

- **Target:** _match_ variable ("1" customer will buy and "0" customer will not buy)
- Looking at the proportion of 0's and 1's in the _match_ column, you can see that the dataset is very unbalanced:

![Match](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Match.png)

- Train size = 70% and test size = 30%
- Models tested: Logistic Regression, K-nearest neighbors, Decision Tree and Random Forest
- The importance of each feature in the classification was quantified: in this case only the recency and monetary features have an impact on the model:

![Feature_RFM](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Feature_RFM.png)

- Confusion Matrix for each model:

![Confusion_Matrix](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Confusion_Matrix.png)

- Metrics for each model:

![Metrics](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Metrics.png)

- Analysis of the best classifier - **Decision Tree**:

![Decision_Tree](https://github.com/AnaPatSilva/PROJECT_1-Postgraduation_workgroup-MACHINE_LEARNING-PYTHON/blob/main/Images/Decision_Tree.png)

**Accuracy** (97,63%): The model correctly classified 98% of the two classes (_NC_ - Customers don't buy and _C_ - Customers buy)

**Precision** (3,92%): 3.9% of correctly classified cases are true positives (_C_)

**Recall** (3,21%): Only 3.2% of the positives (_C_) were correctly classified by the model

**F1 Score** (3,53%)

**AUC** (51%): The model is only 51% capable of distinguishing between the two classes (_NC_ and _C_)

- Although the classifier learns "0" very well, it is very poor at classifying "1s"
- As mentioned above, the dataset is very unbalanced (number of "1"s is 1%)
- By varying the cut-off date, the number of "1"s compared to "0"s is always much lower
- We can try to add more features or tuning some parameters in order to improve the classifier's metrics. However, due to such a large imbalance, it won't have much impact on the metrics.
- Grid and randomized search were carried out in order to find the best parameters to use in the random forest. As described above, there were no changes to the model metrics.
- A technique was implemented to apply different weights to the classes in an attempt to balance them, but also without effect.
- After analyzing the results, it can be concluded that there is no evidence that current customers will buy in the next 6 months


## Evaluation
- The project shows that, in business terms, **there is not much customer loyalty** (bear in mind that this may be a business decision)
- Based on the **segmentation** conducted, it may be interesting to start a marketing campaign for customers belonging to Cluster 2 (approximately 1,700 customers who have bought longer ago but very frequently, have spent a lot of money and bought a lot of products). For example, by giving discounts for the _x_ purchase
- There is **no evidence** that current customers (who have already bought) will buy again in the next 6 months (low metrics of the best classifier)
- To improve the classification model, it might make sense to use a **larger volume of data**, so that there is a better balance between "0" and "1"
- It might also make sense to analyze **cancelled orders** to see if they have a **negative impact on customer loyalty**


## Conclusions
This was a great challenge and a great way to put into practice everything we've learned.

With this project we were also able to think about how these models can be applied in the real world.
