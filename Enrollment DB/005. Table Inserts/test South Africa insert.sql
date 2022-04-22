USE PatientEnrollment
GO

INSERT INTO Location.Countries(CountryName, Alpha2Code, Alpha3Code, Numeric, IsActive, UpdateDate)
VALUES('South Africa', 'ZA', 'ZAF', 710, 0, GETDATE())