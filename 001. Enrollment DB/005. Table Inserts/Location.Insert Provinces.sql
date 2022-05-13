USE PatientEnrollment
GO
DECLARE @DefaultDate DATETIME = GETDATE()

INSERT INTO Location.Provinces(ProvinceName, CountryIDFK, IsActive, UpdateDate)
VALUES('Eastern Cape', 1, 0, @DefaultDate ),
('Free State', 1, 0, @DefaultDate ),
('Gauteng', 1, 0, @DefaultDate ),
('KwaZulu Natal', 1, 0, @DefaultDate ),
('Limpopo', 1, 0, @DefaultDate ),
('Mpumalanga', 1, 0, @DefaultDate ),
('Northern Cape', 1, 0, @DefaultDate ),
('North West', 1, 0, @DefaultDate ),
('Western Cape', 1, 0, @DefaultDate )
