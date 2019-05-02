-- -----------------------------------------------------
-- Business rule: Cancellations are done by simply tippexing out the appointment in the diary.
-- Queries:
-- 1. Delete the Treatments indicated in the cancelled Appointment
-- 2. Delete the cancelled Appointment
-- Test data= Appointment ID = 6, current status 1= SCHEDULED
-- -----------------------------------------------------
-- 1. Delete the Treatments indicated in the cancelled Appointment
DELETE FROM mydb.APPOINTMENT_TREATMENT
WHERE ATRM_APPOINTMENT_ID = 6;

-- 2. Delete the Cancelled Appointment
DELETE FROM mydb.APPOINTMENT
WHERE APP_ID = 6;
