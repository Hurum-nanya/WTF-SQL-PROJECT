CREATE TABLE appointments(
    appointment_id INT,
    patient_id INT,
	doctor_id INT,
	appointment_date DATE,
	status TEXT,
	visit_reason TEXT
);

CREATE TABLE billing(
    bill_id INT,
	appointment_id INT,
	amount INT,
	insurance_covered INT,
	patient_paid INT
);

CREATE TABLE diagnosis(
    diagnosis_id INT,
	appointment_id INT,
	diagnosis_code TEXT,
	diagnosis_description TEXT
);

CREATE TABLE doctor(
    doctor_id INT,
	doctor_name TEXT,
	specialty TEXT,
	clinic_location TEXT
);

CREATE TABLE medications(
    med_id INT,
	patient_id INT,
	medication_name TEXT,
	dosage TEXT,
	start_date DATE,
	end_date DATE
);

CREATE TABLE patients(
    patient_id INT,
	first_name TEXT,
	last_name TEXT,
	gender TEXT,
	date_of_birth DATE,
	city TEXT,
	insurance_provider TEXT
);

-- 1. List all patients who live in Seattle.

SELECT patient_id, first_name, last_name, city
FROM patients
WHERE city = 'Seattle'
ORDER BY patient_id

-- 2. Find all medications where the dosage is greater than 50mg.

SELECT medication_name, dosage
FROM medications
WHERE dosage > '50mg'
ORDER BY dosage;

-- 3. Get all completed appointments in February 2024.

SELECT *
FROM appointments
WHERE status = 'Completed' AND EXTRACT(MONTH FROM appointment_date) = 2 AND EXTRACT(YEAR FROM appointment_date) = 2024;

-- 4. Show each doctor and how many appointments they completed.

SELECT d.doctor_name, d.doctor_id, a.status, COUNT(a.appointment_id) AS NO_of_comp_appoint
FROM doctor AS d
JOIN appointments AS a
ON d.doctor_id = a.doctor_id
WHERE status = 'Completed'
GROUP BY d.doctor_id, d.doctor_name, a.status
ORDER BY NO_of_comp_appoint;

-- 5. Find the most common diagnosis in the database.
SELECT diagnosis_code, COUNT(diagnosis_code) AS No_of_diagnosis
FROM diagnosis
GROUP BY diagnosis_code
ORDER BY No_of_diagnosis DESC
LIMIT 1;

-- 6. List the total billing amount per patient.
SELECT p.patient_id, p.first_name, p.last_name, SUM(b.amount) AS Total_amount
FROM patients AS p
JOIN appointments AS a ON p.patient_id = a.patient_id
JOIN billing AS b ON b.appointment_id = a.appointment_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY Total_amount DESC;

-- 7. Which clinic location has the highest number of appointments?
SELECT d.clinic_location, Count(appointment_id) AS total_appointment
FROM doctor AS d
JOIN appointments AS a 
ON d.doctor_id = a.doctor_id
GROUP BY d.clinic_location
ORDER BY total_appointment DESC
LIMIT 1;

-- 8. Identify patients who have more than one diagnosis in 2024.
SELECT p.patient_id, p.first_name, p.last_name, MAX(a.appointment_date), Count(DISTINCT dia.diagnosis_code) AS No_of_diagonosis
FROM diagnosis AS dia
JOIN appointments AS a 
ON a.appointment_id = dia.appointment_id
JOIN patients AS p 
ON p.patient_id = a.patient_id
WHERE EXTRACT(YEAR FROM appointment_date) = 2024
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING Count(DISTINCT dia.diagnosis_code) > 1 
ORDER BY No_of_diagonosis DESC;	

-- CHECK FOR NO 8
SELECT p.patient_id, p.first_name, p.last_name, dia.diagnosis_code AS No_of_diagonosis, diagnosis_id
FROM diagnosis AS dia
JOIN appointments AS a 
ON a.appointment_id = dia.appointment_id
JOIN patients AS p 
ON p.patient_id = a.patient_id
WHERE p.patient_id = 1737;

-- 9. Rank doctors by total revenue generated.

