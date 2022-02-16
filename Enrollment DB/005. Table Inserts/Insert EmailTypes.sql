USE PatientEnrollment
GO

INSERT INTO Contacts.EmailTypes(EmailTypeDescription, UpdateDate)
VALUES('Primary Email', GETDATE()),
	  ('Secondary Email', GETDATE()),
	  ('Alternative Email', GETDATE())