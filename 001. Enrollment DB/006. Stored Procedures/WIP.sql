USE PatientEnrollment
GO

DECLARE @FirstName VARCHAR(250) = 'TEST5',
	@LastName VARCHAR(250) = 'TEST2',
	@ID_Number VARCHAR(250) = '005',
	@DateOfBirth DATETIME = GETDATE(),
	@GenderIDFK INT = 1,
	
	@PhoneNumber VARCHAR(250) = 'TEST4',
	@Email VARCHAR(250) = 'TEST3',
	@Line1 VARCHAR(250) = 'TEST4',
	@Line2 VARCHAR(250) = 'TEST4',
	@CityIDFK INT = 1,
	
	@ProvinceIDFK INT = 1,
	@CountryIDFK INT = 1,
	@MaritalStatusIDFK INT = 1,
	@MedicationList VARCHAR(MAX) = 'TEST2',
	@EmergencyName VARCHAR(250) = 'TEST2',
	
	@EmergencyLastName VARCHAR(250) = 'TEST2',
	@EmergencyPhoneNumber varchar(250) = 'TEST2',
	@Relationship VARCHAR(250) = 'TEST2',
	@EmergancyDateOfBirth DATETIME = GETDATE(),
	@IsActive BIT = 1,
	@DefaultDate DATETIME = GETDATE(),
	@EmailIDFK UNIQUEIDENTIFIER = NEWID(),
	@PhoneIDFK UNIQUEIDENTIFIER = NEWID(),
	@AddressIDFK UNIQUEIDENTIFIER = NEWID(),
	@EmergencyIDFK UNIQUEIDENTIFIER = NEWID()

	IF EXISTS(SELECT 1 FROM Profile.Patient WHERE ID_Number = @ID_Number)
	BEGIN

		IF NOT EXISTS(SELECT 1 FROM Contacts.Phones WHERE PhoneNumber = @PhoneNumber) 
		BEGIN

			INSERT INTO Contacts.Phones
			(
				PhoneId,
				PhoneNumber, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneIDFK, @PhoneNumber, @IsActive, @DefaultDate)

		END

		IF NOT EXISTS(SELECT 1 FROM Contacts.Emails WHERE Email = @Email)
		BEGIN 

			INSERT INTO Contacts.Emails
			(
				EmailId,
				Email, 
				IsActive, 
				UpdateDate
			)
			VALUES(@EmailIDFK, @Email, @IsActive, @DefaultDate)

		END

		IF NOT EXISTS(SELECT 1 FROM Location.Address WHERE Line1 = @Line1 AND Line2 = @Line2) 
		BEGIN

			INSERT INTO Location.Address
			(
				AddressId,
				Line1, 
				Line2, 
				CityIDFK
			)
			VALUES(@AddressIDFK, @Line1, @Line2, @CityIDFK) 

		END

		IF NOT EXISTS(SELECT 1 FROM Contacts.EmergencyContacts WHERE DateOfBirth = @EmergancyDateOfBirth AND FirstName = @EmergencyName AND LastName = @EmergencyLastName)
		BEGIN

			INSERT INTO Contacts.EmergencyContacts
			(
				EmergencyId,
				FirstName, 
				LastName, 
				PhoneNumber,
				Relationship, 
				DateOfBirth,
				IsActive, 
				UpdateDate
			)
			VALUES(@EmergencyIDFK, @EmergencyName, @EmergencyLastName, @EmergencyPhoneNumber ,@Relationship , @EmergancyDateOfBirth , @IsActive, @DefaultDate)

		END
			
		INSERT INTO Profile.Patient
			(
				FirstName, 
				LastName, 
				ID_Number,
				DateOfBirth, 
				GenderIDFK, 
				MedicationList, 
				EmailIDFK, 
				PhoneIDFK, 
				AddressIDFK, 
				MaritalStatusIDFK, 
				EmergencyIDFK
			)
		VALUES(@FirstName, @LastName, @ID_Number ,@DateOfBirth, @GenderIDFK, @MedicationList, @EmailIDFK, @PhoneIDFK, @AddressIDFK, @MaritalStatusIDFK, @EmergencyIDFK)
		

		
		--SELECT FirstName = @FirstName , LastName = @LastName , DateOfBirth = @DateOfBirth , GenderIDFK = @GenderIDFK , EmailIDFK = @EmailIDFK , PhoneIDFK = @PhoneIDFK , AddressIDFK = @AddressIDFK , MaritalStatusIDFK = @MaritalStatusIDFK , EmergencyIDFK = @EmergencyIDFK  FROM Profile.Patient WHERE ID_Number = @ID_Number

	END ELSE 
	BEGIN

		PRINT 'Sorry user does not exists'

	END
