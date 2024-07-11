-- Create the Hospital database
CREATE DATABASE HospitalDB;
GO

-- Switch to the HospitalDB database context
USE HospitalDB;
GO
-- Create Doctors table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(100),
    Gender CHAR(1) -- Assuming 'M' for Male, 'F' for Female
);
GO
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName NVARCHAR(100),
    Disease NVARCHAR(100),
    RecoveryRate DECIMAL(5,2),
    TreatmentAmount DECIMAL(10,2),
    DoctorID INT,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) -- Assuming you have a Doctors table
);
GO
-- Insert sample data into Doctors table
INSERT INTO Doctors (DoctorID, DoctorName, Gender)
VALUES
    (1, 'Dr. Smith', 'M'),
    (2, 'Dr. Johnson', 'F'),
	(3, 'Dr. Williams', 'M'),
    (4, 'Dr. Brown', 'F'),
    (5, 'Dr. Garcia', 'M'),
    (6, 'Dr. Martinez', 'F'),
	(7, 'Dr. Taylor', 'M'),
    (8, 'Dr. Thomas', 'F'),
    (9, 'Dr. Wilson', 'M'),
    (10, 'Dr. Walker', 'F');
GO
-- Insert sample data into the Patients table
 
    INSERT INTO Patients (PatientID, PatientName, Disease, RecoveryRate, TreatmentAmount, DoctorID)
VALUES 
    (1, 'John Doe', 'Flu', 85.50, 300.00, 1),
    (2, 'Jane Smith', 'COVID-19', 90.00, 1500.00, 2),
    (3, 'Emily Davis', 'Pneumonia', 75.00, 1200.00, 3),
    (4, 'Michael Brown', 'Diabetes', 60.00, 2500.00, 4),
    (5, 'Sarah Wilson', 'Hypertension', 70.00, 800.00, 5),
    (6, 'David Johnson', 'Asthma', 80.00, 600.00, 6),
    (7, 'Chris Martin', 'Tuberculosis', 50.00, 2000.00, 7),
    (8, 'Emma Thompson', 'Cancer', 40.00, 5000.00, 8),
    (9, 'Lucas White', 'Arthritis', 65.00, 700.00, 9),
    (10, 'Olivia Martinez', 'Migraine', 95.00, 200.00, 10),
    (11, 'Liam Garcia', 'Allergy', 90.50, 400.00, 1),
    (12, 'Ava Anderson', 'Bronchitis', 85.00, 900.00, 2),
    (13, 'Noah Lee', 'Chickenpox', 92.00, 150.00, 3),
    (14, 'Sophia Harris', 'Epilepsy', 70.50, 1800.00, 4),
    (15, 'Mason Clark', 'Heart Disease', 55.00, 3500.00, 5),
    (16, 'Isabella Lewis', 'Kidney Disease', 60.50, 3000.00, 6),
    (17, 'Ethan Walker', 'Liver Disease', 65.50, 2700.00, 7),
    (18, 'Mia Young', 'Malaria', 75.50, 1000.00, 8),
    (19, 'James King', 'Measles', 80.50, 200.00, 9),
    (20, 'Amelia Scott', 'Meningitis', 50.50, 4000.00, 10),
    (21, 'Alexander Green', 'Obesity', 60.00, 1000.00, 1),
    (22, 'Charlotte Baker', 'Osteoporosis', 55.50, 1400.00, 2),
    (23, 'Daniel Hall', 'Parkinson', 45.00, 5000.00, 3),
    (24, 'Grace Rivera', 'Psoriasis', 85.50, 600.00, 4),
    (25, 'Elijah Carter', 'Scoliosis', 70.00, 1300.00, 5),
    (26, 'Avery Roberts', 'Stroke', 50.00, 3500.00, 6),
    (27, 'Benjamin Turner', 'Thyroid Disorder', 75.00, 900.00, 7),
    (28, 'Ella Phillips', 'Ulcer', 90.00, 700.00, 8),
    (29, 'Lucas Parker', 'Urinary Tract Infection', 85.00, 400.00, 9),
    (30, 'Harper Evans', 'Varicose Veins', 80.00, 300.00, 10),
    (31, 'Matthew Collins', 'Vertigo', 90.50, 200.00, 1),
    (32, 'Sofia Edwards', 'Vitiligo', 85.00, 500.00, 2),
    (33, 'Logan Stewart', 'Yeast Infection', 95.00, 150.00, 3),
    (34, 'Abigail Sanchez', 'Zika Virus', 60.00, 3000.00, 4),
    (35, 'Jacob Morris', 'Acne', 85.00, 250.00, 5),
    (36, 'Madison Rogers', 'Anemia', 70.00, 1000.00, 6),
    (37, 'Henry Reed', 'Appendicitis', 80.00, 1200.00, 7),
    (38, 'Emily Cook', 'Astigmatism', 75.00, 300.00, 8),
    (39, 'Jackson Morgan', 'Autism', 55.00, 4000.00, 9),
    (40, 'Scarlett Bell', 'Celiac Disease', 85.50, 700.00, 10),
    (41, 'Aiden Murphy', 'Cerebral Palsy', 60.00, 5000.00, 1),
    (42, 'Evelyn Bailey', 'Cholera', 95.00, 100.00, 2),
    (43, 'Gabriel Rivera', 'Crohn Disease', 50.00, 3500.00, 3),
    (44, 'Victoria Cooper', 'Cystic Fibrosis', 45.00, 4500.00, 4),
    (45, 'Sebastian Richardson', 'Dengue', 90.00, 500.00, 5),
    (46, 'Addison Cox', 'Down Syndrome', 50.00, 3000.00, 6),
    (47, 'Caleb Howard', 'Eczema', 85.00, 200.00, 7),
    (48, 'Aubrey Ward', 'Fibromyalgia', 60.00, 2500.00, 8),
    (49, 'William Torres', 'Glaucoma', 65.00, 900.00, 9),
    (50, 'Mia Peterson', 'Gout', 80.00, 400.00, 10);

GO