SELECT d.doctor_id, d.doctor_name, d.specialty, SUM(b.amount) AS total_revenue,
RANK() OVER(ORDER BY SUM(b.amount) DESC) revenue_rank
FROM doctor AS d
JOIN appointments AS a ON  d.doctor_id = a.doctor_id
JOIN billing as b ON b.appointment_id = a.appointment_id
GROUP BY d.doctor_id, d.doctor_name, d.specialty

-- 10. For each patient, show their most recent appointment.

SELECT p.patient_id, p.first_name, p.last_name, MAX(appointment_date) AS recent_appointment
FROM patients AS p
JOIN appointments AS a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY recent_appointment DESC

-- 11. Identify patients whose insurance covered less than 70% of their bill.
SELECT p.patient_id, p.first_name, p.last_name, b.insurance_covered, ROUND((b.insurance_covered::numeric/b.amount)*100,2) AS percentage_of_insurance
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN billing b ON b.bill_id = a.appointment_id 
WHERE (b.insurance_covered::numeric/b.amount)*100 < 70
ORDER BY percentage_of_insurance DESC;

-- 12. Identify all diabetic patients and list their last medication renewal date.

SELECT p.patient_id, p.first_name, p.last_name, MAX(m.end_date) AS end_date, dia.diagnosis_code
FROM patients p
JOIN appointments a ON a.patient_id = p.patient_id
JOIN diagnosis dia ON dia.appointment_id = a.appointment_id
JOIN medications m ON m.patient_id = p.patient_id
WHERE dia.diagnosis_code = 'E11'
GROUP BY p.patient_id, p.first_name, p.last_name, dia.diagnosis_code

-- 13. Which doctor has the lowest no‑show rate?
WITH NO_OF_NO_SHOWS AS (
SELECT d.doctor_id, d.doctor_name, a.status, COUNT(a.status) AS total_no_shows
FROM appointments a
JOIN doctor d ON d.doctor_id = a.doctor_id
WHERE a.status = 'No-show'
GROUP BY d.doctor_id, d.doctor_name, a.status
), 
DOCTOR_APPOINTMENTS AS (
SELECT d.doctor_id, d.doctor_name, COUNT(a.appointment_id) AS total_appointment
FROM doctor d
JOIN appointments a ON a.doctor_id = d.doctor_id
GROUP BY  d.doctor_id, d.doctor_name
)
SELECT nns.doctor_id, nns.doctor_name, nns.status, (nns.total_no_shows * 100)/da.total_appointment AS percentage_of_no_shows
FROM NO_OF_NO_SHOWS nns
JOIN DOCTOR_APPOINTMENTS da ON nns.doctor_id = da.doctor_id

-- 14. Which age group has the highest incidence of hypertension (I10)?

WITH PATIENTS_AGE AS (
	SELECT *, EXTRACT(YEAR FROM AGE(CURRENT_DATE, DATE_OF_BIRTH)) AS AGE_YEARS
	FROM PATIENTS 
),
PATIENT_AGE_GROUP AS (
	SELECT *,
	CASE 
	WHEN AGE_YEARS < 18 THEN '0-17'
	WHEN AGE_YEARS BETWEEN 18 AND 34 THEN '18-34'
	WHEN AGE_YEARS BETWEEN 35 AND 49 THEN '35-49'
	WHEN AGE_YEARS BETWEEN 50 AND 64 THEN '50-64'
	ELSE '65+'
	END AS AGE_GROUP
	FROM PATIENTS_AGE
)
SELECT PG.AGE_GROUP, COUNT(A.PATIENT_ID) AS NO_OF_PATIENTS
FROM PATIENT_AGE_GROUP PG
JOIN APPOINTMENTS A ON A.PATIENT_ID = PG.PATIENT_ID
JOIN DIAGNOSIS D ON D.APPOINTMENT_ID = A.APPOINTMENT_ID
WHERE D.DIAGNOSIS_CODE = 'I10'
GROUP BY PG.AGE_GROUP
ORDER BY NO_OF_PATIENTS DESC
LIMIT 1

-- 15. Which insurance provider covers the highest average amount?

SELECT P.INSURANCE_PROVIDER, ROUND(AVG(B.INSURANCE_COVERED),2) AS AVG_AMOUNT_COVERED
FROM PATIENTS P
JOIN APPOINTMENTS A ON A.PATIENT_ID = P.PATIENT_ID
JOIN BILLING B ON B.APPOINTMENT_ID = A.APPOINTMENT_ID
GROUP BY P.INSURANCE_PROVIDER
ORDER BY AVG_AMOUNT_COVERED DESC
LIMIT 5

