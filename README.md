# cdc-monitoring-SSMS-project
Full Change Data Capture (CDC) implementation on SQL Server tables, with data correctness checks and scheduled jobs for automation. I will be using only one server in such example.  

# Project Description 📃  
One of the key advantages of Change Data Capture (CDC) is its ability to:  
- Transfer data in real time,  
- Provide control over which data is captured,  
- Improve efficiency by moving only changed records instead of the entire dataset,  
- Enhance data security through change tracking.  
 
The workflow will include:  
1. Creating a SQL Server job for inserting any number of records into a table,  
2. Implementing several functions:
   - multi-use intelligent Insert / Update / Delete funcion,  
   - CDC to capture changes, Initial Load, Enabling and Disabling CDC,     
   - A monitoring function to track modifications,  
   - A checksum validation function to verify data integrity
3. Finally, transferring the processed data.

### 🧩 Creating Main Tables in SSMS and enabling SQL Server Agent  
Our first step is to open SSMS. Then, we start the SQL Server Agent by right-clicking on it and selecting Start. This step is required if we want to use jobs (and cdc) in our project.  
<img width="300" height="300" alt="image" src="https://github.com/user-attachments/assets/4091ed90-4d2e-40e9-b73e-018190819ddd" />   
Enabled SQL Server Agent should have green dot visible instead of red cross.  
Our next task is to create the main database with two tables: one as the source (from which the data will be transferred) and the other as the target (that will receive the data). <br>
We right-click on Databases -> New Database. Then we open New Query.    
You can find the SQL code that creates two tables in folder: ***SQL/create-table.sql*** <br>
Here are resuls for this part: <br>
<img width="331" height="335" alt="image" src="https://github.com/user-attachments/assets/e4c8c59e-c0f6-4ad3-ab94-92e308f11e99" />  <br>

### 🧩 Creating intelligent INSERT stored procedure  
This and the next two steps are crucial, as they will allow us to add, update, and delete any number of rows simply by executing a stored procedure. Once we have completed all three SQL scripts, we will then create an automated job to perform this task for us. <br> 
You can find code for this section in folder:  ***SQL/insert.sql*** <br>
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
You can find code for this section in folder: ***SQL/updating.sql***   
<img width="700" height="700" alt="image" src="https://github.com/user-attachments/assets/4ebdd689-37e9-4bee-8314-daf17da50daa" />    

Please remember that this photo comes from Modify option. Look at warning in section **Creating intelligent INSERT stored procedure**.   

What distinguishes manually calling this procedure from the insert procedure is that when we call it, we have to specify which index to start from and how many changes we intend to make. For example, by calling **EXEC [dbo].[Updating] @StartID = 10, @RowCount = 100;**, we will start modifying data from index 10 up to index 109. <br>
<img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/b14bc1c1-4ecc-4c43-bbd4-4f6d1d64e50d" />   <br>
And for now, that makes two stored procedures in your Programmability folder. <br>
<img width="150" height="122" alt="image" src="https://github.com/user-attachments/assets/90f7431a-e697-41d6-90b9-ac5ad4a931c2" />  

### 🧩 Creating Enabling and Disabling CDC stored procedure  
#### 1. Enabling CDC ✅   
This procedure is very useful in such project because it allows us to enable Change Data Capture (CDC) on any table with a single command. Once executed, CDC is enabled both at the database and table level.<br>

When CDC is enabled, SQL Server automatically creates a set of **system tables** that store change history, including:    
- `cdc.change_tables` → metadata about captured tables,  
- `cdc.captured_columns` → details about tracked columns,  
- `cdc.lsn_time_mapping` → mapping between LSNs and transaction timestamps,  
- `cdc.dbo_<TableName>_CT` → the main change table with captured INSERT/UPDATE/DELETE operations. <br>

In the change table, a special column `__$operation` describes the type of operation:   
- **1** → DELETE  
- **2** → INSERT  
- **3** → UPDATE (before values)  
- **4** → UPDATE (after values)

