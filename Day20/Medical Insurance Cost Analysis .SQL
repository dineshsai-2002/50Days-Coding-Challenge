use insurancedb;
CREATE TABLE medical_insurance ( 
    policy_id INT PRIMARY KEY, 
    age INT, 
    gender VARCHAR(10), 
    bmi DECIMAL(5,2), 
    children INT, 
    smoker VARCHAR(3),        -- Yes / No 
    region VARCHAR(20),       -- e.g., northeast, northwest, southeast, southwest 
    insurance_cost DECIMAL(10,2) 
); 

INSERT INTO medical_insurance VALUES 
(1, 19, 'Female', 27.90, 0, 'Yes', 'southwest', 16884.92), 
(2, 18, 'Male', 33.77, 1, 'No', 'southeast', 1725.55), 
(3, 28, 'Male', 33.00, 3, 'No', 'southeast', 4449.46), 
(4, 33, 'Male', 22.70, 0, 'No', 'northwest', 21984.47), 
(5, 32, 'Female', 28.88, 0, 'No', 'southeast', 3866.86), 
(6, 31, 'Female', 25.74, 0, 'Yes', 'southeast', 3756.62), 
(7, 46, 'Female', 33.44, 1, 'No', 'southeast', 8240.59), 
(8, 37, 'Male', 27.74, 2, 'No', 'northwest', 7281.51), 
(9, 37, 'Female', 29.83, 2, 'No', 'northeast', 6406.41), 
(10, 60, 'Female', 25.84, 0, 'Yes', 'northwest', 28923.14); 



-- 1. Find the total number of insurance records. 
SELECT COUNT(*) AS total_records
FROM medical_insurance;

-- 2. Retrieve the details of all smokers above age 40. 
SELECT *
FROM medical_insurance
WHERE smoker = 'Yes' AND age > 40;

-- 3. Count how many male and female policyholders exist in the dataset. 
SELECT gender, COUNT(*) AS count
FROM medical_insurance
GROUP BY gender;
-- 4. Calculate the average insurance cost of smokers vs. non-smokers. 
SELECT smoker, ROUND(AVG(insurance_cost),2) AS avg_insurance_cost
FROM medical_insurance
GROUP BY smoker;

-- 5. Find the region with the highest average insurance cost. 
SELECT region, ROUND(AVG(insurance_cost),2) AS avg_cost
FROM medical_insurance
GROUP BY region
ORDER BY avg_cost DESC
LIMIT 1;
-- 6. List the top 5 policyholders who paid the highest insurance cost. 
SELECT *
FROM medical_insurance
ORDER BY insurance_cost DESC
LIMIT 5;
-- 7. Calculate the average insurance cost grouped by age group: Young (18–30), Middle-aged (31–50), Senior (51+). 
SELECT
  CASE
    WHEN age BETWEEN 18 AND 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Middle-aged'
    WHEN age >= 51 THEN 'Senior'
  END AS age_group,
ROUND(AVG(insurance_cost),2) AS avg_insurance_cost
FROM medical_insurance
GROUP BY age_group;
-- 8. Identify if smokers with BMI > 30 are paying significantly higher insurance than non smokers. 
SELECT
  smoker,
  AVG(insurance_cost) AS avg_cost
FROM medical_insurance
WHERE bmi > 30
GROUP BY smoker;
-- 9. Find the correlation-like insights (not actual correlation in SQL, but using GROUP BY) – 
-- e.g., 
-- Avg cost by number of children. 
SELECT children, AVG(insurance_cost) AS avg_cost
FROM medical_insurance
GROUP BY children
ORDER BY children;
-- o Avg cost by gender. 
SELECT gender, AVG(insurance_cost) AS avg_cost
FROM medical_insurance
GROUP BY gender;
-- Avg cost by region. 
SELECT region, AVG(insurance_cost) AS avg_cost
FROM medical_insurance
GROUP BY region;

-- 10. Write a query to find the insurance cost difference between smokers and non-smokers in each region. 
SELECT 
    region,
    AVG(CASE WHEN smoker = 'Yes' THEN insurance_cost END) AS avg_smoker_cost,
    AVG(CASE WHEN smoker = 'No'  THEN insurance_cost END) AS avg_non_smoker_cost,
    (AVG(CASE WHEN smoker = 'Yes' THEN insurance_cost END) -
     AVG(CASE WHEN smoker = 'No'  THEN insurance_cost END)) AS cost_difference
FROM medical_insurance
GROUP BY region;


