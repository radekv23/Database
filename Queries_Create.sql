USE mydb ;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Table mydb.SPECIALIST
-- Table for the data of the Specialists that a patient can be referred to
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.SPECIALIST ;

CREATE  TABLE IF NOT EXISTS mydb.SPECIALIST (
  SPC_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  SPC_FIRST_NAME VARCHAR(45) NOT NULL COMMENT 'Dental Specialist first name' ,
  SPC_LAST_NAME VARCHAR(45) NOT NULL COMMENT 'Dental Specialist last name' ,
  SPC_CONTACT_NUMBER VARCHAR(20) NOT NULL COMMENT 'Contact number of the Specialist' ,
  PRIMARY KEY (SPC_ID) )
ENGINE = InnoDB
COMMENT = 'Dental specialists,that a patient can be referred to';


-- -----------------------------------------------------
-- Table mydb.PATIENT
-- Table with the data of the Patients of the dental practice
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.PATIENT ;

CREATE  TABLE IF NOT EXISTS mydb.PATIENT (
  PAT_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  PAT_FIRST_NAME VARCHAR(45) NOT NULL COMMENT 'First name of the patient' ,
  PAT_LAST_NAME VARCHAR(45) NOT NULL COMMENT 'Last name of the patient' ,
  PAT_BIRTHDATE DATE NOT NULL COMMENT 'Birthdate of the patient' ,
  PAT_ADDRESS VARCHAR(200) NOT NULL COMMENT 'Patient Address used to send Bills and Appointment reminders' ,
  PAT_EMAIL VARCHAR(45) NULL ,
  PAT_PHONE_NUMBER VARCHAR(20) NOT NULL ,
  PRIMARY KEY (PAT_ID) )
ENGINE = InnoDB
COMMENT = 'Table used to record Patient data';


-- -----------------------------------------------------
-- Table mydb.APPOINTMENT_STATUS
-- Table with the possible statuses that an appointment can have
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.APPOINTMENT_STATUS ;

CREATE  TABLE IF NOT EXISTS mydb.APPOINTMENT_STATUS (
  APST_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  APST_NAME VARCHAR(50) NOT NULL COMMENT 'Status name. Example: Late cancelled' ,
  APST_DESCRIPTION VARCHAR(100) NOT NULL COMMENT 'Status description. Example: When an appointment is cancelled late, it is charged a late cancellation fee and can be billed' ,
  PRIMARY KEY (APST_ID) )
ENGINE = InnoDB
COMMENT = 'Table of the possible statuses that an appointment can have';


-- -----------------------------------------------------
-- Table mydb.APPOINTMENT
-- Table for the appointments of the patients at the dental practice
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.APPOINTMENT ;

