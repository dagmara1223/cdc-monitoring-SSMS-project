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

### 🧩 Creating Main Table in SSMS
