USE PatientEnrollment
GO
CREATE PROC Profile.spUpdatePatient
(
	@FirstName VARCHAR(250) = '',
	@LastName VARCHAR(250) = '',
	@ID_Number VARCHAR(250) = '',
	@DateOfBirth DATETIME,
	@GenderIDFK INT = 0,
	
	@PhoneNumber VARCHAR(250) = '',
	@Email VARCHAR(250) = '',
	@Line1 VARCHAR(250) = '',
	@Line2 VARCHAR(250) = '',
	@CityIDFK INT = 0,
	
	@ProvinceIDFK INT = 0,
	@CountryIDFK INT = 0,
	@MaritalStatusIDFK INT = 0,
	@MedicationList VARCHAR(MAX) = '',
	@EmergencyName VARCHAR(250) = '',
	
	@EmergencyLastName VARCHAR(250) = '',
	@EmergencyPhoneNumber varchar(250) = '',
	@Relationship VARCHAR(250) = '',
	@EmergancyDateOfBirth DATETIME,
	
	@Message VARCHAR(250) OUTPUT
)
AS
BEGIN
	
	DECLARE @DefaultDate DATETIME = GETDATE(),
			@IsActive BIT = 0


	IF EXISTS(SELECT ID_Number FROM Profile.Patient WHERE ID_Number = @ID_Number)
	BEGIN
		
		UPDATE Contacts.Phones SET PhoneNumber = @PhoneNumber, IsActive = @IsActive, UpdateDate = @DefaultDate
		WHERE 


		UPDATE Profile.Patient 
		SET FirstName = @FirstName,
		LastName = @LastName,
		DateOfBirth = @DateOfBirth,
		GenderIDFK = @GenderIDFK
		WHERE ID_Number = @ID_Number 

	END

END