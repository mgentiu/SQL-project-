# Medical Appointment Scheduling Analysis (SQL Project)

## Project Overview

This project analyses a medical appointment scheduling dataset using SQL to identify operational patterns in patient attendance, appointment utilisation, and scheduling efficiency.

The analysis explores patient behaviour, insurance provider utilisation, appointment demand patterns, and clinic capacity utilisation. The goal of the project is to demonstrate practical SQL skills used in data analysis and management information reporting.

---

## Dataset Description

The dataset represents a simplified healthcare appointment system and consists of three tables:

### Patients Table
| Column | Description |
|------|-------------|
| patient_id | Unique patient identifier |
| name | Patient name |
| sex | Patient gender |
| dob | Date of birth |
| insurance | Insurance provider |

### Appointments Table
| Column | Description |
|------|-------------|
| appointment_id | Unique appointment identifier |
| slot_id | Linked appointment slot |
| scheduling_date | Date the appointment was scheduled |
| appointment_date | Appointment date |
| appointment_time | Appointment time |
| status | Appointment status |
| waiting_time | Patient waiting time |
| appointment_duration | Duration of consultation |
| age | Patient age |
| age_group | Age group classification |

### Slots Table
| Column | Description |
|------|-------------|
| slot_id | Appointment slot identifier |
| appointment_date | Slot date |
| appointment_time | Slot time |
| is_available | Slot availability flag |

---

## SQL Skills Demonstrated

This project demonstrates the following SQL techniques:

- Data filtering (`WHERE`)
- Aggregations (`COUNT`, `SUM`, `AVG`)
- Data grouping (`GROUP BY`)
- Table joins (`LEFT JOIN`)
- Window functions (`RANK`)
- Conditional logic (`CASE`)
- Common Table Expressions (CTEs)
- Subqueries
- Date extraction using `strftime`
- Data validation and integrity checks

---

## Key Analytical Questions

The SQL queries answer several operational questions including:

1. Are there duplicate patient records in the dataset?
2. What is the distribution of appointment statuses?
3. How does waiting time vary by appointment status?
4. Which patients attend the most appointments?
5. What is the average waiting time per patient?
6. Who are the top patients based on appointment attendance?
7. How does appointment utilisation vary across insurance providers?
8. How many appointments are attended per insurance provider per month?
9. Which insurance providers account for the highest total appointment time?
10. How can insurance providers be segmented into High, Medium, and Low utilisation groups?
11. Which weekdays experience the highest appointment demand?
12. Which age groups account for the most attended appointment time?
13. What percentage of appointment slots are utilised versus left available?

---

## Key Insights

Some key findings from the analysis include:

- Appointment demand is concentrated on weekdays, with mid-week days experiencing the highest attendance.
- A small number of insurance providers account for a large share of total appointment time.
- Middle age groups contribute the most to total appointment utilisation.
- Analysis of scheduling slots indicates that the majority of appointment capacity remains unused.

---

## Visualisations

The results were exported to Excel to create visual summaries of key insights:

- Insurance provider utilisation
- Appointment demand by weekday
- Age group utilisation
- Slot availability distribution

Example visualisations:

![Insurance Utilisation](screenshots/insurance_utilisation.png)

![Weekday Demand]()

![Age Group Utilisation]()

![Slot Availability](screenshots/slot_utilisation.png)

---

## Tools Used

- SQL (SQLite)
- DB Browser for SQLite
- Microsoft Excel
- GitHub

---

## How to Run the Project

1. Download the dataset.
2. Import the tables into SQLite.
3. Open the `medical_appointments_analysis.sql` file.
4. Execute the queries sequentially to reproduce the analysis.

---

## Author

Madalin Gentiu  
[LinkedIn](https://www.linkedin.com/in/madalin-gentiu-a22477170/) | [GitHub](https://github.com/mgentiu/SQL-project-)
