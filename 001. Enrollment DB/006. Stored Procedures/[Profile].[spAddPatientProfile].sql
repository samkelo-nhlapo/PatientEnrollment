USE [PatientEnrollment]
GO

/****** Object:  StoredProcedure [Profile].[spAddPatientProfile]    Script Date: 20-Apr-22 04:12:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE OR ALTER   PROC [Profile].[spAddPatientProfile]
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
	@Relationship VARCHAR(250) = '',
	@EmergencyPhoneNumber varchar(250) = '',
	
	@Message VARCHAR(250) OUTPUT
)
AS
BEGIN
	
	DECLARE @IsActive BIT = 0,
			@DefaultDate DATETIME = GETDATE(),
			@EmailIDFK UNIQUEIDENTIFIER = NEWID(),
			@PhoneIDFK UNIQUEIDENTIFIER = NEWID(),
			@AddressIDFK UNIQUEIDENTIFIER = NEWID(),
			@EmergencyIDFK UNIQUEIDENTIFIER = NEWID(),
			@UserName VARCHAR(200),
			@ErrorSchema VARCHAR(200),
			@ErrorProc VARCHAR(200),
			@ErrorNumber INT,
			@ErrorState INT,
			@ErrorSeverity INT,
			@ErrorLine INT,
			@ErrorMessage VARCHAR(200),
			@ErrorDateTime DATETIME

SET NOCOUNT ON
	
	/*Summary*/
	/*Insert all the details into the Patient table */

	/*Email is the main patient authantification */

	BEGIN TRY
	
	--BEGIN TRAN

		IF NOT EXISTS(SELECT 1 FROM Profile.Patient WHERE ID_Number = @ID_Number)
		BEGIN
			
			SET @IsActive = 1

			--INSERT INTO EMAILS TABLE 
			INSERT INTO Contacts.Emails
			(
				EmailId,
				Email, 
				IsActive, 
				UpdateDate
			)
			VALUES(@EmailIDFK, @Email, @IsActive, @DefaultDate)

			--INSERT INTO PHONES TABLE
			INSERT INTO Contacts.Phones
			(
				PhoneId,
				PhoneNumber, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneIDFK, @PhoneNumber, @IsActive, @DefaultDate)

			--INSERT INTO ADDRESS TABLE 
			INSERT INTO Location.Address
			(
				AddressId,
				Line1, 
				Line2, 
				CityIDFK
			)
			VALUES(@AddressIDFK, @Line1, @Line2, @CityIDFK) 

			INSERT INTO Contacts.EmergencyContacts
			(
				EmergencyId,
				FirstName, 
				LastName, 
				PhoneNumber,
				Relationship, 
				IsActive, 
				UpdateDate
			)
			VALUES(@EmergencyIDFK, @EmergencyName, @EmergencyLastName, @EmergencyPhoneNumber ,@Relationship , @IsActive, @DefaultDate)


			--INSERT PATIENT TABLE
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

			--COMMIT TRAN

		END ELSE 
		BEGIN
			
			--ROLLBACK TRAN

			SET @Message = 'Sorry User Email: "'+ @Email + '" Already exists. Please check Email and try again'

			SET	@FirstName  = ''
			SET @LastName = ''
			SET @ID_Number = ''
			SET @DateOfBirth = @DefaultDate
			SET @GenderIDFK = 0
			SET @PhoneNumber = ''
			SET @Email = ''
			SET @Line1 = ''
			SET @Line2 = ''
			SET @CityIDFK = 0
			SET @ProvinceIDFK = 0
			SET @CountryIDFK = 0
			SET @MaritalStatusIDFK = 0
			SET @MedicationList = ''
			SET @EmergencyName = ''
			SET @EmergencyLastName = ''
			SET @Relationship = ''


		END
	END TRY 
	BEGIN CATCH
		
		
		SET	@UserName = SUSER_SNAME()
		SET	@ErrorSchema = SCHEMA_NAME()
		SET @ErrorProc = ERROR_PROCEDURE()
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorState = ERROR_STATE()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorLine = ERROR_LINE()
		SET @ErrorMessage = ERROR_MESSAGE()
		SET @ErrorDateTime = GETDATE()

		EXEC [Auth].[Exception] @UserName,@ErrorSchema, @ErrorProc, @ErrorNumber, @ErrorState, @ErrorSeverity, @ErrorLine, @ErrorMessage, @ErrorDateTime

	END CATCH

SET NOCOUNT OFF
END
GO


