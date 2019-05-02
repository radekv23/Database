-- -----------------------------------------------------
-- Business rule: Every Tuesday morning, Helen checks the appointment diary and makes a list of all next week's appointments.
-- Query: Appointments Scheduled between two dates
--        It is useful to get scheduled appointments for the following week
-- APP_STATUS_ID = 1 (SCHEDULED)
-- -----------------------------------------------------
SELECT  APP_DATE			APPOINTMENT_DATE,
		CONCAT(PAT_FIRST_NAME,' ',PAT_LAST_NAME) PATIENT,
		PAT_PHONE_NUMBER	PHONE_NUMBER,
		PAT_ADDRESS			ADDRESS
FROM    mydb.PATIENT,
		mydb.APPOINTMENT
WHERE   PAT_ID = APP_PATIENT_ID
AND		APP_DATE >= '2018-04-01'
AND     APP_DATE <= '2018-04-15'
AND		APP_STATUS_ID = 1 -- APP_STATUS_ID = 1 (SCHEDULED)
ORDER BY APP_DATE;

-- -----------------------------------------------------
-- Business rule: Patients ask Helen, the office secretary, for appointments, either by post, phoning or dropping
-- in. She arranges a suitable appointment by referring to the appointments diary unless they
-- owe over a certain amount, or for too long, as seen from the patient's chart.
-- Query: Select the details of a Patient's debt (as an example Patient ID = 1). 
--     	  It is useful to verify if the patient owes over a certain amount, or for too long.
--        This query obtains the details of the New and Sent Bills.
--        The first part of the query gets the description and fee for each treatment included in the bill 
--        and the second part gets the fee for each late cancellation included in the bill.
-- Test data: Patient ID = 1, Bill status: 1= NEW,  2=SENT 
-- -----------------------------------------------------
SELECT	BILL_NUMBER,
		BILL_DATE,
		TRM_NAME	DESCRIPTION,
		FEE_AMOUNT	FEE
FROM	mydb.TREATMENT,
		mydb.APPOINTMENT_TREATMENT,
		mydb.TREATMENT_FEE,
		mydb.BILL_TREATMENT,
		mydb.BILL
WHERE	TRM_ID = ATRM_TREATMENT_ID
AND		ATRM_ID = BTRM_APP_TREATMENT_ID
AND		FEE_ID = BTRM_TREATMENT_FEE_ID
AND     BTRM_BILL_NUMBER = BILL_NUMBER
AND		BILL_STATUS_ID IN (1,2)		-- Bill Status 1= NEW, 2= SENT
AND		BILL_PATIENT_ID = 1			-- Patient to whom you wish to obtain his debt
UNION
SELECT	BILL_NUMBER,
		BILL_DATE,
		'Late Cancellation'	DESCRIPTION,
		LCF_AMOUNT		FEE
FROM	mydb.LATE_CANCELLATION_FEE,
		mydb.BILL_LATE_CANCELLATION,
		mydb.BILL
WHERE	LCF_ID = BLT_LATE_CANCEL_FEE_ID
AND     BLT_BILL_NUMBER = BILL_NUMBER
AND		BILL_STATUS_ID IN (1,2)		-- Bill Status 1= NEW, 2= SENT
AND		BILL_PATIENT_ID = 1			-- Patient to whom you wish to obtain his debt
ORDER BY BILL_NUMBER;

-- -----------------------------------------------------
-- Business rule: The bills, itemising all unpaid treatments and late cancellations, are sent to patients in the afternoon post.
-- Query: Select the treatments of a Patient (as an example Patient ID = 1) to be billed, and then be inserted into the BILL_TREATMENT table.
--        At the time of billing, the Treatment with Performed status will be billed.
--        At the time of billing, the current Treatment fee must be used.
-- Test data: Patient ID = 3, Treatment Status = 2 PERFORMED
-- -----------------------------------------------------
SELECT	ATRM_ID,	-- Treatment being billed
        FEE_ID		-- Treatment's current fee
FROM 	mydb.APPOINTMENT,
		mydb.APPOINTMENT_TREATMENT,
		mydb.TREATMENT_FEE
WHERE	FEE_TREATMENT_ID = ATRM_TREATMENT_ID
AND		ATRM_APPOINTMENT_ID = APP_ID
AND		FEE_IS_CURRENT = 'Y'			-- Is the current fee for the treatment
AND		ATRM_STATUS_ID = 2 				-- Treatment Status = PERFORMED
AND		APP_PATIENT_ID = 3;				-- Patient to whom you wish to obtain the items to be billed

