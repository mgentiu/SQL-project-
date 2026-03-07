/*======================================================
Project: Medical appointment scheduling analysis 
AUTHOR: Madalin Gentiu 
Objective: Analyse patient attendance and clinic utilisation
========================================================*/
/*============================
1. DATA VALIDATION CHECKS
==============================*/
-- Q1. Are there any duplicate patient records that could impact reporting accuracy?

SELECT patient_id, COUNT(*) AS record_count
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;

--Q2.Are there appointments scheduled before a patient’s registration date, indicating potential data integrity issues?

SELECT a.appointment_id, a.scheduling_date, a.patient_id, p.dob
FROM appointments AS a
LEFT JOIN patients AS p 
ON a.patient_id = p.patient_id
WHERE a.scheduling_date < p.dob;

/*======================
2. Operational Metrics
========================*/

--Q3. What is the distribution of appointments by status (Scheduled, Completed, Cancelled)?

SELECT status, COUNT(appointment_id) AS count_appointments,
ROUND (COUNT (appointment_id) * 100.0 / SUM(COUNT(appointment_id) ) OVER(), 2)
FROM appointments 
GROUP BY status
ORDER BY count_appointments; 

--Q4. What is the average waiting time for patients across all appointments
--including average waiting time and percentage contribution?

SELECT status, COUNT(appointment_id) AS appointment_count,
ROUND (AVG(waiting_time), 2) AS avg_waiting_time,
ROUND (COUNT (appointment_id) * 100.00 / SUM(COUNT(appointment_id)) OVER(), 2) AS percentage_of_total
FROM appointments
WHERE status IS NOT NULL
GROUP BY status
ORDER BY appointment_count DESC;

/*============================
3. Patient Attendance Behavior
==============================*/

--Q5. Which patients have the highest number of appointments?

SELECT a.patient_id, p.name, COUNT(a.appointment_id) AS appointment_count 
FROM appointments AS a 
LEFT JOIN patients AS p
ON a.patient_id = p.patient_id
WHERE status <> 'Cancelled' 
GROUP BY a.patient_id, p.name
ORDER BY appointment_count DESC
LIMIT 10;

--Q6. Which patients have the longest average waiting time?

SELECT a.patient_id, p.name, 
ROUND(AVG(waiting_time), 2) AS avg_waiting_time, COUNT(*) AS appointment_count
FROM appointments AS a
LEFT JOIN patients AS p 
ON a.patient_id = p.patient_id
WHERE a.waiting_time IS NOT NULL
AND a.waiting_time >= 0
GROUP BY a.patient_id, p.name
ORDER BY avg_waiting_time DESC
LIMIT 10;

--Q7. How do patients rank based on the total number of appointments attended?

SELECT a.patient_id, p.name, status, COUNT(*) AS appointment_count, 
RANK () OVER (ORDER BY COUNT(*) DESC) AS rank
FROM appointments AS a
LEFT JOIN patients AS p
ON a.patient_id = p.patient_id
WHERE status = 'attended'
GROUP BY a.patient_id, p.name
ORDER BY rank
LIMIT 10;

/*===============================
4. Clinic Utilisation & Performance
================================*/

--Q8. How many appointments are attended per insurance provider on a monthly basis?

SELECT
  p.insurance,
  strftime('%Y-%m', a.appointment_date) AS appointment_month,
  COUNT(a.appointment_id) AS attended_appointments
FROM appointments a
LEFT JOIN patients p
  ON a.patient_id = p.patient_id
WHERE a.status = 'attended'
GROUP BY p.insurance, strftime('%Y-%m', a.appointment_date)
ORDER BY appointment_month, attended_appointments DESC;

--Q9. Which insurance providers’ patients have the highest attendance volume and total attended time?

SELECT
  p.insurance,
  COUNT(a.appointment_id) AS attended_appointments,
  COALESCE(SUM(a.appointment_duration), 0) AS total_attended_minutes,
  ROUND(AVG(a.appointment_duration), 2) AS avg_minutes_per_attended_appt
FROM patients p
LEFT JOIN appointments a
  ON p.patient_id = a.patient_id
  AND a.status = 'attended'
GROUP BY p.insurance
ORDER BY total_attended_minutes DESC;

--Q10. How can insurance providers be categorised into High, Medium,
 --and Low utilisation groups based on total attended appointment volume?
 
 SELECT p.insurance, COUNT(a.appointment_id) AS attended_appointments, 
 COALESCE(SUM(a.appointment_duration), 0) AS total_attended_minutes,
 CASE WHEN SUM(a.appointment_duration)  >= 137000 THEN 'HIGH'
 WHEN  SUM(a.appointment_duration) >= 60000 THEN 'MEDIUM'
 ELSE 'LOW' END AS utilisation_group
 FROM patients AS p 
 LEFT JOIN appointments AS a
 ON p.patient_id = a.patient_id
 AND a.status = 'attended'
 GROUP BY p.insurance 
 ORDER BY total_attended_minutes DESC;
 
 /*======================
 5. Time-based trends 
 ========================*/
 
 --Q11. On which days of the week are the highest number of appointments attended,
--and how does the average waiting time vary across those days?

SELECT COUNT(appointment_id) AS attended_appointments,
ROUND(AVG(waiting_time), 2) AS avg_waiting_time,
CASE strftime('%w', appointment_date) 
WHEN '1' THEN 'Monday'
WHEN '2' THEN 'Tuesday'
WHEN '3' THEN 'Wednesday'
WHEN '4' THEN 'Thursday'
WHEN '5' THEN 'Friday'
END AS weekday
FROM appointments
WHERE status = 'attended'
GROUP BY strftime('%w', appointment_date) 
ORDER BY attended_appointments DESC;

/*===========================================
6. Patient Behaviour / Utilisation Segmentation
=============================================*/

--Q12. Which age groups contribute the most to total attended appointment time
--and how do they rank relative to each other?
 
 SELECT age_group, SUM(appointment_duration) AS total_appointment_time, 
 RANK () OVER (ORDER BY SUM(appointment_duration) DESC) AS rank
 FROM appointments
 WHERE status = 'attended'
 GROUP BY age_group
 ORDER BY rank;
 
 --Q13. What percentage of appointment slots are utilised versus left available?
 
 WITH grouped AS (
  SELECT
    s.is_available,
    COUNT(DISTINCT s.slot_id) AS total_slots,
    COUNT(DISTINCT a.slot_id) AS booked_slots
  FROM slots s
  LEFT JOIN appointments a
    ON s.slot_id = a.slot_id
  GROUP BY s.is_available
)
SELECT
 CASE WHEN is_available = 'True' THEN 'Available'
 WHEN is_available = 'False' THEN 'Utilised'
 ELSE 'Unknown' END AS slot_status,
  g.total_slots,
  g.booked_slots,
  (SELECT SUM(total_slots) FROM grouped) AS grand_total_slots,
  ROUND(g.total_slots * 100.0 / (SELECT SUM(total_slots) FROM grouped), 2) AS pct_of_total
FROM grouped g;