If something goes wrong - cdc.dbo_<TableName>_CT should be our first suspect! 😁 <br>
You can find code for this section in folder: ***SQL/cdc_enable.sql***         
<img width="700" height="786" alt="image" src="https://github.com/user-attachments/assets/16917893-3390-4f18-b30b-f4270ee76200" />  
Programmability folder just gained another stored procedure and we are off to testing.  

‼️ Remember that your SQL Server Agent should be enabled. If you have any troubles - check out the  **Creating Main Tables in SSMS and enabling SQL Server Agent** section.  

<img width="500" height="330" alt="image" src="https://github.com/user-attachments/assets/e472692b-66ed-476c-88fb-eda4bd619730" />  

Now we can view the contents of additional tables that were created with our CDC:  

<img width="322" height="277" alt="image" src="https://github.com/user-attachments/assets/a778d96d-3751-4c12-839f-7ac90067b52e" />  

Remember that you can check and get familiar with them simply using SELECT statements as presented below:  
#### SELECT * FROM [cdc].[dbo_fromTable_CT]; 
#### SELECT * FROM [cdc].[lsn_time_mapping];
...   
#### 4. Disabling CDC ✅  
But why? you might ask. I’ve found it’s a great way to cope with the overwhelming number of things that aren’t working.   
📝 Let’s assume this scenario: your CDC procedure (not even created yet) fails. You keep trying to push data, it only gets worse, and—frustrated—you’re now tempted to delete all data from your tables. That’s both a good and a bad idea. Yes, we do want to clear the tables—but if you don’t disable CDC first, you’ll end up with even more chaos: extra change rows, a lot more data to sift through, and a flood of unwanted **DELETE** entries in the CT table.  

That is where procedure that disable CDC comes in handy.   
Code for this section in folder: ***SQL/disablingCDC.sql***

<img width="650" height="650" alt="image" src="https://github.com/user-attachments/assets/1fd357a5-2784-4bf8-8bf9-94378392e4a4" />  
<img width="650" height="650" alt="image" src="https://github.com/user-attachments/assets/442fb6f1-964b-41c1-a4e2-04d66ab250b6" />  
<img width="650" height="650" alt="image" src="https://github.com/user-attachments/assets/c9b819e6-5ee1-4662-a72c-159253441651" />  


You can now see that we gained great power to EXEC enable and disable :   
<img width="300" height="407" alt="image" src="https://github.com/user-attachments/assets/a3362e72-e9ca-4a22-b8dc-fb33644405f3" />  

‼️ Remember: system tables are created only when you enable CDC. Once you disable it, those tables are automatically removed and will no longer be accessible. In other words, they are completely cleaned up. This is important to keep in mind, because it means that all captured change data will be lost when CDC is disabled by you. So just make sure that your actions are fully thought out. For now we don't really have any important data that we want to tranfer but it will change within next sections.  

### 🧩 Loading Initial (Already Existing) Data    
The main core of Initial Load procedure is to load already existing data into target database before we start monitoring chanes using CDC. Golden steps here are:  
1️⃣ Verify the existence of the database and table.  
2️⃣ Check whether CDC is enabled — both at the database and table level.  
3️⃣ Validate the destination table.  
 - If they don’t exist, create the necessary tables and batches, then load the data.  
 - If they already exist, truncate the existing data before loading new records.  
4️⃣ Batch and transfer the data from the source to the destination.   

**Verifying existence of Database:**    
<img width="500" height="500" alt="image" src="https://github.com/user-attachments/assets/a066a9cc-4e55-4877-80d9-607f8658d7d4" />   

And the final approval:   
<img width="400" height="400" alt="image" src="https://github.com/user-attachments/assets/a190f30b-67fa-4770-be52-e4b82955d100" />

***Souce code: SQL/checking_database.sql***



























