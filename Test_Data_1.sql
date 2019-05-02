-- -----------------------------------------------------
-- Data for table mydb.SPECIALIST
-- Test data for Specialists (used in the referrals)
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.SPECIALIST (SPC_FIRST_NAME, SPC_LAST_NAME, SPC_CONTACT_NUMBER) VALUES ('Renata', 'Clark', '021-334455');
INSERT INTO mydb.SPECIALIST (SPC_FIRST_NAME, SPC_LAST_NAME, SPC_CONTACT_NUMBER) VALUES ('Sergio', 'Moretti', '021-998855');
INSERT INTO mydb.SPECIALIST (SPC_FIRST_NAME, SPC_LAST_NAME, SPC_CONTACT_NUMBER) VALUES ('Tony', 'Green', '021-447788');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.PATIENT
-- Test data for Patients
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.PATIENT (PAT_FIRST_NAME, PAT_LAST_NAME, PAT_BIRTHDATE, PAT_ADDRESS, PAT_EMAIL, PAT_PHONE_NUMBER) VALUES ('Jhon', 'Smith', '1980-10-02', '45 O Connell Street A78YW35', 'jsmith@gmail.com', '021-885577');
INSERT INTO mydb.PATIENT (PAT_FIRST_NAME, PAT_LAST_NAME, PAT_BIRTHDATE, PAT_ADDRESS, PAT_EMAIL, PAT_PHONE_NUMBER) VALUES ('Sarah', 'Gellar', '1976-05-20', '56 Goldbrook Sq Castleknock', 'sgellar@hotmail.com', '021-897744');
INSERT INTO mydb.PATIENT (PAT_FIRST_NAME, PAT_LAST_NAME, PAT_BIRTHDATE, PAT_ADDRESS, PAT_EMAIL, PAT_PHONE_NUMBER) VALUES ('Chris', 'Thompson', '1990-01-04', '56 Goldbrook Sq Diswellstown Road', 'cthompson@hotmail.com', '021-775599');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.APPOINTMENT_STATUS
-- This data consists of the possible statuses that an appointment can have
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.APPOINTMENT_STATUS (APST_NAME, APST_DESCRIPTION) VALUES ('SCHEDULED', 'The appointment have been scheduled');
INSERT INTO mydb.APPOINTMENT_STATUS (APST_NAME, APST_DESCRIPTION) VALUES ('CHECKED IN', 'The patient arrived to the practice');
INSERT INTO mydb.APPOINTMENT_STATUS (APST_NAME, APST_DESCRIPTION) VALUES ('COMPLETED', 'The appointment was completed');
INSERT INTO mydb.APPOINTMENT_STATUS (APST_NAME, APST_DESCRIPTION) VALUES ('CANCELLED', 'The appointment was cancelled');
INSERT INTO mydb.APPOINTMENT_STATUS (APST_NAME, APST_DESCRIPTION) VALUES ('LATE CANCELLED', 'Patient missed the appointment or cancelled late. This will be billed at the next billing');
INSERT INTO mydb.APPOINTMENT_STATUS (APST_NAME, APST_DESCRIPTION) VALUES ('LATE CANCELLATION BILLED', 'Late cancellation of the appointment was billed');
INSERT INTO mydb.APPOINTMENT_STATUS (APST_NAME, APST_DESCRIPTION) VALUES ('LATE CANCELLATION PAID', 'Late cancellation of the appointment was paid for');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.APPOINTMENT
-- Test data for Appointments
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.APPOINTMENT (APP_PATIENT_ID, APP_DATE, APP_STATUS_ID) VALUES (1, '2018-03-05', 3);
INSERT INTO mydb.APPOINTMENT (APP_PATIENT_ID, APP_DATE, APP_STATUS_ID) VALUES (2, '2018-03-05', 3);
INSERT INTO mydb.APPOINTMENT (APP_PATIENT_ID, APP_DATE, APP_STATUS_ID) VALUES (3, '2018-03-06', 6);
INSERT INTO mydb.APPOINTMENT (APP_PATIENT_ID, APP_DATE, APP_STATUS_ID) VALUES (1, '2018-03-10', 3);
INSERT INTO mydb.APPOINTMENT (APP_PATIENT_ID, APP_DATE, APP_STATUS_ID) VALUES (3, '2018-04-06', 3);
INSERT INTO mydb.APPOINTMENT (APP_PATIENT_ID, APP_DATE, APP_STATUS_ID) VALUES (1, '2018-04-10', 1);
INSERT INTO mydb.APPOINTMENT (APP_PATIENT_ID, APP_DATE, APP_STATUS_ID) VALUES (2, '2018-04-10', 1);

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.TREATMENT
-- This test data consists of a small list of dental treatments
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.TREATMENT (TRM_NAME, TRM_DESCRIPTION) VALUES ('Teeth Whitening', 'There are various teeth whitening options available, including in-office and at-home bleaching.');
INSERT INTO mydb.TREATMENT (TRM_NAME, TRM_DESCRIPTION) VALUES ('Sealants', 'Dental sealants, usually applied to the chewing surface of teeth, act as a barrier against decay-causing bacteria. Most often, the sealants are applied to the back teeth, e.g., premolars and molars.');
INSERT INTO mydb.TREATMENT (TRM_NAME, TRM_DESCRIPTION) VALUES ('Root Canals', 'Root canals treat diseases or absessed teeth. Once a tooth is injured, cracked or decayed, it is necessary to open the tooth and clean out the infected tissue in the centre. This space is then filled and the opening sealed.');
INSERT INTO mydb.TREATMENT (TRM_NAME, TRM_DESCRIPTION) VALUES ('Extraction', 'A severely damaged tooth may need to be extracted. Permanent teeth may also need to be removed for orthodontic treatment.');
INSERT INTO mydb.TREATMENT (TRM_NAME, TRM_DESCRIPTION) VALUES ('Crowns and Caps', 'Crowns are dental restorations that protect damaged, cracked or broken teeth. ');
INSERT INTO mydb.TREATMENT (TRM_NAME, TRM_DESCRIPTION) VALUES ('Dentures', 'Dentures are prosthetic devices replacing lost teeth. There are two types of dentures – partial and full. ');
INSERT INTO mydb.TREATMENT (TRM_NAME, TRM_DESCRIPTION) VALUES ('Braces', 'A dental brace is a device used to correct the alignment of teeth and bite-related problems (including underbite, overbite, etc.). Braces straighten teeth by exerting steady pressure on the teeth.');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.TREATMENT_STATUS
-- This data consists of the possible statuses that an treatment can have
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.TREATMENT_STATUS (TRST_NAME, TRST_DESCRIPTION) VALUES ('INDICATED', 'Treatment was indicated to be performed at an appointment');
INSERT INTO mydb.TREATMENT_STATUS (TRST_NAME, TRST_DESCRIPTION) VALUES ('PERFORMED', 'The treatment was performed and  will be billed in the next billing');
INSERT INTO mydb.TREATMENT_STATUS (TRST_NAME, TRST_DESCRIPTION) VALUES ('BILLED', 'The treatment was billed');
INSERT INTO mydb.TREATMENT_STATUS (TRST_NAME, TRST_DESCRIPTION) VALUES ('PAID', 'The treatment was paid for');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.APPOINTMENT_TREATMENT
-- Test data for treatments performed on patients during appointments
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID, ATRM_TREATMENT_ID, ATRM_STATUS_ID, ATRM_COMMENTS) VALUES (1, 5, 4, 'Procedure complete');
INSERT INTO mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID, ATRM_TREATMENT_ID, ATRM_STATUS_ID, ATRM_COMMENTS) VALUES (2, 1, 4, 'Sensitivity in the gums');
INSERT INTO mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID, ATRM_TREATMENT_ID, ATRM_STATUS_ID, ATRM_COMMENTS) VALUES (3, 1, 1, NULL);
INSERT INTO mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID, ATRM_TREATMENT_ID, ATRM_STATUS_ID, ATRM_COMMENTS) VALUES (4, 1, 3, 'Procedure complete');
INSERT INTO mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID, ATRM_TREATMENT_ID, ATRM_STATUS_ID, ATRM_COMMENTS) VALUES (5, 5, 2, 'Procedure complete');
INSERT INTO mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID, ATRM_TREATMENT_ID, ATRM_STATUS_ID, ATRM_COMMENTS) VALUES (6, 2, 1, NULL);
INSERT INTO mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID, ATRM_TREATMENT_ID, ATRM_STATUS_ID, ATRM_COMMENTS) VALUES (7, 2, 1, NULL);

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.REFERRAL
-- Test data for Referrals to specialists
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.REFERRAL (REF_PATIENT_ID, REF_SPECIALIST_ID, REF_DATE) VALUES (1, 1, '2018-03-03');
INSERT INTO mydb.REFERRAL (REF_PATIENT_ID, REF_SPECIALIST_ID, REF_DATE) VALUES (3, 2, '2018-02-10');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.BILL_STATUS
-- This data consists of the possible statuses that an bill can have
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.BILL_STATUS (BST_NAME, BST_DESCRIPTION) VALUES ('NEW', 'The bill was created. The items of this bill must be updated to BILLED status');
INSERT INTO mydb.BILL_STATUS (BST_NAME, BST_DESCRIPTION) VALUES ('SENT', 'The bill was sent to the patient');
INSERT INTO mydb.BILL_STATUS (BST_NAME, BST_DESCRIPTION) VALUES ('PAID', 'The bill was paid (complete). The items of this bill must be updated to PAID status');
INSERT INTO mydb.BILL_STATUS (BST_NAME, BST_DESCRIPTION) VALUES ('PARTIALLY PAID', 'The patient has made some of the agreed payments for the bill');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.BILL
-- test data for bills
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.BILL (BILL_PATIENT_ID, BILL_DATE, BILL_STATUS_ID, BILL_AGREED_PAYMENTS) VALUES (1, '2018-03-15', 3, 1);
INSERT INTO mydb.BILL (BILL_PATIENT_ID, BILL_DATE, BILL_STATUS_ID, BILL_AGREED_PAYMENTS) VALUES (2, '2018-03-15', 3, 1);
INSERT INTO mydb.BILL (BILL_PATIENT_ID, BILL_DATE, BILL_STATUS_ID, BILL_AGREED_PAYMENTS) VALUES (1, '2018-03-15', 2, 1);
INSERT INTO mydb.BILL (BILL_PATIENT_ID, BILL_DATE, BILL_STATUS_ID, BILL_AGREED_PAYMENTS) VALUES (3, '2018-03-15', 2, 1);

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.TREATMENT_FEE
-- Test data for treatments fee
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.TREATMENT_FEE (FEE_TREATMENT_ID, FEE_AMOUNT, FEE_UPDATED, FEE_IS_CURRENT) VALUES (1, 50, '2018-02-02', 'Y');
INSERT INTO mydb.TREATMENT_FEE (FEE_TREATMENT_ID, FEE_AMOUNT, FEE_UPDATED, FEE_IS_CURRENT) VALUES (2, 30, '2018-02-02', 'Y');
INSERT INTO mydb.TREATMENT_FEE (FEE_TREATMENT_ID, FEE_AMOUNT, FEE_UPDATED, FEE_IS_CURRENT) VALUES (5, 40, '2018-02-02', 'Y');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.BILL_TREATMENT
-- Test data of treatments included in bills
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.BILL_TREATMENT (BTRM_BILL_NUMBER, BTRM_APP_TREATMENT_ID, BTRM_TREATMENT_FEE_ID) VALUES (1, 1, 3);
INSERT INTO mydb.BILL_TREATMENT (BTRM_BILL_NUMBER, BTRM_APP_TREATMENT_ID, BTRM_TREATMENT_FEE_ID) VALUES (2, 2, 1);
INSERT INTO mydb.BILL_TREATMENT (BTRM_BILL_NUMBER, BTRM_APP_TREATMENT_ID, BTRM_TREATMENT_FEE_ID) VALUES (3, 4, 1);

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.LATE_CANCELLATION_FEE
-- Test data for late cancellations fee
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.LATE_CANCELLATION_FEE (LCF_AMOUNT, LCF_UPDATED, LCF_IS_CURRENT) VALUES (10, '2018-02-02', 'Y');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.BILL_LATE_CANCELLATION
-- Test data for late cancellations included in bills
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.BILL_LATE_CANCELLATION (BLT_BILL_NUMBER, BLT_APPOINTMENT_ID, BLT_LATE_CANCEL_FEE_ID) VALUES (4, 3, 1);

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.PAYMENT_TYPE
-- This data consists of the possible payment types that a patient can make
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.PAYMENT_TYPE (PTY_TYPE, PTY_DESCRIPTION) VALUES ('CH', 'CHEQUE');
INSERT INTO mydb.PAYMENT_TYPE (PTY_TYPE, PTY_DESCRIPTION) VALUES ('CC', 'CREDIT CARD');
INSERT INTO mydb.PAYMENT_TYPE (PTY_TYPE, PTY_DESCRIPTION) VALUES ('CA', 'CASH');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.PAYMENT
-- test data for payments
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.PAYMENT (PAY_BILL_NUMBER, PAY_NUMBER, PAY_DATE, PAY_AMOUNT, PAY_TYPE) VALUES (1, 1, '2018-03-16', 40, 'CH');
INSERT INTO mydb.PAYMENT (PAY_BILL_NUMBER, PAY_NUMBER, PAY_DATE, PAY_AMOUNT, PAY_TYPE) VALUES (2, 1, '2018-03-19', 50, 'CA');

COMMIT;

-- -----------------------------------------------------
-- Data for table mydb.REFERRAL_TREATMENT
-- Test data for treatments indicated in a referral
-- -----------------------------------------------------
START TRANSACTION;
USE mydb;
INSERT INTO mydb.REFERRAL_TREATMENT (RTRM_REFERRAL_ID, RTRM_TREATMENT_ID, RTRM_COMMENTS) VALUES (1, 7, 'Patient began orthodontic treatment');
INSERT INTO mydb.REFERRAL_TREATMENT (RTRM_REFERRAL_ID, RTRM_TREATMENT_ID, RTRM_COMMENTS) VALUES (2, 7, NULL);

COMMIT;
