USE PatientEnrollment
GO

INSERT INTO Profile.Gender(GenderDescription, IsActive, UpdateDate)
VALUES('Male', 1, GETDATE()),
('Female', 1, GETDATE()),
('Other', 1, GETDATE())