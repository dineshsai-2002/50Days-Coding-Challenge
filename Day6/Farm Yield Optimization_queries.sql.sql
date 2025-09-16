CREATE DATABASE AGRICULTURE;
USE AGRICULTURE;

-- Create the farmers table 
CREATE TABLE farmers ( 
    farmer_id INT PRIMARY KEY, 
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    email VARCHAR(100) UNIQUE, 
    hire_date DATE 
);
INSERT INTO farmers (farmer_id, first_name, last_name, email, hire_date) VALUES 
(1, 'John', 'Doe', 'john.doe@agri-innovate.com', '2020-05-15'), 
(2, 'Jane', 'Smith', 'jane.smith@agri-innovate.com', '2021-02-20'), 
(3, 'Peter', 'Jones', 'peter.jones@agri-innovate.com', '2020-11-10'), 
(4, 'Maria', 'Garcia', 'maria.garcia@agri-innovate.com', '2022-08-01'), 
(5, 'Alex', 'Chen', 'alex.chen@agri-innovate.com', '2023-03-25');

-- Create the plots table 
CREATE TABLE plots ( 
    plot_id INT PRIMARY KEY, 
    plot_name VARCHAR(100) NOT NULL, 
    farmer_id INT, 
    crop_type VARCHAR(50) NOT NULL, 
    soil_type VARCHAR(50), 
    FOREIGN KEY (farmer_id) REFERENCES farmers(farmer_id) 
); 

-- Insert data into plots table (8 records) 
INSERT INTO plots (plot_id, plot_name, farmer_id, crop_type, soil_type) VALUES 
(101, 'West Field', 1, 'Wheat', 'Loam'), 
(102, 'North Pasture', 2, 'Corn', 'Clay'), 
(103, 'South Farm', 1, 'Soybeans', 'Sand'), 
(104, 'East Meadow', 3, 'Wheat', 'Loam'), 
(105, 'Plot A', 4, 'Corn', 'Clay'), 
(106, 'Plot B', 5, 'Soybeans', 'Sand'), 
(107, 'High Plains', 3, 'Corn', 'Loam'), 
(108, 'Valley View', 2, 'Wheat', 'Clay'); 


-- Create the yields table 
CREATE TABLE yields ( 
    yield_id INT PRIMARY KEY, 
    plot_id INT, 
    harvest_date DATE, 
    yield_kg DECIMAL(10, 2), 
    weather_condition VARCHAR(50), 
    FOREIGN KEY (plot_id) REFERENCES plots(plot_id) 
);
SELECT * FROM YIELDS ORDER BY HARVEST_DATE DESC;
select max(harvest_date) from yields;
-- Insert data into yields table (20 records) 
INSERT INTO yields (yield_id, plot_id, harvest_date, yield_kg, weather_condition) VALUES 
(1, 101, '2024-07-20', 1500.50, 'Sunny'), 
(2, 102, '2024-09-15', 2100.75, 'Rainy'), 
(3, 103, '2024-10-01', 950.20, 'Mild'), 
(4, 104, '2024-07-25', 1650.30, 'Sunny'), 
(5, 105, '2024-09-18', 2200.10, 'Rainy'), 
(6, 106, '2024-10-05', 880.90, 'Mild'), 
(7, 107, '2024-09-20', 2350.40, 'Sunny'), 
(8, 108, '2024-08-01', 1450.60, 'Mild'), 
(9, 101, '2023-07-19', 1400.00, 'Rainy'), 
(10, 102, '2023-09-14', 2050.00, 'Sunny'), 
(11, 103, '2023-10-02', 900.00, 'Mild'), 
(12, 104, '2023-07-24', 1550.00, 'Rainy'), 
(13, 105, '2023-09-17', 2150.00, 'Sunny'), 
(14, 106, '2023-10-04', 850.00, 'Mild'), 
(15, 107, '2023-09-19', 2250.00, 'Rainy'), 
(16, 108, '2023-07-31', 1350.00, 'Mild'), 
(17, 101, '2022-07-21', 1300.00, 'Sunny'), 
(18, 102, '2022-09-16', 2000.00, 'Rainy'), 
(19, 103, '2022-10-03', 800.00, 'Mild'), 
(20, 104, '2022-07-26', 1500.00, 'Sunny'); 

-- Create the irrigation_logs table 
CREATE TABLE irrigation_logs ( 
    log_id INT PRIMARY KEY, 
    plot_id INT, 
    irrigation_date DATE, 
    water_amount_liters DECIMAL(10, 2), 
    FOREIGN KEY (plot_id) REFERENCES plots(plot_id) 
); 