CREATE  TABLE IF NOT EXISTS mydb.APPOINTMENT (
  APP_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  APP_PATIENT_ID INT NOT NULL COMMENT 'ID of the Patient to whom the Appointment belongs' ,
  APP_DATE DATE NOT NULL COMMENT 'Date of the appointment' ,
  APP_STATUS_ID INT NOT NULL COMMENT 'Current status' ,
  PRIMARY KEY (APP_ID) ,
  CONSTRAINT APPOINTMENT_FK1
    FOREIGN KEY (APP_PATIENT_ID )
    REFERENCES mydb.PATIENT (PAT_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT APPOINTMENT_FK2
    FOREIGN KEY (APP_STATUS_ID )
    REFERENCES mydb.APPOINTMENT_STATUS (APST_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
COMMENT = 'Table of Appointments';

CREATE INDEX APPOINMENT_IDX1 ON mydb.APPOINTMENT (APP_PATIENT_ID ASC) ;

CREATE INDEX APPOINMENT_IDX2 ON mydb.APPOINTMENT (APP_STATUS_ID ASC) ;


-- -----------------------------------------------------
-- Table mydb.TREATMENT
-- Table for the Dental Treatments
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.TREATMENT ;

CREATE  TABLE IF NOT EXISTS mydb.TREATMENT (
  TRM_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  TRM_NAME VARCHAR(100) NOT NULL COMMENT 'Name of the treatment' ,
  TRM_DESCRIPTION VARCHAR(500) NOT NULL COMMENT 'Detailed description of the treatment' ,
  PRIMARY KEY (TRM_ID) )
ENGINE = InnoDB
COMMENT = 'Table of Dental Treatments';


-- -----------------------------------------------------
-- Table mydb.TREATMENT_STATUS
-- Table of the possible statuses that a Treatment can have
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.TREATMENT_STATUS ;

CREATE  TABLE IF NOT EXISTS mydb.TREATMENT_STATUS (
  TRST_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  TRST_NAME VARCHAR(50) NOT NULL COMMENT 'Name of the Status. Example: Performed' ,
  TRST_DESCRIPTION VARCHAR(100) NOT NULL COMMENT 'Description of the Status. Example: When the Patient receives Treatment, it has status Performed and can be added to a bill.' ,
  PRIMARY KEY (TRST_ID) )
ENGINE = InnoDB
COMMENT = 'Table of the possible statusses that a Treatment can have';


-- -----------------------------------------------------
-- Table mydb.APPOINTMENT_TREATMENT
-- Table of Treatments to be performed on a Patient during an Appointment
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.APPOINTMENT_TREATMENT ;

CREATE  TABLE IF NOT EXISTS mydb.APPOINTMENT_TREATMENT (
  ATRM_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  ATRM_APPOINTMENT_ID INT NOT NULL COMMENT 'Appointment at which the treatment was scheduled' ,
  ATRM_TREATMENT_ID INT NOT NULL COMMENT 'ID of the Treatment' ,
  ATRM_STATUS_ID INT NOT NULL COMMENT 'Id of the current Treatment Status. Example: Scheduled, Performed, Billed, Paid' ,
  ATRM_COMMENTS VARCHAR(1000) NULL COMMENT 'Comments about the treatment' ,
  PRIMARY KEY (ATRM_ID) ,
  CONSTRAINT APPOINTMENT_TREATMENT_FK1
    FOREIGN KEY (ATRM_TREATMENT_ID )
    REFERENCES mydb.TREATMENT (TRM_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT APPOINTMENT_TREATMENT_FK2
    FOREIGN KEY (ATRM_STATUS_ID )
    REFERENCES mydb.TREATMENT_STATUS (TRST_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT APPOINTMENT_TREATMENT_FK3
    FOREIGN KEY (ATRM_APPOINTMENT_ID )
    REFERENCES mydb.APPOINTMENT (APP_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
COMMENT = 'Table of Treatments to be performed on a Patient during an Appointment';

CREATE INDEX APPOINTMENT_TREATMENT_IDX1 ON mydb.APPOINTMENT_TREATMENT (ATRM_TREATMENT_ID ASC) ;

CREATE INDEX APPOINTMENT_TREATMENT_IDX3 ON mydb.APPOINTMENT_TREATMENT (ATRM_STATUS_ID ASC) ;

CREATE INDEX APPOINTMENT_TREATMENT_IDX4 ON mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID ASC) ;

CREATE UNIQUE INDEX APPOINTMENT_TREATMENT_UK1 ON mydb.APPOINTMENT_TREATMENT (ATRM_APPOINTMENT_ID ASC, ATRM_TREATMENT_ID ASC) ;


-- -----------------------------------------------------
-- Table mydb.REFERRAL
-- Table of Patient Referrals to Specialists for one or more treatments
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.REFERRAL ;

CREATE  TABLE IF NOT EXISTS mydb.REFERRAL (
  REF_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  REF_PATIENT_ID INT NOT NULL COMMENT 'ID of the Patient to whom the Referral is sent' ,
  REF_SPECIALIST_ID INT NOT NULL COMMENT 'ID of the Specialist to whom the patient was referred' ,
  REF_DATE DATE NOT NULL COMMENT 'Date of the referral' ,
  PRIMARY KEY (REF_ID) ,
  CONSTRAINT REFERRAL_FK1
    FOREIGN KEY (REF_SPECIALIST_ID )
    REFERENCES mydb.SPECIALIST (SPC_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT REFERRAL_FK2
    FOREIGN KEY (REF_PATIENT_ID )
    REFERENCES mydb.PATIENT (PAT_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
COMMENT = 'Patient Referrals to Specialists for one or more treatments';

CREATE INDEX REFERRAL_IDX1 ON mydb.REFERRAL (REF_SPECIALIST_ID ASC) ;

CREATE INDEX REFERRAL_IDX2 ON mydb.REFERRAL (REF_PATIENT_ID ASC) ;


-- -----------------------------------------------------
-- Table mydb.BILL_STATUS
-- Table of the possible statuses that a bill can have
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.BILL_STATUS ;

CREATE  TABLE IF NOT EXISTS mydb.BILL_STATUS (
  BST_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  BST_NAME VARCHAR(50) NOT NULL COMMENT 'Name of the Status. Example: Paid' ,
  BST_DESCRIPTION VARCHAR(100) NOT NULL COMMENT 'Description of the Status. Example: When a Bill is Paid, all the items (Treatments and/or Late Cancelled Appointments) are marked as Paid' ,
  PRIMARY KEY (BST_ID) )
ENGINE = InnoDB
COMMENT = 'Table of the possible statuses that a bill can have';


-- -----------------------------------------------------
-- Table mydb.BILL
-- Table of bills emitted to patients. Items in an Bill can be performed Treatments (unpaid) and Late Cancellations
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.BILL ;

CREATE  TABLE IF NOT EXISTS mydb.BILL (
  BILL_NUMBER INT NOT NULL AUTO_INCREMENT COMMENT 'Number identifying the bill' ,
  BILL_PATIENT_ID INT NOT NULL COMMENT 'ID of the Patient to whom the Bill belongs' ,
  BILL_DATE DATE NOT NULL COMMENT 'Billing Issue Date' ,
  BILL_STATUS_ID INT NOT NULL COMMENT 'Current Status of the Bill. When an Billing is Paid in full (and becomes Paid status), all Treatments and/or Late Cancellations associated with it also become Paid status.' ,
  BILL_AGREED_PAYMENTS INT NOT NULL DEFAULT 1 COMMENT 'Number of agreed Payments for the Bill.  By default each Billing has a single Payment, but the Patient may agree to make a certain number of Payments for one Bill' ,
  PRIMARY KEY (BILL_NUMBER) ,
  CONSTRAINT BILL_FK1
    FOREIGN KEY (BILL_PATIENT_ID )
    REFERENCES mydb.PATIENT (PAT_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT BILL_FK2
    FOREIGN KEY (BILL_STATUS_ID )
    REFERENCES mydb.BILL_STATUS (BST_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
COMMENT = 'Table of bills emitted to patients. Items in an Bill can be performed Treatments (unpaid) and Late Cancellations';

CREATE INDEX BILL_IDX1 ON mydb.BILL (BILL_PATIENT_ID ASC) ;

CREATE INDEX BILL_IDX2 ON mydb.BILL (BILL_STATUS_ID ASC) ;


-- -----------------------------------------------------
-- Table mydb.TREATMENT_FEE
-- Table of Treatment Fees. Each Treatment has its own Fee and these can be updated as needed. 
-- At the moment of issuing an Billing, the Current Fee for the Treatment performed is taken.
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.TREATMENT_FEE ;

CREATE  TABLE IF NOT EXISTS mydb.TREATMENT_FEE (
  FEE_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  FEE_TREATMENT_ID INT NOT NULL COMMENT 'ID of the Treatment to which this fee belongs' ,
  FEE_AMOUNT FLOAT NOT NULL COMMENT 'Amount to be charged for this treatment' ,
  FEE_UPDATED DATE NOT NULL COMMENT 'Date of update of the fee for this treatment' ,
  FEE_IS_CURRENT CHAR(1) NOT NULL DEFAULT TRUE COMMENT 'Indicates if this is the current fee. Y= Yes, N= No. If value is Y, this fee will be taken at the time of billing.' ,
  PRIMARY KEY (FEE_ID) ,
  CONSTRAINT TREATMENT_FEE_FK1
    FOREIGN KEY (FEE_TREATMENT_ID )
    REFERENCES mydb.TREATMENT (TRM_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
COMMENT = 'Table of Treatment Fees. Each Treatment has its own Fee and these can be updated as needed. At the moment of issuing an Billing, the Current Fee for the Treatment performed is taken.';

CREATE INDEX TREATMENT_FEE_IDX1 ON mydb.TREATMENT_FEE (FEE_TREATMENT_ID ASC) ;


-- -----------------------------------------------------
-- Table mydb.BILL_TREATMENT
-- Table of Treatments included in a Billing. Only when a Treatment has the status Performed it can be billed
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.BILL_TREATMENT ;

CREATE  TABLE IF NOT EXISTS mydb.BILL_TREATMENT (
  BTRM_BILL_NUMBER INT NOT NULL COMMENT 'Number of the bill to which this item belongs' ,
  BTRM_APP_TREATMENT_ID INT NOT NULL COMMENT 'ID of the Treatment charged on this bill' ,
  BTRM_TREATMENT_FEE_ID INT NOT NULL COMMENT 'ID of the current Treatment Fee at the time the Bill is issued' ,
  PRIMARY KEY (BTRM_BILL_NUMBER, BTRM_APP_TREATMENT_ID) ,
  CONSTRAINT BILL_TREATMENT_FK1
    FOREIGN KEY (BTRM_BILL_NUMBER )
    REFERENCES mydb.BILL (BILL_NUMBER )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT BILL_TREATMENT_FK2
    FOREIGN KEY (BTRM_APP_TREATMENT_ID )
    REFERENCES mydb.APPOINTMENT_TREATMENT (ATRM_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT BILL_TREATMENT_FK3
    FOREIGN KEY (BTRM_TREATMENT_FEE_ID )
    REFERENCES mydb.TREATMENT_FEE (FEE_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
COMMENT = 'Table of Treatments included in a Billing. Only when a Treatment has the status Performed it can be billed';

CREATE INDEX BILL_TREATMENT_IDX1 ON mydb.BILL_TREATMENT (BTRM_APP_TREATMENT_ID ASC) ;

CREATE INDEX BILL_TREATMENT_IDX2 ON mydb.BILL_TREATMENT (BTRM_TREATMENT_FEE_ID ASC) ;


-- -----------------------------------------------------
-- Table mydb.LATE_CANCELLATION_FEE
-- Late Cancellation Fee Table. Late Cancellations have a determined fee and with this table it can be updated as needed.
-- At the moment of issuing an Billing, the Current Fee for the Late Cancellations (if any) is taken.
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.LATE_CANCELLATION_FEE ;

CREATE  TABLE IF NOT EXISTS mydb.LATE_CANCELLATION_FEE (
  LCF_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  LCF_AMOUNT FLOAT NOT NULL COMMENT 'Amount to be charged for a Late Cancellation' ,
  LCF_UPDATED DATE NOT NULL COMMENT 'Date of update of the fee for a Late Cancellation' ,
  LCF_IS_CURRENT CHAR(1) NOT NULL DEFAULT TRUE COMMENT 'Indicates if this is the current fee. Y= Yes, N= No. If is Y, this fee will be taken at the time of billing.' ,
  PRIMARY KEY (LCF_ID) )
ENGINE = InnoDB
COMMENT = 'Late Cancellation Fee Table. Late Cancellations have a determined fee and it can be updated as needed.';


-- -----------------------------------------------------
-- Table mydb.BILL_LATE_CANCELLATION
-- Table of the billed Late Cancellations
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.BILL_LATE_CANCELLATION ;

CREATE  TABLE IF NOT EXISTS mydb.BILL_LATE_CANCELLATION (
  BLT_BILL_NUMBER INT NOT NULL COMMENT 'Number of the Bill on which the Late Cancellation is charged' ,
  BLT_APPOINTMENT_ID INT NOT NULL COMMENT 'Id of the Appointment that was late cancelled' ,
  BLT_LATE_CANCEL_FEE_ID INT NOT NULL COMMENT 'Current fee to be charged' ,
  PRIMARY KEY (BLT_BILL_NUMBER, BLT_APPOINTMENT_ID) ,
  CONSTRAINT BILL_LATE_CANCELLATION_FK1
    FOREIGN KEY (BLT_BILL_NUMBER )
    REFERENCES mydb.BILL (BILL_NUMBER )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT BILL_LATE_CANCELLATION_FK2
    FOREIGN KEY (BLT_APPOINTMENT_ID )
    REFERENCES mydb.APPOINTMENT (APP_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT BILL_LATE_CANCELLATION_FK3
    FOREIGN KEY (BLT_LATE_CANCEL_FEE_ID )
    REFERENCES mydb.LATE_CANCELLATION_FEE (LCF_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
COMMENT = 'Table of billed Late Cancellations';

CREATE INDEX BILL_LATE_CANCELLATION_IDX1 ON mydb.BILL_LATE_CANCELLATION (BLT_APPOINTMENT_ID ASC) ;

CREATE INDEX BILL_LATE_CANCELLATION_IDX2 ON mydb.BILL_LATE_CANCELLATION (BLT_LATE_CANCEL_FEE_ID ASC) ;


-- -----------------------------------------------------
-- Table mydb.PAYMENT_TYPE
-- Table of possible Types of Payment a Patient may make
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.PAYMENT_TYPE ;

CREATE  TABLE IF NOT EXISTS mydb.PAYMENT_TYPE (
  PTY_TYPE VARCHAR(2) NOT NULL COMMENT 'Type of Payment. Values:  CH= Cheque, CC= Credit Card, CA= Cash' ,
  PTY_DESCRIPTION VARCHAR(45) NOT NULL COMMENT 'Description of the Payment Type.' ,
  PRIMARY KEY (PTY_TYPE) )
ENGINE = InnoDB
COMMENT = 'Table of possible Types of Payment a Patient may make';


-- -----------------------------------------------------
-- Table mydb.PAYMENT
-- Table of Payments made by Patients. Each Payment is associated with a Bill. 
-- One bill may receive one or more Payments as agreed with the Patient. 
-- When the Payment of an Bill is completed, it becomes Paid status and all the Treatments and/or Late Cancellations associated with it also become Paid status
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.PAYMENT ;

CREATE  TABLE IF NOT EXISTS mydb.PAYMENT (
  PAY_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  PAY_BILL_NUMBER INT NOT NULL COMMENT 'Number of the Bill to which the Payment belongs' ,
  PAY_NUMBER INT NOT NULL COMMENT 'Payment number for the same Bill (within the agreed number). By default each Billing has a single Payment, but the Patient may agree to make a certain number of Payments for a Billing.' ,
  PAY_DATE DATE NOT NULL COMMENT 'Date on which Payment was made' ,
  PAY_AMOUNT FLOAT NOT NULL COMMENT 'Paid amount' ,
  PAY_TYPE VARCHAR(2) NOT NULL COMMENT 'Type of payment. It can be Cheque (CH), Credit Card (CC) or Cash (CA).' ,
  PRIMARY KEY (PAY_ID) ,
  CONSTRAINT PAYMENT_FK1
    FOREIGN KEY (PAY_BILL_NUMBER )
    REFERENCES mydb.BILL (BILL_NUMBER )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT PAYMENT_FK2
    FOREIGN KEY (PAY_TYPE )
    REFERENCES mydb.PAYMENT_TYPE (PTY_TYPE )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
COMMENT = 'Table of Payments made by Patients. Each Payment is associated with a Bill. One bill may receive one or more Payments as agreed with the Patient. When the Payment of an Bill is completed, it becomes Paid status and all the Treatments and/or Late Cancellations associated with it also become Paid status';

CREATE INDEX PAYMENT_IDX1 ON mydb.PAYMENT (PAY_BILL_NUMBER ASC) ;

CREATE INDEX PAYMENT_IDX2 ON mydb.PAYMENT (PAY_TYPE ASC) ;


-- -----------------------------------------------------
-- Table mydb.REFERRAL_TREATMENT
-- Table of Treatments associated with a Referral. 
-- Here are recorded the Treatments that the Dentist cannot provide and therefore refer to a Specialist
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.REFERRAL_TREATMENT ;

CREATE  TABLE IF NOT EXISTS mydb.REFERRAL_TREATMENT (
  RTRM_ID INT NOT NULL AUTO_INCREMENT COMMENT 'ID identifying each record in the table' ,
  RTRM_REFERRAL_ID INT NOT NULL COMMENT 'Id of the Referral to which the Treatment is associated' ,
  RTRM_TREATMENT_ID INT NOT NULL COMMENT 'Treatment ID associated with the Referral' ,
  RTRM_COMMENTS VARCHAR(1000) NULL COMMENT 'Comments or observations of the Specialist about the Treatment. It may contain the Specialist Report' ,
  PRIMARY KEY (RTRM_ID) ,
  CONSTRAINT REFERRAL_TREATMENT_FK1
    FOREIGN KEY (RTRM_REFERRAL_ID )
    REFERENCES mydb.REFERRAL (REF_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT REFERRAL_TREATMENT_FK2
    FOREIGN KEY (RTRM_TREATMENT_ID )
    REFERENCES mydb.TREATMENT (TRM_ID )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
COMMENT = 'Table of Treatments associated with a Referral. Here are recorded the Treatments that the Dentist cannot provide and therefore refer to a Specialist';

CREATE INDEX REFERRAL_TREATMENT_IDX1 ON mydb.REFERRAL_TREATMENT (RTRM_REFERRAL_ID ASC) ;

CREATE INDEX REFERRAL_TREATMENT_IDX2 ON mydb.REFERRAL_TREATMENT (RTRM_TREATMENT_ID ASC) ;

CREATE UNIQUE INDEX REFERRAL_TREATMENT_UK1 ON mydb.REFERRAL_TREATMENT (RTRM_REFERRAL_ID ASC, RTRM_TREATMENT_ID ASC) ;

USE mydb ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

