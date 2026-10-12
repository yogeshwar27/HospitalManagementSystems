-- ==============================================================================
-- MEDIKIOSK HOSPITAL MANAGEMENT SYSTEM
-- Layer 3: Useful Relational SQL Queries (queries.sql)
-- ==============================================================================

-- 1. Daily OPD Queue with Patient & Doctor Information (Multi-Table JOIN)
SELECT 
    a.token_number,
    a.appointment_number,
    p.mrn AS patient_mrn,
    p.name AS patient_name,
    p.phone AS patient_phone,
    d.name AS doctor_name,
    d.department,
    d.room_number,
    a.time_slot,
    a.status
FROM appointments a
INNER JOIN patients p ON a.patient_id = p.id
INNER JOIN doctors d ON a.doctor_id = d.id
WHERE a.appointment_date = CURRENT_DATE
ORDER BY a.token_number ASC;

-- 2. Patient Electronic Health Record (EHR) Complete History
SELECT 
    p.mrn,
    p.name AS patient_name,
    p.blood_group,
    pr.visit_date,
    pr.chief_complaint,
    pr.diagnosis,
    pr.blood_pressure,
    pr.heart_rate,
    pr.temperature,
    pr.spo2,
    pr.prescriptions_json,
    d.name AS attending_physician,
    pr.follow_up_date
FROM patient_records pr
JOIN patients p ON pr.patient_id = p.id
JOIN doctors d ON pr.doctor_id = d.id
WHERE p.mrn = 'MK-2026-001'
ORDER BY pr.visit_date DESC;

-- 3. Departmental Workload & Appointment Distribution (Aggregation & GROUP BY)
SELECT 
    d.department,
    COUNT(a.id) AS total_appointments,
    SUM(CASE WHEN a.status = 'CONFIRMED' THEN 1 ELSE 0 END) AS confirmed_count,
    SUM(CASE WHEN a.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN a.status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_count
FROM appointments a
JOIN doctors d ON a.doctor_id = d.id
GROUP BY d.department
ORDER BY total_appointments DESC;

-- 4. Patients with Critical Allergies or Chronic Conditions
SELECT 
    mrn,
    name,
    age,
    blood_group,
    phone,
    allergies,
    chronic_conditions
FROM patients
WHERE allergies IS NOT NULL AND allergies != 'No known drug allergies'
ORDER BY name ASC;

-- 5. Doctor Consultation Fees & Duty Schedule
SELECT 
    d.name,
    d.department,
    d.specialization,
    d.room_number,
    d.consultation_fee,
    d.available_days,
    COUNT(a.id) AS assigned_appointments_today
FROM doctors d
LEFT JOIN appointments a ON d.id = a.doctor_id AND a.appointment_date = CURRENT_DATE
GROUP BY d.id, d.name, d.department, d.specialization, d.room_number, d.consultation_fee, d.available_days
ORDER BY d.department ASC;