-- -----------------------------------------------------
-- Business rule: The bills, itemising all unpaid treatments and late cancellations, are sent to patients in the afternoon post.
-- Query: Select the Late Cancellations of a Patient (as an example Patient ID = 1) to be billed, and then be inserted into the BILL_LATE_CANCELLATION table.
--        At the time of billing, the APPOINTMENT with Late Cancelled status will be billed.   
--        At the time of billing, the current fee for late cancellations must be used.
-- Test data: Patient ID = 1, APPOINTMENT Status 5 = LATE CANCELLED
-- -----------------------------------------------------
SELECT	APP_ID,		-- Late cancellation being billed
		LCF_ID		-- Late cancellation's current fee
FROM	mydb.APPOINTMENT,
		mydb.LATE_CANCELLATION_FEE
WHERE	LCF_IS_CURRENT = 'Y'		-- Is the current fee for late cancellations
AND 	APP_STATUS_ID = 5			-- APPOINTMENT Status = LATE CANCELLED
AND		APP_PATIENT_ID = 1;			-- Patient to whom you wish to obtain the items to be billed

-- -----------------------------------------------------
-- Business rule: The bills, itemising all unpaid treatments and late cancellations, are sent to patients in the afternoon post.
-- Query: Select the details of a Bill (As an example Bill Number = 1)
--        Details include treatments and late cancellations billed. As well as billing information and patient name
-- Test data: Bill number = 1
-- -----------------------------------------------------

SELECT	BILL_NUMBER,
		BILL_DATE,
		BST_NAME	BILL_STATUS,
		CONCAT(PAT_FIRST_NAME,' ',PAT_LAST_NAME)	PATIENT,
		TRM_NAME	DESCRIPTION,
		FEE_AMOUNT	AMOUNT
FROM	mydb.TREATMENT,
		mydb.APPOINTMENT_TREATMENT,
		mydb.TREATMENT_FEE,
		mydb.BILL_TREATMENT,
		mydb.BILL_STATUS,
		mydb.PATIENT,
		mydb.BILL
WHERE	TRM_ID = ATRM_TREATMENT_ID
AND		ATRM_ID = BTRM_APP_TREATMENT_ID
AND		FEE_ID = BTRM_TREATMENT_FEE_ID
AND     BTRM_BILL_NUMBER = BILL_NUMBER
AND		BST_ID = BILL_STATUS_ID
AND		PAT_ID = BILL_PATIENT_ID
AND		BILL_NUMBER = 1
UNION
SELECT	BILL_NUMBER,
		BILL_DATE,
		BST_NAME	BILL_STATUS,
		PAT_LAST_NAME||' '||PAT_FIRST_NAME	PATIENT,
		'Late Cancellation'	DESCRIPTION,
		LCF_AMOUNT	FEE
FROM	mydb.LATE_CANCELLATION_FEE,
		mydb.BILL_LATE_CANCELLATION,
		mydb.BILL_STATUS,
		mydb.PATIENT,
		BILL
WHERE	LCF_ID = BLT_LATE_CANCEL_FEE_ID
AND     BLT_BILL_NUMBER = BILL_NUMBER
AND		BST_ID = BILL_STATUS_ID
AND		PAT_ID = BILL_PATIENT_ID
AND		BILL_NUMBER = 1;

-- -----------------------------------------------------
-- Business rule: Helen passes the appointment card to Dr Mulcahy so that she can see what treatments are to be carried out.
-- Query: Select the details of an Appointment (as an example Appointment ID = 1).
-- Test data: Appointment ID = 1
-- -----------------------------------------------------

SELECT	CONCAT(PAT_FIRST_NAME,' ',PAT_LAST_NAME) PATIENT,
		APP_DATE		APPOINTMENT_DATE,
		APST_NAME		APPOINTMENT_STATUS,
		TRM_NAME		TREATMENT,
		TRST_NAME		TREATMENT_STATUS,
		ATRM_COMMENTS	COMMENTS
FROM	mydb.TREATMENT,
		mydb.TREATMENT_STATUS,
		mydb.APPOINTMENT_TREATMENT,
		mydb.APPOINTMENT_STATUS,
		mydb.PATIENT,
		mydb.APPOINTMENT
WHERE	TRST_ID = ATRM_STATUS_ID
AND		TRM_ID = ATRM_TREATMENT_ID
AND		ATRM_APPOINTMENT_ID = APP_ID
AND		APST_ID = APP_STATUS_ID
AND		PAT_ID = APP_PATIENT_ID
AND		APP_ID = 1;

