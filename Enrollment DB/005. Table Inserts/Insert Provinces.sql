USE PatientEnrollment
GO

INSERT INTO Location.Provinces(ProvinceName, CountryIDFK, IsActive, UpdateDate)
VALUES('Eastern Cape', 207, 1,GETDATE()),
	  ('Free State', 207, 1,GETDATE()),
	  ('Gauteng', 207, 1,GETDATE()),
	  ('KwaZulu-Natal', 1,207, GETDATE()),
	  ('Limpopo', 207, 1,GETDATE()),
	  ('Mpumalanga', 207, 1,GETDATE()),
	  ('Northern Cape', 207, 1,GETDATE()),
	  ('North West', 207, 1,GETDATE()),
	  ('Western Cape', 207, 1,GETDATE())