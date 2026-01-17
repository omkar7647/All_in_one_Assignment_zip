
-- ---------------------------------------------------- ** Assignment from zip ** -----------------------------------------------------------------------

create database zip_assignment;
use zip_assignment;

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Account table
CREATE TABLE sy_account (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- User table
CREATE TABLE ab_user (
    id INT PRIMARY KEY,
    username VARCHAR(255),
    account_id INT,
    FOREIGN KEY (account_id) REFERENCES sy_account(id)
);

-- Application Module table
CREATE TABLE sy_app_module (
    app_id INT PRIMARY KEY,
    application_id INT,
    app_code VARCHAR(100),
    app_name VARCHAR(255)
);

-- Application table
CREATE TABLE sy_application (
    application_id INT PRIMARY KEY,
    application_name VARCHAR(255),
    application_description TEXT,
    account_id INT,
    FOREIGN KEY (account_id) REFERENCES sy_account(id)
);

-- Model table
CREATE TABLE in_model (
    model_id INT PRIMARY KEY,
    application_id INT,
    model_name VARCHAR(255),
    model_description TEXT,
    modified_by INT,
    app_id INT,
    FOREIGN KEY (application_id) REFERENCES sy_application(application_id),
    FOREIGN KEY (app_id) REFERENCES sy_app_module(app_id)
);

-- Workspace table
CREATE TABLE in_workspace (
    workspace_id INT PRIMARY KEY,
    model_id INT,
    workspace_name VARCHAR(255),
    FOREIGN KEY (model_id) REFERENCES in_model(model_id)
);

-- Timeseries Version table
CREATE TABLE in_timeseries_version (
    version_id INT PRIMARY KEY,
    version_name VARCHAR(255),
    workspace_id INT,
    modified_by INT,
    modified_time TIMESTAMP,
    FOREIGN KEY (workspace_id) REFERENCES in_workspace(workspace_id)
);

-- Material table
CREATE TABLE in_material (
    material_id INT PRIMARY KEY,
    material_name VARCHAR(255),
    workspace_id INT,
    FOREIGN KEY (workspace_id) REFERENCES in_workspace(workspace_id)
);

-- Resource (Geography) table
CREATE TABLE in_resource (
    resource_id INT PRIMARY KEY,
    resource_name VARCHAR(255),
    workspace_id INT,
    geography_dimension_id INT,
    FOREIGN KEY (workspace_id) REFERENCES in_workspace(workspace_id)
);

-- Time Dimension table
CREATE TABLE in_time_dimension (
    time_dimension_id INT PRIMARY KEY,
    time_dimension_name VARCHAR(255),
    workspace_id INT,
    FOREIGN KEY (workspace_id) REFERENCES in_workspace(workspace_id)
);

-- Timeseries table
CREATE TABLE in_timeseries (
    ts_id INT PRIMARY KEY,
    material_id INT,
    geography_id INT,
    time_level INT,
    workspace_id INT,
    FOREIGN KEY (material_id) REFERENCES in_material(material_id),
    FOREIGN KEY (geography_id) REFERENCES in_resource(resource_id),
    FOREIGN KEY (time_level) REFERENCES in_time_dimension(time_dimension_id),
    FOREIGN KEY (workspace_id) REFERENCES in_workspace(workspace_id)
);

-- Timeseries Data table
CREATE TABLE in_timeseries_data (
    ts_data_id INT PRIMARY KEY,
    ts_id INT,
    ddttime TIMESTAMP,
    data DECIMAL(18,6),
    version_id INT,
    workspace_id INT,
    FOREIGN KEY (ts_id) REFERENCES in_timeseries(ts_id),
    FOREIGN KEY (version_id) REFERENCES in_timeseries_version(version_id),
    FOREIGN KEY (workspace_id) REFERENCES in_workspace(workspace_id)
);

--------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO sy_account (id, name) VALUES
(1,'Retail Corp'),
(2,'Manufacturing Ltd'),
(3,'Logistics Inc'),
(4,'Energy Group'),
(5,'Healthcare Org'),
(6,'Finance Co'),
(7,'Ecommerce Pvt'),
(8,'Telecom Services'),
(9,'Agri Solutions'),
(10,'Automobile Corp');

INSERT INTO ab_user (id, username, account_id) VALUES
(1,'admin_retail',1),(2,'user_retail',1),
(3,'admin_mfg',2),(4,'user_mfg',2),
(5,'admin_log',3),(6,'user_log',3),
(7,'admin_energy',4),(8,'user_energy',4),
(9,'admin_health',5),(10,'user_health',5),
(11,'admin_fin',6),(12,'user_fin',6),
(13,'admin_ecom',7),(14,'user_ecom',7),
(15,'admin_tel',8),(16,'user_tel',8),
(17,'admin_agri',9),(18,'user_agri',9),
(19,'admin_auto',10),(20,'user_auto',10);

INSERT INTO sy_app_module (app_id, application_id, app_code, app_name) VALUES
(1,1,'FCST','Forecasting'),
(2,1,'INV','Inventory'),
(3,2,'PLAN','Planning'),
(4,2,'OPT','Optimization'),
(5,3,'SUP','Supply'),
(6,4,'DEM','Demand'),
(7,5,'REP','Reporting'),
(8,6,'ANL','Analytics'),
(9,7,'ML','Machine Learning'),
(10,8,'AI','AI Engine');

INSERT INTO sy_application
(application_id, application_name, application_description, account_id)
VALUES
(1,'Retail Forecast','Retail demand forecast',1),
(2,'Manufacturing Plan','Factory planning',2),
(3,'Logistics Track','Shipment tracking',3),
(4,'Energy Forecast','Energy load forecast',4),
(5,'Health Analytics','Hospital analytics',5),
(6,'Finance Risk','Risk modeling',6),
(7,'Ecom Insights','Customer analytics',7),
(8,'Telecom Usage','Usage prediction',8),
(9,'Agri Yield','Crop forecasting',9),
(10,'Auto Sales','Vehicle demand',10);

INSERT INTO in_model
(model_id, application_id, model_name, model_description, modified_by, app_id)
VALUES
(1,1,'Retail_ARIMA','ARIMA model',1,1),
(2,1,'Retail_LSTM','LSTM model',1,9),
(3,2,'Mfg_PLAN','Planning model',3,3),
(4,3,'Logi_SUP','Supply model',5,5),
(5,4,'Energy_LSTM','Energy LSTM',7,9),
(6,5,'Health_STAT','Stat model',9,7),
(7,6,'Finance_VAR','VAR model',11,8),
(8,7,'Ecom_ML','ML model',13,9),
(9,8,'Telecom_AI','AI model',15,10),
(10,9,'Agri_Yield','Yield model',17,1),
(11,10,'Auto_Sales','Sales model',19,1),
(12,2,'Mfg_OPT','Optimization',3,4),
(13,3,'Logi_OPT','Route optimizer',5,4),
(14,4,'Energy_DEM','Demand model',7,6),
(15,7,'Ecom_REP','Reporting model',13,7);

INSERT INTO in_workspace (workspace_id, model_id, workspace_name) VALUES
(1,1,'Retail_WS1'),(2,2,'Retail_WS2'),
(3,3,'Mfg_WS1'),(4,4,'Logi_WS1'),
(5,5,'Energy_WS1'),(6,6,'Health_WS1'),
(7,7,'Finance_WS1'),(8,8,'Ecom_WS1'),
(9,9,'Telecom_WS1'),(10,10,'Agri_WS1'),
(11,11,'Auto_WS1'),(12,12,'Mfg_WS2'),
(13,13,'Logi_WS2'),(14,14,'Energy_WS2'),
(15,15,'Ecom_WS2');

INSERT INTO in_timeseries_version
(version_id, version_name, workspace_id, modified_by, modified_time)
SELECT
n,
CONCAT('v', n),
((n - 1) % 15) + 1,
1,
NOW()
FROM (
  SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
  SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL
  SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL
  SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL
  SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL
  SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL
  SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL
  SELECT 29 UNION ALL SELECT 30
) t;


INSERT INTO in_material (material_id, material_name, workspace_id)
SELECT
n,
CONCAT('Material_', n),
((n - 1) % 15) + 1
FROM (
  SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
  SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL
  SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL
  SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL
  SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL
  SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL
  SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL
  SELECT 29 UNION ALL SELECT 30 UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL
  SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35 UNION ALL SELECT 36 UNION ALL
  SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40 UNION ALL
  SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44 UNION ALL
  SELECT 45 UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL SELECT 48 UNION ALL
  SELECT 49 UNION ALL SELECT 50
) t;

INSERT INTO in_resource
(resource_id, resource_name, workspace_id, geography_dimension_id)
SELECT
n,
CONCAT('Region_', n),
((n - 1) % 15) + 1,
n
FROM (
  SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
  SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL
  SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL
  SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL
  SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL
  SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL
  SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL
  SELECT 29 UNION ALL SELECT 30
) t;

INSERT INTO in_time_dimension
(time_dimension_id, time_dimension_name, workspace_id)
VALUES
(1,'Daily',1),(2,'Weekly',2),(3,'Monthly',3),(4,'Quarterly',4),(5,'Yearly',5),
(6,'Daily',6),(7,'Weekly',7),(8,'Monthly',8),(9,'Quarterly',9),(10,'Yearly',10);

INSERT INTO in_timeseries
(ts_id, material_id, geography_id, time_level, workspace_id)
SELECT
n,
((n - 1) % 50) + 1,
((n - 1) % 30) + 1,
((n - 1) % 10) + 1,
((n - 1) % 15) + 1
FROM (
  SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
  SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL
  SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL
  SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL
  SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL
  SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL
  SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL
  SELECT 29 UNION ALL SELECT 30 UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL
  SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35 UNION ALL SELECT 36 UNION ALL
  SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40 UNION ALL
  SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44 UNION ALL
  SELECT 45 UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL SELECT 48 UNION ALL
  SELECT 49 UNION ALL SELECT 50 UNION ALL SELECT 51 UNION ALL SELECT 52 UNION ALL
  SELECT 53 UNION ALL SELECT 54 UNION ALL SELECT 55 UNION ALL SELECT 56 UNION ALL
  SELECT 57 UNION ALL SELECT 58 UNION ALL SELECT 59 UNION ALL SELECT 60 UNION ALL
  SELECT 61 UNION ALL SELECT 62 UNION ALL SELECT 63 UNION ALL SELECT 64 UNION ALL
  SELECT 65 UNION ALL SELECT 66 UNION ALL SELECT 67 UNION ALL SELECT 68 UNION ALL
  SELECT 69 UNION ALL SELECT 70 UNION ALL SELECT 71 UNION ALL SELECT 72 UNION ALL
  SELECT 73 UNION ALL SELECT 74 UNION ALL SELECT 75 UNION ALL SELECT 76 UNION ALL
  SELECT 77 UNION ALL SELECT 78 UNION ALL SELECT 79 UNION ALL SELECT 80 UNION ALL
  SELECT 81 UNION ALL SELECT 82 UNION ALL SELECT 83 UNION ALL SELECT 84 UNION ALL
  SELECT 85 UNION ALL SELECT 86 UNION ALL SELECT 87 UNION ALL SELECT 88 UNION ALL
  SELECT 89 UNION ALL SELECT 90 UNION ALL SELECT 91 UNION ALL SELECT 92 UNION ALL
  SELECT 93 UNION ALL SELECT 94 UNION ALL SELECT 95 UNION ALL SELECT 96 UNION ALL
  SELECT 97 UNION ALL SELECT 98 UNION ALL SELECT 99 UNION ALL SELECT 100
) t;

INSERT INTO in_timeseries_data
(ts_data_id, ts_id, ddttime, data, version_id, workspace_id)
SELECT
n,
((n - 1) % 100) + 1,
DATE_ADD('2024-01-01', INTERVAL n DAY),
ROUND(RAND() * 1000, 2),
((n - 1) % 30) + 1,
((n - 1) % 15) + 1
FROM (
  SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
  SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL
  SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL
  SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL
  SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL
  SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL
  SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL
  SELECT 29 UNION ALL SELECT 30 UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL
  SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35 UNION ALL SELECT 36 UNION ALL
  SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40 UNION ALL
  SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44 UNION ALL
  SELECT 45 UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL SELECT 48 UNION ALL
  SELECT 49 UNION ALL SELECT 50 UNION ALL SELECT 51 UNION ALL SELECT 52 UNION ALL
  SELECT 53 UNION ALL SELECT 54 UNION ALL SELECT 55 UNION ALL SELECT 56 UNION ALL
  SELECT 57 UNION ALL SELECT 58 UNION ALL SELECT 59 UNION ALL SELECT 60 UNION ALL
  SELECT 61 UNION ALL SELECT 62 UNION ALL SELECT 63 UNION ALL SELECT 64 UNION ALL
  SELECT 65 UNION ALL SELECT 66 UNION ALL SELECT 67 UNION ALL SELECT 68 UNION ALL
  SELECT 69 UNION ALL SELECT 70 UNION ALL SELECT 71 UNION ALL SELECT 72 UNION ALL
  SELECT 73 UNION ALL SELECT 74 UNION ALL SELECT 75 UNION ALL SELECT 76 UNION ALL
  SELECT 77 UNION ALL SELECT 78 UNION ALL SELECT 79 UNION ALL SELECT 80 UNION ALL
  SELECT 81 UNION ALL SELECT 82 UNION ALL SELECT 83 UNION ALL SELECT 84 UNION ALL
  SELECT 85 UNION ALL SELECT 86 UNION ALL SELECT 87 UNION ALL SELECT 88 UNION ALL
  SELECT 89 UNION ALL SELECT 90 UNION ALL SELECT 91 UNION ALL SELECT 92 UNION ALL
  SELECT 93 UNION ALL SELECT 94 UNION ALL SELECT 95 UNION ALL SELECT 96 UNION ALL
  SELECT 97 UNION ALL SELECT 98 UNION ALL SELECT 99 UNION ALL SELECT 100 UNION ALL
  SELECT 101 UNION ALL SELECT 102 UNION ALL SELECT 103 UNION ALL SELECT 104 UNION ALL
  SELECT 105 UNION ALL SELECT 106 UNION ALL SELECT 107 UNION ALL SELECT 108 UNION ALL
  SELECT 109 UNION ALL SELECT 110 UNION ALL SELECT 111 UNION ALL SELECT 112 UNION ALL
  SELECT 113 UNION ALL SELECT 114 UNION ALL SELECT 115 UNION ALL SELECT 116 UNION ALL
  SELECT 117 UNION ALL SELECT 118 UNION ALL SELECT 119 UNION ALL SELECT 120 UNION ALL
  SELECT 121 UNION ALL SELECT 122 UNION ALL SELECT 123 UNION ALL SELECT 124 UNION ALL
  SELECT 125 UNION ALL SELECT 126 UNION ALL SELECT 127 UNION ALL SELECT 128 UNION ALL
  SELECT 129 UNION ALL SELECT 130 UNION ALL SELECT 131 UNION ALL SELECT 132 UNION ALL
  SELECT 133 UNION ALL SELECT 134 UNION ALL SELECT 135 UNION ALL SELECT 136 UNION ALL
  SELECT 137 UNION ALL SELECT 138 UNION ALL SELECT 139 UNION ALL SELECT 140 UNION ALL
  SELECT 141 UNION ALL SELECT 142 UNION ALL SELECT 143 UNION ALL SELECT 144 UNION ALL
  SELECT 145 UNION ALL SELECT 146 UNION ALL SELECT 147 UNION ALL SELECT 148 UNION ALL
  SELECT 149 UNION ALL SELECT 150 UNION ALL SELECT 151 UNION ALL SELECT 152 UNION ALL
  SELECT 153 UNION ALL SELECT 154 UNION ALL SELECT 155 UNION ALL SELECT 156 UNION ALL
  SELECT 157 UNION ALL SELECT 158 UNION ALL SELECT 159 UNION ALL SELECT 160 UNION ALL
  SELECT 161 UNION ALL SELECT 162 UNION ALL SELECT 163 UNION ALL SELECT 164 UNION ALL
  SELECT 165 UNION ALL SELECT 166 UNION ALL SELECT 167 UNION ALL SELECT 168 UNION ALL
  SELECT 169 UNION ALL SELECT 170 UNION ALL SELECT 171 UNION ALL SELECT 172 UNION ALL
  SELECT 173 UNION ALL SELECT 174 UNION ALL SELECT 175 UNION ALL SELECT 176 UNION ALL
  SELECT 177 UNION ALL SELECT 178 UNION ALL SELECT 179 UNION ALL SELECT 180 UNION ALL
  SELECT 181 UNION ALL SELECT 182 UNION ALL SELECT 183 UNION ALL SELECT 184 UNION ALL
  SELECT 185 UNION ALL SELECT 186 UNION ALL SELECT 187 UNION ALL SELECT 188 UNION ALL
  SELECT 189 UNION ALL SELECT 190 UNION ALL SELECT 191 UNION ALL SELECT 192 UNION ALL
  SELECT 193 UNION ALL SELECT 194 UNION ALL SELECT 195 UNION ALL SELECT 196 UNION ALL
  SELECT 197 UNION ALL SELECT 198 UNION ALL SELECT 199 UNION ALL SELECT 200
) t;

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------- **** BASICS *****---------------------------------------------------------------------------

-- Write a query to retrieve all columns from the sy_account table.
select * from sy_account;

-- Write a query to find all users from the ab_user table where account_id is equal to 3.
select * from ab_user 
where account_id=3;

-- Write a query to display all application modules from sy_app_module ordered by app_name in ascending order.
select * from sy_app_module
order by app_name asc;

-- Write a query to fetch the first 10 records from the in_timeseries_data table.
select * from in_timeseries_data
limit 10;

-- Write a query to count the total number of materials in the in_material table for workspace_id = 5.
select workspace_id,count(*) AS material_count
from in_material
where workspace_id = 5
group by workspace_id;

-- Write a query to display all users from ab_user ordered by username in ascending order.
select * from ab_user
order by username asc;

-- Write a query to find all timeseries from in_timeseries where workspace_id = 8 AND material_id = 8.
select * from in_timeseries
where workspace_id=8 and material_id=8;

-- Write a query to retrieve all versions from in_timeseries_version where version_id is 1,6 or 3.
select * from in_timeseries_version
where version_id  in (1,6,3);

-- Write a query to retrieve the first 5 materials from in_material where workspace_id = 5, ordered by material_name in ascending order.
select * from in_material 
where workspace_id=5
order by material_name asc
limit 5;

-- Write a query to count the total number of users in the ab_user table
select count(*) as total_users from ab_user ;

-- Write a query to calculate the sum of all data values from the in_timeseries_data table where version_id = 5.
select version_id,sum(data) as sum_data
from in_timeseries_data
where version_id = 5
group by version_id;

-- Write a query to find the average value of data from the in_timeseries_data table where workspace_id = 5.
select avg(data) as avg_data from in_timeseries_data
where workspace_id=5;

-- Write a query to find the maximum and minimum data values from the in_timeseries_data table where version_id = 3.
select max(data) as max_data,min(data) as min_data from in_timeseries_data
where version_id=3;

-- Write a query to count the number of timeseries records grouped by material_id from the in_timeseries table.
select material_id,count(*) as count_records from in_timeseries
group by material_id;

-- Write a query to count the number of users grouped by account_id from the ab_user table where account_id is not null.
select account_id,count(*) as no_of_users from ab_user 
where account_id is not null
group by account_id;

-- Write a query to display version_id, count of records, and average data value grouped by version_id from the in_timeseries_data table where workspace_id = 5.
select version_id,count(*) as count_of_records , avg(data) as avd_data from in_timeseries_data
where workspace_id=5
group by version_id;

-- Write a query to find all material_id values from in_timeseries that have more than 1 timeseries records. Use GROUP BY and HAVING clauses.
select material_id,count(*) as count from in_timeseries 
group by material_id
having count>1;

-- Write a query to count the number of timeseries data records grouped by both version_id and ts_id from the in_timeseries_data table 
-- where workspace_id = 53 and the count is greater than 1.
select version_id,ts_id,count(*) as count_rec from in_timeseries_data
where workspace_id=5
group by version_id,ts_id
having count_rec >1;

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------- ** JOINS **--------------------------------------------------------------------------------------


-- Write a query to display username along with their account name. Output must have id, username, account_id, and name columns.
select id, username, account_id,name from ab_user
join sy_account 
using (id);

-- Write a query to show all application names and their corresponding application module codes.
-- Output must have app_id, app_code, app_name, application_id, and application_name columns.
select app_id, app_code, app_name, application_id,application_name from sy_app_module
join sy_application 
using (application_id) ;

-- Write a query to retrieve model names along with their associated application names.
-- Output must have model_id, model_name, application_id, and application_name columns.
select model_id, model_name, application_id,application_name from in_model 
join sy_application
using(application_id);

-- Write a query to display workspace names with their corresponding model names. Output must have workspace_id, workspace_name, model_id, and model_name columns.
select  workspace_id, workspace_name, model_id,model_name from in_workspace
join in_model
using (model_id);

-- Write a query to show all version names along with their workspace names where workspace_id = 53.
-- Output must have version_id, version_name, workspace_id, and workspace_name columns.
select version_id, version_name, workspace_id,workspace_name  from in_timeseries_version
join in_workspace
using (workspace_id);

-- Write a query to display material names with their workspace names. Output must have material_id, material_name, workspace_id, and workspace_name columns.
select material_id, material_name, workspace_id,workspace_name from in_material
join in_workspace
using (workspace_id);

-- Write a query to show resource (geography) names along with their workspace names where workspace_id = 5.
-- Output must have resource_id, resource_name, workspace_id, and workspace_name columns.
select resource_id, resource_name, workspace_id,workspace_name from in_resource
join in_workspace
using(workspace_id)
where workspace_id= 5;

-- Write a query to display time dimension names with their associated workspace names.
--  Output must have time_dimension_id, time_dimension_name, workspace_id, and workspace_name columns.
select time_dimension_id, time_dimension_name, workspace_id,workspace_name  from in_time_dimension
join in_workspace
using(workspace_id);

-- Write a query to show timeseries IDs along with their corresponding material names where workspace_id = 53.
--  Output must have ts_id, material_id, material_name, and workspace_id columns.
select ts_id, material_id, material_name,t.workspace_id from in_timeseries as t
join in_material
using(material_id);

-- Write a query to display timeseries data along with their version names for workspace_id = 53.
--  Output must have ts_data_id, ts_id, dttime, data, version_id, and version_name columns.
select ts_data_id, ts_id, ddttime, data, version_id,version_name from in_timeseries_data
join in_timeseries_version
using(version_id);

-- Write a query to show all users and their account names, but only for users where account_id is greater than 1.
--  Output must have id, username, account_id, and name columns.
select  id, username, account_id,name from ab_user 
join sy_account
using(id);

-- Write a query to display application module names along with their application descriptions.
--  Output must have app_id, app_name, application_id, application_name, and application_description columns.
select app_id, app_name, application_id, application_name,application_description from sy_app_module
join sy_application
using (application_id);

-- Write a query to show model names and their descriptions along with the application module name. 
-- Output must have model_id, model_name, model_description, app_id, and app_name columns.
select model_id, model_name, model_description,m.app_id,app_name from in_model as m
join sy_app_module
using (application_id);


-- Write a query to show workspace name, model name, and application name for workspace_id = 53.
-- Output must have workspace_id, workspace_name, model_id, model_name, application_id, and application_name columns.
select workspace_id, workspace_name, model_id, model_name, application_id,application_name from in_workspace
join in_model
using (model_id)
join sy_application
using (application_id);

-- Write a query to display timeseries ID, material name, geography name, and time dimension name for workspace_id = 53. 
-- Output must have ts_id, material_id, material_name, geography_id, resource_name (as geography_name), time_level (as time_level_id), and time_dimension_name columns.
select  td.ts_id, m.material_id, material_name, resource_id, resource_name as geography_name ,time_level ,time_dimension_name from in_material as m
join in_timeseries_data as td
using (workspace_id)
join in_resource
using(workspace_id)
join in_time_dimension
using(workspace_id)
join in_timeseries
using(workspace_id);

-- Write a query to display timeseries data value, material name, geography name, and version name where workspace_id = 53 and version_id = 125.
-- Output must have ts_data_id, ts_id, dttime, data, material_id, material_name, geography_id, resource_name (as geography_name), version_id, and version_name columns.
select  ts_data_id, ts_id, ddttime, data, material_id, material_name, resource_id, resource_name, version_id,version_name from in_timeseries_data
join in_material
using (workspace_id)
join in_resource
using (workspace_id)
join in_timeseries_version
using (version_id);

-- Write a query to display username, account name, application name, and model name where the user's account is linked to applications. 
-- Output must have user_id (as id), username, account_id, account_name (as name), application_id, application_name, model_id, and model_name columns.
select id as user_id, username, account_id,name as account_name, application_id, application_name, model_id,model_name from ab_user
join sy_account 
using (id)
join sy_application
using (account_id)
join in_model
using (application_id);

-- Write a query to show timeseries data value, datetime, material name, geography name, time dimension name, version name, and workspace name
-- for the latest 10 records in workspace_id = 53 ordered by datetime descending.
-- Output must have ts_data_id, ts_id, dttime, data, material_name, resource_name (as geography_name), time_dimension_name, version_name, and workspace_name columns.
select ts_data_id, ts_id, ddttime, data, material_name, resource_name as geography_name, time_dimension_name, version_name,workspace_name from in_timeseries_data
join in_material
using(workspace_id)
join in_resource
using(workspace_id)
join in_time_dimension
using(workspace_id)
join in_workspace
using(workspace_id)
join in_timeseries_version
using(version_id) ;

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------- ** Little complex ** --------------------------------------------------------------------

-- Write a query to display all timeseries data with a row number for each record within workspace_id = 5, ordered by dttime ascending.
--  Output must have ts_data_id, ts_id, dttime, data, version_id, and row_num columns.
select ts_data_id, ts_id, ddttime, data, version_id,
		row_number() over(order by ddttime asc)as row_num from in_timeseries_data
where workspace_id=5;

-- Write a query to rank timeseries data values within each version for workspace_id = 5, ordered by data value descending. 
-- Output must have ts_data_id, ts_id, data, version_id, and rank columns.
select ts_data_id, ts_id, data, version_id,
		rank() over(order by data desc) as "rank" from in_timeseries_data
where workspace_id=5;

-- Write a query to calculate the running total (cumulative sum) of data values for each timeseries (ts_id) ordered by dttime where workspace_id = 5.
-- Output must have ts_data_id, ts_id, dttime, data, version_id, and running_total columns.
select ts_data_id, ts_id, ddttime, data, version_id,
		sum(data) over(order by ddttime) as running_total from in_timeseries_data
where workspace_id=5;

-- Write a query to find the previous and next data values for each timeseries record ordered by dttime where workspace_id = 5 and version_id = 5.
-- Output must have ts_data_id, ts_id, dttime, data, previous_value, and next_value columns.
select ts_data_id, ts_id, ddttime, data, 
		lag(data) over(order by ddttime) as previous_value,
        lead(data)over(order by ddttime) as next_value from in_timeseries_data
where workspace_id=5 and version_id=5;

-- Write query to calculate the moving average of data values over the last 3 records (including current) for each timeseries ordered by dttime where workspace_id = 53.
-- Output must have ts_data_id, ts_id, dttime, data, and moving_avg_3 columns.
select ts_data_id, ts_id, ddttime, data,
		avg(data) over (order by ddttime rows between 2 preceding and current row) as moving_avg_3 from in_timeseries_data
where workspace_id=5;

-- Write a query to assign dense rank to materials based on the count of their timeseries records in workspace_id = 53. 
-- Output must have material_id, timeseries_count, and dense_rank columns.
select material_id,
		count(*) over(partition by workspace_id) as  timeseries_count,
		dense_rank() over() "as dense_rank" from in_material
where workspace_id=5;

-- Write a query to partition timeseries data by version_id and show the maximum data value within each partition for workspace_id = 53.
-- Output must have ts_data_id, ts_id, dttime, data, version_id, and max_in_version columns.
select ts_data_id, ts_id, ddttime, data, version_id,
		max(data) over(partition by version_id) as max_in_version from in_timeseries_data
where workspace_id=5;

-- Write a query to calculate the percentage of each data value relative to the total sum of data values within its version for workspace_id = 5.
-- Output must have ts_data_id, ts_id, data, version_id, and percentage_of_total columns.
select ts_data_id, ts_id, data, version_id, 
		 (data / SUM(data) OVER ()) * 100 AS percentage_of_total from in_timeseries_data
where workspace_id=5;

-- Write a query to find the first and last data values for each timeseries (ts_id) ordered by dttime where workspace_id = 5.
-- Output must have ts_data_id, ts_id, dttime, data, first_value, and last_value columns.
SELECT ts_data_id,ts_id,ddttime, data,
		first_value(data) over (partition by  ts_id order by ddttime rows between unbounded preceding and unbounded following) as "first_value",
		last_value(data) over (partition by ts_id order by ddttime rows between unbounded preceding and unbounded following) as "last_value"
from in_timeseries_data
where workspace_id = 5
order by ts_id, ddttime;


-- Write a query to calculate the difference between each data value and the average data value within its version for workspace_id = 5.
-- Output must have ts_data_id, ts_id, data, version_id, avg_in_version, and difference_from_avg columns.
select ts_data_id,ts_id,data,version_id,
    avg(data) over (partition by version_id) as avg_in_version,
    data - avg(data) over (partition by version_id) as difference_from_avg
from in_timeseries_data
where workspace_id = 5
order by version_id, ts_data_id;

-- Write a query to rank materials by their total data sum across all timeseries in workspace_id = 53, and show the material name along with the rank.
-- Output must have material_id, material_name, total_data_sum, and rank columns.
select m.material_id,m.material_name,
	sum(td.data) as total_data_sum,
    rank() over (order by sum(td.data) desc) as `rank`
from in_timeseries_data td
join in_timeseries ts
using(ts_id)
join in_material m
using (material_id)
where td.workspace_id = 5
group by m.material_id, m.material_name
order by total_data_sum desc;


-- Write a query to display all timeseries data records where the data value is greater than the average data value across all records in workspace_id = 53.
-- Output must have ts_data_id, ts_id, dttime, data, and version_id columns.
select ts_data_id,ts_id,ddttime,data,version_id
from (select ts_data_id,ts_id,ddttime,data,version_id,
	avg(data) over () as avg_data_all from in_timeseries_data
    where workspace_id = 5) as t
where data > avg_data_all
order by ddttime;


-- Write a query to find the material with the maximum number of timeseries records in workspace_id = 53.
-- Output must have material_id, material_name, and timeseries_count columns.
select m.material_id,m.material_name,
    count(ts.ts_id) as timeseries_count
from in_timeseries ts
join in_material m
using (material_id)
where ts.workspace_id = 5
group by m.material_id, m.material_name
order by timeseries_count desc
limit 1;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------