-- 16. Determine peak days of the week for appointments.

SELECT TO_CHAR(APPOINTMENT_DATE,'Day') AS DAY_OF_WEEK, COUNT(APPOINTMENT_ID) AS NO_OF_APPOINTMENTS
FROM APPOINTMENTS
GROUP BY DAY_OF_WEEK
ORDER BY NO_OF_APPOINTMENTS DESC
LIMIT 1

-- 17. From this data set, write out 3 other queries based on what was taught in class but the queries should not be part of what has been asked already.

-- 17a List patients whose total billing amount exceeds the average billing amount

SELECT P.PATIENT_ID, P.FIRST_NAME, P.LAST_NAME, SUM(B.AMOUNT) AS TOTAL_BILLED
FROM PATIENTS P
JOIN APPOINTMENTS A ON A.PATIENT_ID = P.PATIENT_ID
JOIN BILLING B ON B.APPOINTMENT_ID = A.PATIENT_ID
GROUP BY P.PATIENT_ID, P.FIRST_NAME, P.LAST_NAME
HAVING SUM(B.AMOUNT) > (
SELECT AVG(TOTAL_AMOUNT)
FROM (
SELECT SUM(AMOUNT) AS TOTAL_AMOUNT
FROM BILLING B
JOIN APPOINTMENTS A ON A.APPOINTMENT_ID = B.APPOINTMENT_ID
GROUP BY PATIENT_ID, P.FIRST_NAME, P.LAST_NAME
)
)
ORDER BY TOTAL_BILLED DESC

--top diagnosis per clinic location 
WITH CLINIC_DIAGNOSIS_RANK AS (
SELECT DOC.CLINIC_LOCATION, D.DIAGNOSIS_CODE, COUNT(A.APPOINTMENT_ID) NO_OF_APPOINTMENTS,
RANK() OVER(PARTITION BY DOC.CLINIC_LOCATION ORDER BY COUNT(A.APPOINTMENT_ID) DESC) AS RANK_APPOINTMENTS
FROM DOCTOR DOC
JOIN APPOINTMENTS A ON A.DOCTOR_ID = DOC.DOCTOR_ID
JOIN DIAGNOSIS D ON D.APPOINTMENT_ID = A.APPOINTMENT_ID
GROUP BY DOC.CLINIC_LOCATION, D.DIAGNOSIS_CODE
)
SELECT CLINIC_LOCATION, DIAGNOSIS_CODE, NO_OF_APPOINTMENTS
FROM CLINIC_DIAGNOSIS_RANK
WHERE RANK_APPOINTMENTS = 1

--Count the number of medications per patient
WITH PATIENT_MEDICATION AS (
SELECT P.PATIENT_ID, P.FIRST_NAME, P.LAST_NAME, COUNT(DISTINCT MEDICATION_NAME) AS NO_OF_MEDICATIONS_PER_PATIENT
FROM PATIENTS P
JOIN MEDICATIONS M ON M.PATIENT_ID = P.PATIENT_ID
GROUP BY P.PATIENT_ID
ORDER BY NO_OF_MEDICATIONS_PER_PATIENT ASC
)
SELECT NO_OF_MEDICATIONS_PER_PATIENT, COUNT(PATIENT_ID) NO_OF_PATIENTS
FROM PATIENT_MEDICATION
GROUP BY NO_OF_MEDICATIONS_PER_PATIENT
ORDER BY NO_OF_PATIENTS DESC

SELECT * FROM BILLING

select * from patients;
select * from billing;
select * from appointments;
select * from doctor;
select * from diagnosis;
select * from medications;

-- 18. Explain these queries and outcomes
-- 19. Build a dashboard using powerBi.



SELECT
    d.doctor_id,
    d.doctor_name,
    ROUND(
        COUNT(CASE WHEN a.status = 'no-show' THEN 1 END)::decimal 
        / COUNT(*),
        2
    ) AS no_show_rate
FROM doctor AS d
JOIN appointments AS a 
    ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY no_show_rate 
-- LIMIT 100;





