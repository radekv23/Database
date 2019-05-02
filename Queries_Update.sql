-- -----------------------------------------------------
-- Business rule: Treatments which have been paid for are marked as such in the patient's file
-- Queries:
-- 1. Update the status of a Bill from SENT to PAID
-- 2. Update the status of its Treatments to PAID
-- 3. Update the status of its Late Cancellations to LATE CANCELLATION PAID
-- Test data: BILL_ID=4, previous status: 2 (SENT)
-- -----------------------------------------------------

-- 1. Update the status of a Bill from SENT to PAID
START TRANSACTION;
USE mydb;

UPDATE  mydb.BILL
SET		BILL_STATUS_ID = 3		-- Bill Status 3= PAID
WHERE	BILL_NUMBER = 4;

COMMIT;

-- 2. Update the status of its Treatments to PAID
--    The Select gets the ID of the Appoinment_Treatment records included in the Bill that was paid
--    and the Update changes the status of those records to PAID
START TRANSACTION;
USE mydb;

UPDATE  mydb.APPOINTMENT_TREATMENT
SET		ATRM_STATUS_ID = 4	-- Treatment Status 4= PAID
WHERE	ATRM_ID IN (SELECT  BTRM_APP_TREATMENT_ID
					FROM	mydb.BILL_TREATMENT
					WHERE	BTRM_BILL_NUMBER = 4);
COMMIT;

-- 3. Update the status of its Late Cancellations to LATE CANCELLATION PAID
--    The Select gets the ID of the Appointment (Late Cancelled) records included in the Bill that was paid
--    and the Update changes the status of those records to LATE CANCELLATION PAID
START TRANSACTION;
USE mydb;

UPDATE  mydb.APPOINTMENT
SET		APP_STATUS_ID = 7	-- Appointment Status 7= LATE CANCELLATION PAID
WHERE	APP_ID IN (SELECT   BLT_APPOINTMENT_ID
					FROM	mydb.BILL_LATE_CANCELLATION
					WHERE	BLT_BILL_NUMBER = 4);

COMMIT;

-- -----------------------------------------------------
-- Business rule: Rearrangements are made by referring to the appointments diary to find a free time, and tippexing out the old time.
-- Queries:
-- 1. Rearrange an Appointment (update the date)
-- Test data: Appointment ID = 7
-- -----------------------------------------------------

-- 1. Rearrange an Appointment (update the date) 
START TRANSACTION;
USE mydb;

UPDATE  mydb.APPOINTMENT
SET		APP_DATE = '2018-06-15'
WHERE	APP_ID = 7;

COMMIT;

-- -----------------------------------------------------
-- Business rule: After each visit, Dr Mulcahy completes the appointment card with details of work done
-- Query: Update Comments of a Treatment of an Appointment 
-- Test data: Appointment ID = 1 and Appointment-Treatment ID= 1
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;

UPDATE  mydb.APPOINTMENT_TREATMENT
SET		ATRM_COMMENTS = 'The treatment was carried out successfully'
WHERE	ATRM_APPOINTMENT_ID = 1
AND		ATRM_ID = 1;

COMMIT;

-- -----------------------------------------------------
-- Business rule: After specialist treatment, the specialist posts a dental report to Dr Mulcahy, who reads it and files it in the patient's chart.
-- Query: Update the comments in the Referral-Treatment in order to add the specialist report
-- Test data Referral ID= 2 and Treatment ID = 7
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;

UPDATE  mydb.REFERRAL_TREATMENT
SET		RTRM_COMMENTS = 'Orthodontic treatment was scheduled to be performed within eight months'
WHERE	RTRM_REFERRAL_ID = 2
AND		RTRM_TREATMENT_ID = 7;

COMMIT;