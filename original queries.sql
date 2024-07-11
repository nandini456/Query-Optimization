USE HospitalDB;
GO
SET STATISTICS IO,TIME ON;
-- QUERY 1: Calculate the median 
WITH MedianCalc AS (
    SELECT TreatmentAmount,
           NTILE(2) OVER (ORDER BY TreatmentAmount) AS Tile
    FROM Patients
),
MedianValue AS (
    SELECT AVG(TreatmentAmount) AS Median
    FROM MedianCalc
    WHERE Tile = 1
)
-- Step 2: Select patients with treatment amounts above the median
SELECT p.PatientID, p.PatientName, p.Disease, p.RecoveryRate, p.TreatmentAmount
FROM Patients p
WHERE p.TreatmentAmount > (SELECT Median FROM MedianValue)
Order By PatientName;

--QUERY 2
SELECT p1.PatientID, p1.PatientName, p1.Disease, p1.RecoveryRate, p1.TreatmentAmount
FROM Patients p1
INNER JOIN Patients p2 ON p1.Disease = p2.Disease
WHERE p1.TreatmentAmount = (SELECT MAX(p3.TreatmentAmount) FROM Patients p3 WHERE p3.Disease = p1.Disease)
ORDER BY p1.PatientName, p1.TreatmentAmount;

-- QUERY 3
WITH DetailedPatients AS (
    SELECT p.PatientID, p.PatientName, p.Disease, p.RecoveryRate, p.TreatmentAmount,
           (SELECT COUNT(*) FROM Patients p2 WHERE p2.Disease = p.Disease) AS PatientCount,
           (SELECT SUM(p3.TreatmentAmount) FROM Patients p3 WHERE p3.Disease = p.Disease) AS TotalTreatmentAmount
    FROM Patients p
)
SELECT dp.PatientID, dp.PatientName, dp.Disease, dp.RecoveryRate, dp.TreatmentAmount,
       dp.PatientCount, dp.TotalTreatmentAmount
FROM DetailedPatients dp
INNER JOIN Patients p ON dp.Disease = p.Disease
ORDER BY dp.TreatmentAmount DESC;

-- QUERY 4

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
)
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
JOIN
    TopDoctors TD ON D.DoctorID = TD.DoctorID
ORDER BY
    DS.TotalPatients DESC, D.DoctorID, P.PatientID;






-- Query 5

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
PatientAboveAvgRecovery AS (
    SELECT
        P.PatientID,
        P.PatientName,
        P.Disease,
        P.RecoveryRate,
        P.TreatmentAmount,
        P.DoctorID  -- Include DoctorID in the select list
    FROM
        Patients P
    JOIN (
        SELECT AVG(RecoveryRate) AS AvgRecoveryRate
        FROM Patients
    ) AS AvgData ON P.RecoveryRate > AvgData.AvgRecoveryRate
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
    PatientAboveAvgRecovery PAR ON DT.DoctorID = PAR.DoctorID  -- Join on DoctorID
ORDER BY
    DT.DoctorID, PAR.PatientID;
-- query 6
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
),
PatientDetails AS (
    SELECT
        P.PatientID,
        P.PatientName,
        P.Disease,
        P.RecoveryRate,
        P.TreatmentAmount,
        P.DoctorID
    FROM
        Patients P
)
SELECT
    DS.DoctorID,
    DS.DoctorName,
    DS.TotalPatients,
    DS.AvgRecoveryRate,
    DS.TotalTreatmentCost,
    PD.PatientID,
    PD.PatientName,
    PD.Disease,
    PD.RecoveryRate AS PatientRecoveryRate,
    PD.TreatmentAmount AS PatientTreatmentAmount
FROM
    DoctorStats DS
LEFT JOIN
    PatientDetails PD ON DS.DoctorID = PD.DoctorID
ORDER BY
    DS.TotalPatients DESC, DS.DoctorID, PD.PatientID;





