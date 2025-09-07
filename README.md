# cdc-monitoring-SSMS-project
Full Change Data Capture (CDC) implementation on SQL Server tables, with data correctness checks and scheduled jobs for automation. I will be using only one server in such example.  

# Project Description 📃  
One of the key advantages of Change Data Capture (CDC) is its ability to:  
- Transfer data in real time,  
- Provide control over which data is captured,  
- Improve efficiency by moving only changed records instead of the entire dataset,  
- Enhance data security through change tracking.  

In this project, I present skills I mainly developed during my internship at Orange.  
The workflow will include:  
1. Creating a SQL Server job for inserting any number of records into a table,  
2. Implementing several functions:
   - multi-use intelligent Insert / Update / Delete funcion,  
  - CDC to capture changes,  
  - A monitoring function to track modifications,  
  - A checksum validation function to verify data integrity
3. Finally, transferring the processed data.

### 🧩 Creating Main Table in SSMS and enabling SQL Server Agent  
Our first step is to open SSMS. Then, we start the SQL Server Agent by right-clicking on it and selecting Start. This step is required if we want to use jobs in our project.  
<img width="300" height="300" alt="image" src="https://github.com/user-attachments/assets/4091ed90-4d2e-40e9-b73e-018190819ddd" />   
Enabled SQL Server Agent should have green dot visible instead of red cross.  
Our next task is to create the main database with two tables: one as the source (from which the data will be transferred) and the other as the target (that will receive the data). <br>
We right-click on Databases -> New Database. Then we open New Query.    
You can find the SQL code that creates two tables here: ***SQL/create-table.sql*** <br>
Here are resuls for this part: <br>
<img width="331" height="335" alt="image" src="https://github.com/user-attachments/assets/e4c8c59e-c0f6-4ad3-ab94-92e308f11e99" />




