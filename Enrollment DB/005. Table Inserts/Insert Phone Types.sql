USE PatientEnrollment
GO

INSERT INTO Contacts.PhoneTypes(PhoneTypeDescription, UpdateDate)
VALUES('Primary Phone Number', GETDATE()),
	  ('Secondary Phone Number', GETDATE()),
	  ('Alternative Phone Number', GETDATE())