-- -----------------------------------------------------
-- Business rule: If the patient needs specialist treatment which Dr Mulcahy cannot provide, she writes the
-- name of an appropriate specialist on the filled visit card and the secretary sends a patient referral to the specialist.
-- Query: Select the details of Referrals sent to a Patient
-- Test data: Patient ID=1
-- -----------------------------------------------------
SELECT	CONCAT(SPC_FIRST_NAME,' ',SPC_LAST_NAME) AS	SPECIALIST,
		REF_DATE		REFERRAL_DATE,
		TRM_NAME		TREATMENT,
		RTRM_COMMENTS	COMMENTS
FROM	mydb.TREATMENT,
		mydb.REFERRAL_TREATMENT,
		mydb.SPECIALIST,
		mydb.REFERRAL
WHERE	TRM_ID = RTRM_TREATMENT_ID
AND		RTRM_REFERRAL_ID = REF_ID
AND		SPC_ID = REF_SPECIALIST_ID
AND		REF_PATIENT_ID = 1
ORDER BY REF_DATE;

-- -----------------------------------------------------
-- Query to get all the possible statuses that an Appointment can have
-- -----------------------------------------------------
SELECT  APST_NAME			APP_STATUS,
		APST_DESCRIPTION	DESCRIPTION
FROM 	mydb.APPOINTMENT_STATUS
ORDER BY APST_NAME;

-- -----------------------------------------------------
-- Query to get all the possible statuses that a Bill can have
-- -----------------------------------------------------
SELECT  BST_NAME		BILL_STATUS,
		BST_DESCRIPTION	DESCRIPTION
FROM 	mydb.BILL_STATUS
ORDER BY BST_NAME;

-- -----------------------------------------------------
-- Query to get all late cancellation fees ordered from the most recent to the oldest
-- -----------------------------------------------------
SELECT 	LCF_UPDATED	UPDATED,
		LCF_AMOUNT	AMOUNT,
		LCF_IS_CURRENT	IS_CURRENT
FROM 	mydb.LATE_CANCELLATION_FEE
ORDER BY LCF_UPDATED DESC;

-- -----------------------------------------------------
-- Query to get the list of Patients ordered by Patient Name
-- -----------------------------------------------------
SELECT  CONCAT(PAT_FIRST_NAME,' ',PAT_LAST_NAME)	PATIENT_NAME,
		PAT_BIRTHDATE		BIRTHDATE,
		PAT_ADDRESS			ADDRESS,
		PAT_EMAIL			EMAIL,
		PAT_PHONE_NUMBER	PHONE_NUMBER
FROM 	mydb.PATIENT
ORDER BY PATIENT_NAME;

-- -----------------------------------------------------
-- Query to get the Types of Payment
-- -----------------------------------------------------
SELECT 	PTY_TYPE		PAYMENT_TYPE,
		PTY_DESCRIPTION	DESCRIPTION
FROM 	mydb.PAYMENT_TYPE
ORDER BY PTY_TYPE;

-- -----------------------------------------------------
-- Query to get the list of Specialists ordered by Specialist name
-- -----------------------------------------------------
SELECT 	CONCAT(SPC_FIRST_NAME,' ',SPC_LAST_NAME)	SPECIALIST_NAME,
		SPC_CONTACT_NUMBER					CONTACT_NUMBER
FROM 	mydb.SPECIALIST
ORDER BY SPECIALIST_NAME;

-- -----------------------------------------------------
-- Query to get all the Treatments
-- -----------------------------------------------------
SELECT 	TRM_NAME		TREATMENT,
		TRM_DESCRIPTION	DESCRIPTION
FROM 	mydb.TREATMENT
ORDER BY TRM_NAME;

-- -----------------------------------------------------
-- Query to get all the fees for each Treatment ordered first by Treatment and then from the most recent to the oldest one
-- -----------------------------------------------------
SELECT 	TRM_NAME		TREATMENT,
		FEE_AMOUNT		AMOUNT,
		FEE_UPDATED		UPDATED,
		FEE_IS_CURRENT	IS_CURRENT
FROM	mydb.TREATMENT_FEE,
		mydb.TREATMENT
WHERE	TRM_ID = FEE_TREATMENT_ID
ORDER BY TRM_NAME ASC, FEE_UPDATED DESC;

-- -----------------------------------------------------
-- Query to get all the possible statuses that a Treatment can have
-- -----------------------------------------------------
SELECT 	TRST_NAME			TREATMENT_STATUS,
		TRST_DESCRIPTION	DESCRIPTION
FROM 	mydb.TREATMENT_STATUS
ORDER BY TRST_NAME;