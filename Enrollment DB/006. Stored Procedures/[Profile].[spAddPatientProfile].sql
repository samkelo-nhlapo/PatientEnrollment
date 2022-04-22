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
	@PhoneTypeIDFK INT = 0,
	@Email VARCHAR(250) = '',
	@EmailTypeIDFK INT = 0,
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
	@EmergenceDateOfBirth DATETIME,
	
	@PrimaryCarrierName VARCHAR(250) = '',
	@PrimaryCarrierContactNumber VARCHAR(250) = '',
	@PPolicyHolderName VARCHAR(250) = '',
	@PPolicyHolderDateOfBirth DATETIME,
	@PPolicyHolderRelationship VARCHAR(250) = '',
	
	@SecondaryCarrierName VARCHAR(250) = '',
	@SecondarCarrierContactNumber VARCHAR(250) = '',
	@SPolicyHolderName VARCHAR(250) = '',
	@SPolicyHolderDateOfBirth DATETIME,
	@SPolicyHolderRelationship VARCHAR(250) = '',
	
	@SPolicyHolderGenderIDFK INT = 0,
	
	@Message VARCHAR(250) OUTPUT
)
AS
BEGIN
	
	DECLARE @IsActive BIT = 0,
			@DefaultDate DATETIME = GETDATE(),
			@PrimaryCarrierIDFK UNIQUEIDENTIFIER = NEWID(),
			@SecondaryCarrierIDFK UNIQUEIDENTIFIER = NEWID(),
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
				EmailTypeIDFK, 
				IsActive, 
				UpdateDate
			)
			VALUES(@EmailIDFK, @Email, @EmailTypeIDFK, @IsActive, @DefaultDate)

			--INSERT INTO PHONES TABLE
			INSERT INTO Contacts.Phones
			(
				PhoneId,
				PhoneNumber, 
				PhoneTypeIDFK, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneIDFK, @PhoneNumber, @PhoneTypeIDFK, @IsActive, @DefaultDate)

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
				Relationship, 
				DateOfBirth, 
				IsActive, 
				UpdateDate
			)
			VALUES(@EmergencyIDFK, @EmergencyName, @EmergencyLastName, @Relationship, @EmergenceDateOfBirth , @IsActive, @DefaultDate)

		
			INSERT INTO Insurance.PrimaryCarrier
			(
				PrimaryCarrierId,
				PrimaryCarrierName, 
				[PrimaryCarrierContactNumber], 
				Primary_PH_Name, 
				Primary_PH_DateOfBirth, 
				Primary_PH_Relationship
			)
			VALUES(@PrimaryCarrierIDFK, @PrimaryCarrierName, @PrimaryCarrierContactNumber, @PPolicyHolderName, @PPolicyHolderDateOfBirth, @PPolicyHolderRelationship)

		
			INSERT INTO Insurance.SecondaryCarrier
			(
				SecondaryCarrierId,
				SecondaryCarrierName, 
				[SecondarCarrierContactNumber], 
				Secondary_PH_Name, 
				Secondary_PH_DateOfBirth, 
				Secondary_PH_Relationship, 
				Secondary_PH_GenderIDFK
			)
			VALUES(@SecondaryCarrierIDFK, @SecondaryCarrierName, @SecondarCarrierContactNumber, @SPolicyHolderName, @SPolicyHolderDateOfBirth, @SPolicyHolderRelationship, @SPolicyHolderGenderIDFK )
			

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
				EmergencyIDFK, 
				PrimaryCarrier, 
				SecondaryCarrier
			)
			VALUES(@FirstName, @LastName, @ID_Number ,@DateOfBirth, @GenderIDFK, @MedicationList, @EmailIDFK, @PhoneIDFK, @AddressIDFK, @MaritalStatusIDFK, @EmergencyIDFK, @PrimaryCarrierIDFK, @SecondaryCarrierIDFK)

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
			SET @PhoneTypeIDFK = 0
			SET @Email = ''
			SET @EmailTypeIDFK = 0
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
			SET @EmergenceDateOfBirth  = @DefaultDate
			SET @PrimaryCarrierName = ''
			SET @PrimaryCarrierContactNumber = ''
			SET @PPolicyHolderName = ''
			SET @PPolicyHolderDateOfBirth = @DefaultDate
			SET @PPolicyHolderRelationship = ''
			SET @SecondaryCarrierName = ''
			SET @SecondarCarrierContactNumber = ''
			SET @SPolicyHolderName = ''
			SET @SPolicyHolderDateOfBirth = @DefaultDate
			SET @SPolicyHolderRelationship = ''
			SET @SPolicyHolderGenderIDFK = 0
			
			

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