-- Insert data into irrigation_logs table (15 records) 
INSERT INTO irrigation_logs (log_id, plot_id, irrigation_date, water_amount_liters) VALUES 
(1, 101, '2024-05-10', 50000.00), 
(2, 102, '2024-06-12', 75000.00), 
(3, 103, '2024-07-15', 30000.00), 
(4, 104, '2024-05-12', 45000.00), 
(5, 105, '2024-06-15', 80000.00), 
(6, 106, '2024-07-18', 25000.00), 
(7, 107, '2024-06-20', 70000.00), 
(8, 108, '2024-05-25', 55000.00), 
(9, 101, '2023-05-11', 48000.00), 
(10, 102, '2023-06-13', 72000.00), 
(11, 103, '2023-07-16', 28000.00), 
(12, 104, '2023-05-13', 43000.00), 
(13, 105, '2023-06-16', 78000.00), 
(14, 106, '2023-07-19', 23000.00), 
(15, 107, '2023-06-21', 68000.00); 



-- 1. Productivity & Performance 
/*Identify the top 3 most productive plots based on average yield per harvest. Show the 
 plot_name, crop_type, and average_yield_kg. */
SELECT p.plot_name, p.crop_type, ROUND(AVG(y.yield_kg),2) AS Average_Yield
FROM plots p
JOIN yields y ON p.plot_id = y.plot_id
GROUP BY p.plot_name, p.crop_type
ORDER BY Average_Yield DESC
LIMIT 3;

/*• Calculate the total water consumption for each plot and rank them from highest to 
lowest. Show plot_name and total_water_liters. */
WITH PlotWater AS (
SELECT p.plot_name,SUM(il.water_amount_liters) AS total_water_liters
FROM irrigation_logs il
LEFT JOIN plots p ON il.plot_id = p.plot_id
GROUP BY p.plot_name
)
SELECT plot_name,total_water_liters,
RANK() OVER (ORDER BY total_water_liters DESC) AS water_rank
FROM PlotWater
ORDER BY total_water_liters DESC;

-- 2. Yield & Environmental Analysis 
/*• Determine the average yield for each crop type under different weather conditions. The 
output should have crop_type, weather_condition, and average_yield_kg.*/ 

SELECT p.crop_type,y.weather_condition,
ROUND(AVG(y.yield_kg),2) AS average_yield_kg
FROM yields y
JOIN plots p ON y.plot_id = p.plot_id
GROUP BY p.crop_type, y.weather_condition
ORDER BY p.crop_type, y.weather_condition;




/*• Find the highest-yielding plot for each soil type. Show the soil_type, plot_name, and 
highest_yield_kg. */

WITH RankedYields AS (
SELECT p.soil_type,p.plot_name,
y.yield_kg AS highest_yield_kg,
ROW_NUMBER() OVER (PARTITION BY p.soil_type ORDER BY y.yield_kg DESC) AS rn
FROM yields y
JOIN plots p ON y.plot_id = p.plot_id
)
SELECT soil_type,plot_name,highest_yield_kg
FROM RankedYields
WHERE rn = 1;


-- 3. Farmer & Resource Management 
/*• Identify the farmer who manages the plots with the lowest average water 
consumption. Show the first_name, last_name, and their plots' 
average_water_liters_per_plot. */

SELECT f.first_name,f.last_name,
ROUND(AVG(PW.total_water),2) AS average_water_liters_per_plot
FROM farmers f
JOIN (
SELECT p.farmer_id, p.plot_id,
SUM(il.water_amount_liters) AS total_water
FROM irrigation_logs il
JOIN plots p ON il.plot_id = p.plot_id
GROUP BY p.farmer_id, p.plot_id
)
AS PW ON f.farmer_id = PW.farmer_id
GROUP BY f.first_name, f.last_name
ORDER BY average_water_liters_per_plot ASC
LIMIT 1;


/*• Calculate the number of harvests per month for the last 12 months. Show the month 
and the number of harvests.*/

SELECT substr(harvest_date,1,7) AS month,
COUNT(*) AS number_of_harvests
FROM yields
WHERE harvest_date >='2023-09-01'
GROUP BY MONTH
ORDER BY month DESC;


/*4. Advanced Analysis (Bonus) 
• Find plots that have a below-average yield for their specific crop type but an above
average water consumption compared to all other plots with the same crop. List the 
plot_name, crop_type, yield_kg, and water_amount_liters.*/
WITH PlotWater AS (
SELECT plot_id,
SUM(water_amount_liters) AS total_water_liters
FROM irrigation_logs
GROUP BY plot_id
),
CropAverages AS (
SELECT p.crop_type,
AVG(y.yield_kg) AS avg_yield_kg,
AVG(pw.total_water_liters) AS avg_water_liters
FROM yields y
JOIN plots p ON y.plot_id = p.plot_id
JOIN PlotWater pw ON p.plot_id = pw.plot_id
GROUP BY p.crop_type
)
SELECT p.plot_name,p.crop_type,
y.yield_kg,
pw.total_water_liters
FROM yields y
JOIN plots p ON y.plot_id = p.plot_id
JOIN PlotWater pw ON p.plot_id = pw.plot_id
JOIN CropAverages ca ON p.crop_type = ca.crop_type
WHERE y.yield_kg < ca.avg_yield_kg
AND pw.total_water_liters > ca.avg_water_liters;



