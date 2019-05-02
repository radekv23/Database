-- -----------------------------------------------------
-- Business rule: If the patient needs specialist treatment which Dr Mulcahy cannot provide, she writes the
-- name of an appropriate specialist on the filled visit card and the secretary sends a patient referral to the specialist.
-- Queries: 
-- 1. Insert a Referral 
-- 2. Insert the treatments that the specialist can provide
-- Test data: Patient ID = 2, Specialist ID = 1, Treatment ID = 7
-- -----------------------------------------------------
-- 1. Insert a Referral 
START TRANSACTION;
USE mydb;
INSERT INTO mydb.REFERRAL (REF_PATIENT_ID, REF_SPECIALIST_ID, REF_DATE) VALUES (2, 1, CURRENT_DATE());
COMMIT;

-- 2. Insert the treatments that the specialist can provide
START TRANSACTION;
USE mydb;
INSERT INTO mydb.REFERRAL_TREATMENT (RTRM_REFERRAL_ID, RTRM_TREATMENT_ID, RTRM_COMMENTS) VALUES (3, 7, NULL);
COMMIT;

-- -----------------------------------------------------
-- Business rule: Patients ask Helen, the office secretary, for appointments, either by post, phoning or dropping
-- in. She writes the new appointment into the diary 
-- Queries: 
-- 1. Insert new Appointment
-- 2. Insert the requested Treatments
-- Test data: Patient ID = 2, Appointment Status = 1 SCHEDULED, Treatment ID = 1 Teeth Whitening, Treatment Status = 1 INDICATED
-- -----------------------------------------------------
-- 1. Insert new Appointment
START TRANSACTION;
USE mydb;
INSERT INTO mydb.APPOINTMENT (APP_PATIENT_ID, APP_DATE, APP_STATUS_ID) VALUES (2, CURRENT_DATE(), 1);
COMMIT;

-- 2. Insert the requested Treatments
START TRANSACTION;
USE mydb;
INSERT INTO mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID, ATRM_TREATMENT_ID, ATRM_STATUS_ID, ATRM_COMMENTS) VALUES (8, 1, 1, NULL);
INSERT INTO mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID, ATRM_TREATMENT_ID, ATRM_STATUS_ID, ATRM_COMMENTS) VALUES (8, 2, 1, NULL);
COMMIT;

-- -----------------------------------------------------
-- Business rule: Next, at about 2.30 p.m. she prepares bills by searching the patient charts to
-- find details of any unpaid treatments. Then she looks up the Treatment Fees guidelines book,
-- which Dr Mulcahy updates from time to time.
-- Queries: 
--  1. Update the previous fee for the treatment setting Is_current to 'N'
--  2. Insert new fee for a treatment with Is_current set to 'Y',indicating is the current fee
-- Test data: Treatment ID = 2 Sealants
-- -----------------------------------------------------
--  1. Update the previous fee for the treatment setting Is_current to 'N'
START TRANSACTION;
USE mydb;
UPDATE mydb.TREATMENT_FEE 
SET 	FEE_IS_CURRENT = 'N'
WHERE	FEE_TREATMENT_ID = 2
AND		FEE_IS_CURRENT = 'Y';
COMMIT;

--  2. Insert new fee for a treatment with Is_current set to 'Y',indicating is the current fee
START TRANSACTION;
USE mydb;
INSERT INTO mydb.TREATMENT_FEE (FEE_TREATMENT_ID, FEE_AMOUNT, FEE_UPDATED, FEE_IS_CURRENT) VALUES (2, 80, CURRENT_DATE(), 'Y');
COMMIT;

