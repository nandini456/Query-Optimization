USE HospitalDB;
GO
SET STATISTICS IO,TIME ON;
-- Optimized query 1
-- Step 1: Calculate the median directly in a CTE
WITH MedianCTE AS (
    SELECT 
        PatientID, 
        PatientName, 
        Disease, 
        RecoveryRate, 
        TreatmentAmount,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY TreatmentAmount) OVER () AS Median
    FROM Patients
)
-- Step 2: Select patients with treatment amounts above the median
SELECT 
    PatientID, 
    PatientName, 
    Disease, 
    RecoveryRate, 
    TreatmentAmount
FROM MedianCTE
WHERE TreatmentAmount > Median;

-- optimzed query 2
WITH MaxTreatmentCTE AS (
    SELECT
        PatientID,
        PatientName,
        Disease,
        RecoveryRate,
        TreatmentAmount,
        ROW_NUMBER() OVER (PARTITION BY Disease ORDER BY TreatmentAmount DESC) AS RowNum
    FROM Patients
)
SELECT
    PatientID,
    PatientName,
    Disease,
    RecoveryRate,
    TreatmentAmount
FROM MaxTreatmentCTE
WHERE RowNum = 1
ORDER BY PatientName, TreatmentAmount DESC;

-- query op 3
WITH DiseaseStats AS (
    SELECT
        p.Disease,
        COUNT(*) AS PatientCount,
        SUM(p.TreatmentAmount) AS TotalTreatmentAmount
    FROM Patients p
    GROUP BY p.Disease
),
DetailedPatients AS (
    SELECT
        p.PatientID,
        p.PatientName,
        p.Disease,
        p.RecoveryRate,
        p.TreatmentAmount,
        ds.PatientCount,
        ds.TotalTreatmentAmount
    FROM Patients p
    JOIN DiseaseStats ds ON p.Disease = ds.Disease
)
SELECT
    dp.PatientID,
    dp.PatientName,
    dp.Disease,
    dp.RecoveryRate,
    dp.TreatmentAmount,
    dp.PatientCount,
    dp.TotalTreatmentAmount
FROM DetailedPatients dp
ORDER BY dp.TreatmentAmount DESC;

-- query 4
WITH DoctorStats AS (
    SELECT
        D.DoctorID,
        D.DoctorName,
        COUNT(P.PatientID) AS TotalPatients,
        AVG(P.RecoveryRate) AS AvgRecoveryRate,
        SUM(P.TreatmentAmount) AS TotalTreatmentCost,
        ROW_NUMBER() OVER (PARTITION BY D.DoctorID ORDER BY COUNT(P.PatientID) DESC) AS RankByPatientCount
    FROM
        Doctors D
    LEFT JOIN
        Patients P ON D.DoctorID = P.DoctorID
    WHERE
        D.DoctorID % 2 = 0 -- Select only doctors with even DoctorID
    GROUP BY
        D.DoctorID, D.DoctorName
),
TopDoctors AS (
    SELECT
        DoctorID,
        DoctorName,
        TotalPatients,
        AvgRecoveryRate,
        TotalTreatmentCost,
        RankByPatientCount
    FROM
        DoctorStats
    WHERE
        RankByPatientCount <= 2 -- Select top 2 doctors by patient count
),
PatientDetails AS (
    SELECT
        P.PatientID,
        P.PatientName,
        P.Disease,
        P.RecoveryRate,
        P.TreatmentAmount,
        D.DoctorID,
        D.DoctorName,
        DS.TotalPatients,
        DS.AvgRecoveryRate,
        DS.TotalTreatmentCost
    FROM
        Patients P
    JOIN
        Doctors D ON P.DoctorID = D.DoctorID
    JOIN
        DoctorStats DS ON D.DoctorID = DS.DoctorID
)
SELECT
    PD.PatientID,
    PD.PatientName,
    PD.Disease,
    PD.RecoveryRate,
    PD.TreatmentAmount,
    PD.DoctorID,
    PD.DoctorName,
    PD.TotalPatients,
    PD.AvgRecoveryRate,
    PD.TotalTreatmentCost
FROM
    PatientDetails PD
WHERE
    PD.DoctorID IN (SELECT DoctorID FROM TopDoctors)
ORDER BY
    PD.TotalPatients DESC, PD.DoctorID, PD.PatientID;


-- query 5
WITH DoctorTreatmentTotals AS (
    SELECT
        D.DoctorID,
        D.DoctorName,
        SUM(P.TreatmentAmount) AS TotalTreatmentAmount
    FROM
        Doctors D
    JOIN
        Patients P ON D.DoctorID = P.DoctorID
    GROUP BY
        D.DoctorID, D.DoctorName
),
AvgRecoveryRate AS (
    SELECT AVG(RecoveryRate) AS AvgRecoveryRate
    FROM Patients
),
PatientAboveAvgRecovery AS (
    SELECT
        P.PatientID,
        P.PatientName,
        P.Disease,
        P.RecoveryRate,
        P.TreatmentAmount,
        P.DoctorID
    FROM
        Patients P
    JOIN AvgRecoveryRate AvgData ON P.RecoveryRate > AvgData.AvgRecoveryRate
)
SELECT
    DT.DoctorID,
    DT.DoctorName,
    DT.TotalTreatmentAmount,
    PAR.PatientID,
    PAR.PatientName,
    PAR.Disease,
    PAR.RecoveryRate,
    PAR.TreatmentAmount
FROM
    DoctorTreatmentTotals DT
JOIN
    PatientAboveAvgRecovery PAR ON DT.DoctorID = PAR.DoctorID
ORDER BY
    DT.DoctorID, PAR.PatientID;
-- optimized query 6
CREATE INDEX idx_DoctorID ON Patients(DoctorID);
CREATE INDEX idx_PatientID ON Patients(PatientID);

WITH DoctorStats AS (
    SELECT
        D.DoctorID,
        D.DoctorName,
        COUNT(P.PatientID) AS TotalPatients,
        AVG(P.RecoveryRate) AS AvgRecoveryRate,
        SUM(P.TreatmentAmount) AS TotalTreatmentCost,
        ROW_NUMBER() OVER (ORDER BY COUNT(P.PatientID) DESC) AS RankByPatientCount
    FROM
        Doctors D
    LEFT JOIN
        Patients P ON D.DoctorID = P.DoctorID
    GROUP BY
        D.DoctorID, D.DoctorName
)
SELECT
    DS.DoctorID,
    DS.DoctorName,
    DS.TotalPatients,
    DS.AvgRecoveryRate,
    DS.TotalTreatmentCost,
    P.PatientID,
    P.PatientName,
    P.Disease,
    P.RecoveryRate AS PatientRecoveryRate,
    P.TreatmentAmount AS PatientTreatmentAmount
FROM
    DoctorStats DS
LEFT JOIN
    Patients P ON DS.DoctorID = P.DoctorID
ORDER BY
    DS.TotalPatients DESC, DS.DoctorID, P.PatientID;
