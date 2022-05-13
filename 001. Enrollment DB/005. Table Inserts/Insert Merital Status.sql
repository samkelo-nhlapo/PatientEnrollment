USE PatientEnrollment
GO

INSERT INTO Profile.MaritalStatus(MaritalStatusDescription, IsActive, UpdateDate)
VALUES('Single', 0, GETDATE()),
	  ('Married', 0, GETDATE()),
	  ('Widowed', 0, GETDATE()),
	  ('Devorced', 0, GETDATE()),
	  ('Separated ', 0, GETDATE())