-- -----------------------------------------------------
-- Business rule: Late cancellations are charged a €10 late cancellation fee.
-- Although the fee for late cancellations is flat, this project includes the possibility of updating this fee when necessary.
-- Queries: 
--  1. Update the previous fee for the late cancellations setting Is_current to 'N'
--  2. Insert new fee for a late cancellation with Is_current set to 'Y',indicating is the current fee
-- -----------------------------------------------------
--  1. Update the previous fee setting Is_current to 'N'
START TRANSACTION;
USE mydb;
UPDATE mydb.LATE_CANCELLATION_FEE 
SET 	LCF_IS_CURRENT = 'N'
WHERE	LCF_IS_CURRENT = 'Y';
COMMIT;

--  2. Insert new fee for a late cancellation with Is_current set to 'Y',indicating is the current fee
START TRANSACTION;
USE mydb;
INSERT INTO mydb.LATE_CANCELLATION_FEE (LCF_AMOUNT, LCF_UPDATED, LCF_IS_CURRENT) VALUES (12, CURRENT_DATE(), 'Y');
COMMIT;


-- -----------------------------------------------------
-- Business rule: Patients pay by cheque, credit card or cash, either by post or by dropping in. The bill or the
-- bill number is enclosed with the payment. Treatments which have been paid for are marked
-- as such in the patient's file so that they will not be billed again.
-- Queries: 
-- 1. Insert new Payment for a bill
-- 2. Update Bill status to PAID 
-- 3. Update Appointment_Treatment status to PAID
-- 4. Update Late Cancellations status to LATE CANCELLATION PAID (if any)
-- Test data: Bill number = 3, previous status= 2 SENT, Type= Credit Card
-- -----------------------------------------------------
-- 1. Insert new Payment for a bill
START TRANSACTION;
USE mydb;
INSERT INTO mydb.PAYMENT (PAY_BILL_NUMBER, PAY_NUMBER, PAY_DATE, PAY_AMOUNT, PAY_TYPE) VALUES (3, 1, CURRENT_DATE(), 50, 'CC');
COMMIT;

-- 2. Update Bill status and Appointment_Treatment status to PAID
START TRANSACTION;
USE mydb;
UPDATE mydb.BILL
SET		BILL_STATUS_ID = 3		-- Bill Status 3= PAID
WHERE	BILL_NUMBER = 3;
COMMIT;

-- 3. Update Appointment_Treatment status to PAID
-- The Select gets the ID of the Appoinment_Treatment records included in the Bill that was paid
-- and the Update changes the status of those records to PAID
START TRANSACTION;
USE mydb;
UPDATE mydb.APPOINTMENT_TREATMENT
SET		ATRM_STATUS_ID = 4	-- Treatment Status 4= PAID
WHERE	ATRM_ID IN (SELECT BTRM_APP_TREATMENT_ID
					FROM	mydb.BILL_TREATMENT
					WHERE	BTRM_BILL_NUMBER = 3);
COMMIT;

-- 4. Update Late Cancellations status to LATE CANCELLATION PAID (if any)
--    The Select gets the ID of the Appointment (Late Cancelled) records included in the Bill that was paid
--    and the Update changes the status of those records to LATE CANCELLATION PAID
START TRANSACTION;
USE mydb;
UPDATE  mydb.APPOINTMENT
SET		APP_STATUS_ID = 7	-- Appointment Status 7= LATE CANCELLATION PAID
WHERE	APP_ID IN (SELECT   BLT_APPOINTMENT_ID
					FROM	mydb.BILL_LATE_CANCELLATION
					WHERE	BLT_BILL_NUMBER = 3);
COMMIT;

