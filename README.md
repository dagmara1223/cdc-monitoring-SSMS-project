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

### 🧩 Creating Main Tables in SSMS and enabling SQL Server Agent  
Our first step is to open SSMS. Then, we start the SQL Server Agent by right-clicking on it and selecting Start. This step is required if we want to use jobs in our project.  
<img width="300" height="300" alt="image" src="https://github.com/user-attachments/assets/4091ed90-4d2e-40e9-b73e-018190819ddd" />   
Enabled SQL Server Agent should have green dot visible instead of red cross.  
Our next task is to create the main database with two tables: one as the source (from which the data will be transferred) and the other as the target (that will receive the data). <br>
We right-click on Databases -> New Database. Then we open New Query.    
You can find the SQL code that creates two tables here: ***SQL/create-table.sql*** <br>
Here are resuls for this part: <br>
<img width="331" height="335" alt="image" src="https://github.com/user-attachments/assets/e4c8c59e-c0f6-4ad3-ab94-92e308f11e99" />  <br>

### 🧩 Creating intelligent INSERT stored procedure  
This and the next two steps are crucial, as they will allow us to add, update, and delete any number of rows simply by executing a stored procedure. Once we have completed all three SQL scripts, we will then create an automated job to perform this task for us. <br> 
You can find code for this section here:  ***SQL/insert.sql*** <br>
<img width="700" height="700" alt="image" src="https://github.com/user-attachments/assets/741ebf36-dca3-4f3a-a84a-b2051d5509fd" />  
<br>

‼️ Warning: This photo comes from Modify option. To create such procedure you need to add **CREATE OR** before "ALTER PROCEDURE...". So the whole formula would look like: **CREATE OR ALTER PROCEDURE [dbo].[Inserting]......**

<br>
This solution offers a key advantage: you don't need to worry about the accuracy of primary keys and indexes during repeated executions. By declaring an @MaxID integer variable, we establish a dynamic insertion point. This ensures new batches of data are appended based on the highest existing index. For example, if the last index is 5 and you intend to insert 10 new records, the procedure will commence at index 6. <br>
You can find your stored procedure within Programmability folder :   <br>
<img width="297" height="230" alt="image" src="https://github.com/user-attachments/assets/1704c369-a00f-436e-a4a5-cbb978fa29ce" />   <br>
And for now, we simply test the procedure. So in your SQL Query execute 3 times:  
**EXEC [dbo].[Inserting]**   
<img width="300" height="300" alt="image" src="https://github.com/user-attachments/assets/5848da94-10cd-43bf-b4b3-0e0d484b66be" />   <br>
Supposing everything went well, after executing  "SELECT * FROM [dbo].[fromTable]" you can now see data being stored in your table.  <br>
<img width="500" height="572" alt="image" src="https://github.com/user-attachments/assets/b8aa52fe-7970-4255-b033-e2a10dc1866c" />  

### 🧩 Creating UPDATE stored procedure  
Our next goal is to create a stored procedure that will allow us to update data. Similar to the previous one, it will be executed with a single EXEC command.  
You can find code for this section here: ***SQL/updating.sql***   
<img width="700" height="700" alt="image" src="https://github.com/user-attachments/assets/4ebdd689-37e9-4bee-8314-daf17da50daa" />    

Please remember that this photo comes from Modify option. Look at warning in section **Creating intelligent INSERT stored procedure**.   

What distinguishes manually calling this procedure from the insert procedure is that when we call it, we have to specify which index to start from and how many changes we intend to make. For example, by calling **EXEC [dbo].[Updating] @StartID = 10, @RowCount = 100;**, we will start modifying data from index 10 up to index 109. <br>
<img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/b14bc1c1-4ecc-4c43-bbd4-4f6d1d64e50d" />   <br>
And for now, that makes two stored procedures in your Programmability folder. <br>
<img width="150" height="122" alt="image" src="https://github.com/user-attachments/assets/90f7431a-e697-41d6-90b9-ac5ad4a931c2" />  

### 🧩 Creating INITIAL LOAD stored procedure 