-- -----------------------------------------------------
-- Business rule: Next, at about 2.30 p.m. she prepares bills by searching the patient charts to
-- find details of any unpaid treatments. Then she looks up the Treatment Fees guidelines book,
-- which Dr Mulcahy updates from time to time. The bills, itemising all unpaid treatments and
-- late cancellations, are sent to patients in the afternoon post.
-- Test data: Bill Number = 5, Patient ID = 3, Bill status = 1 NEW, Agreed payments = 1
-- Queries:
-- 1. Insert the new BILL
-- 2. Insert the Appointment_Treatments included in the bill
-- 3. Update the Appointment_treatments status to BILLED
-- -----------------------------------------------------
-- 1. Insert the new BILL. Bill Number = 5, Patient ID = 3, Bill status = 1 NEW, Agreed payments = 1
START TRANSACTION;
USE mydb;
INSERT INTO mydb.BILL (BILL_PATIENT_ID, BILL_DATE, BILL_STATUS_ID, BILL_AGREED_PAYMENTS) VALUES (3, CURRENT_DATE(), 1, 1);
COMMIT;

-- 2. Insert the Appointment_Treatments included in the bill. 
--    The Select gets the Treatments PERFORMED on the Patient and also gets the current fee for those Treatments.
START TRANSACTION;
USE mydb;
INSERT INTO mydb.BILL_TREATMENT (BTRM_BILL_NUMBER, BTRM_APP_TREATMENT_ID, BTRM_TREATMENT_FEE_ID)
SELECT	5,			-- Bill number
		ATRM_ID,	-- Treatment being billed
        FEE_ID		-- Treatment's current fee
FROM 	mydb.APPOINTMENT,
		mydb.APPOINTMENT_TREATMENT,
		mydb.TREATMENT_FEE
WHERE	FEE_TREATMENT_ID = ATRM_TREATMENT_ID
AND		ATRM_APPOINTMENT_ID = APP_ID
AND		FEE_IS_CURRENT = 'Y'			-- Is the current fee for the treatment
AND		ATRM_STATUS_ID = 2 				-- Treatment Status 2 = PERFORMED
AND		APP_PATIENT_ID = 3;				-- Patient	
COMMIT;

-- 3. Update the Appointment_treatments status to BILLED
--    The Select gets the ID of the Appoinment_Treatment records included in the Bill that was created
--    and the Update changes the status of those records to BILLED
START TRANSACTION;
USE mydb;
UPDATE mydb.APPOINTMENT_TREATMENT
SET		ATRM_STATUS_ID = 3	-- Treatment Status 3= BILLED
WHERE	ATRM_ID IN (SELECT  BTRM_APP_TREATMENT_ID
					FROM	mydb.BILL_TREATMENT
					WHERE	BTRM_BILL_NUMBER = 5);
COMMIT;

-- 4. Insert the Late Cancellations included in the bill (if any)
--    The Select gets the LATE CANCELLED Appointments and also gets the current fee.
START TRANSACTION;
USE mydb;
INSERT INTO mydb.BILL_LATE_CANCELLATION (BLT_BILL_NUMBER, BLT_APPOINTMENT_ID, BLT_LATE_CANCEL_FEE_ID) 
SELECT	5,
		APP_ID,		-- Late cancellation being billed
		LCF_ID		-- Late cancellation's current fee
FROM	mydb.APPOINTMENT,
		mydb.LATE_CANCELLATION_FEE
WHERE	LCF_IS_CURRENT = 'Y'		-- Is the current fee for late cancellations
AND 	APP_STATUS_ID = 5			-- APPOINTMENT Status 5 = LATE CANCELLED
AND		APP_PATIENT_ID = 3;			-- Patient to whom you wish to obtain the items to be billed
COMMIT;

-- 5. Update the Late Cancellations status to LATE CANCELLATION BILLED
--    The Select gets the ID of the Appointment records included in the Bill that was created
--    and the Update changes the status of those records to LATE CANCELLATION BILLED
START TRANSACTION;
USE mydb;
UPDATE  mydb.APPOINTMENT
SET		APP_STATUS_ID = 6	-- Appointment Status 7= LATE CANCELLATION BILLED
WHERE	APP_ID IN (SELECT   BLT_APPOINTMENT_ID
					FROM	mydb.BILL_LATE_CANCELLATION
					WHERE	BLT_BILL_NUMBER = 5);
COMMIT;


