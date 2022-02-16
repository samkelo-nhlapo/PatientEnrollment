USE [PatientEnrollment]
GO

/****** Object:  StoredProcedure [Contacts].[spAddPatientProfile]    Script Date: 13-Feb-22 07:04:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROC [Profile].[spAddPatientProfile]
(
	@FirstName VARCHAR(250) = '',
	@LastName VARCHAR(250) = '',
	@DateOfBirth DATETIME,
	@GenderDescription VARCHAR(250) = '',
	@PhoneNumber VARCHAR(250) = '',
	@PhoneType INT = 0,
	@Email VARCHAR(250) = '',
	@EmailType INT = 0,
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
	@RelationshipDateOfBirth DATETIME,
	@PrimaryCarrierName VARCHAR(250) = '',
	@FPolicyHolderPhoneNumber VARCHAR(250) = '',
	@FPolicyHolderName VARCHAR(250) = '',
	@FPolicyHolderDateOfBirth DATETIME,
	@FPolicyHolderRelationship VARCHAR(250) = '',
	@FPolicyHolderGenderIDFK INT = 0,
	@SecondaryCarrierName VARCHAR(250) = '',
	@SPolicyHolderPhoneNumber VARCHAR(250) = '',
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
			@GenderIDFK INT,
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
	
	BEGIN TRAN

		IF NOT EXISTS(SELECT 1 FROM Contacts.Emails WITH(NOLOCK) WHERE Email = @Email)
		BEGIN
			
			SET @IsActive = 1

			--INSERT INTO EMAILS TABLE 
			INSERT INTO Contacts.Emails
			(
				Email, 
				EmailTypeIDFK, 
				IsActive, 
				UpdateDate
			)
			VALUES(@Email, @EmailType, @IsActive, @DefaultDate)

			--INSERT INTO PHONES TABLE
			INSERT INTO Contacts.Phones
			(
				PhoneNumber, 
				PhoneTypeIDFK, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneNumber, @PhoneType, @IsActive, @DefaultDate)

			--INSERT INTO ADDRESS TABLE 
			INSERT INTO Location.Address
			(
				Line1, 
				Line2, 
				CityIDFK
			)
			VALUES(@Line1, @Line2, @CityIDFK)

			--INSERT INTO EMERGENCY CONTACTS TABLE
			INSERT INTO Contacts.EmergencyContacts
			(
				FirstName, 
				LastName, 
				Relationship, 
				DateOfBirth, 
				IsActive, 
				UpdateDate
			)
			VALUES(@EmergencyName, @EmergencyLastName, @Relationship, @RelationshipDateOfBirth, @IsActive, @DefaultDate)


			--INSERT INTO PRIMARY CARRIER TABLE 
			INSERT INTO Insurance.CarrierPhoneNumber
			(
				CarrierPhoneNumber, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneNumber, @IsActive, @DefaultDate)
		
			INSERT INTO Insurance.PrimaryCarrier
			(
				PrimaryCarrierName, 
				PrimaryCarrierPhoneNumberIDFK, 
				Primary_PH_Name, 
				Primary_PH_DateOfBirth, 
				Primary_PH_Relationship, 
				Primary_PH_GenderIDFK
			)
			VALUES(@PrimaryCarrierName, @FPolicyHolderPhoneNumber, @FPolicyHolderName, @FPolicyHolderDateOfBirth, @FPolicyHolderRelationship, @FPolicyHolderGenderIDFK)


			--INSERT INTO CARRIER TABLE
			INSERT INTO Insurance.CarrierPhoneNumber
			(
				CarrierPhoneNumber, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneNumber, @IsActive, @DefaultDate)
		
			INSERT INTO Insurance.SecondaryCarrier
			(
				SecondaryCarrierName, 
				CarrierPhoneNumberIDFK, 
				Secondary_PH_Name, 
				Secondary_PH_DateOfBirth, 
				Secondary_PH_Relationship, 
				Secondary_PH_GenderIDFK
			)
			VALUES(@SecondaryCarrierName, @SPolicyHolderPhoneNumber, @SPolicyHolderName, @SPolicyHolderDateOfBirth, @SPolicyHolderRelationship, @SPolicyHolderGenderIDFK )
			

			--INSERT PATIENT TABLE
			INSERT INTO Profile.Patient
			(
				FirstName, 
				LastName, 
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
			VALUES(@FirstName, @LastName, @DateOfBirth, @GenderIDFK, @MedicationList, @EmailIDFK, @PhoneIDFK, @AddressIDFK, @MaritalStatusIDFK, @EmergencyIDFK, @PrimaryCarrierIDFK, @SecondaryCarrierIDFK)

			COMMIT TRAN

		END ELSE 
		BEGIN
			
			ROLLBACK TRAN

			SET	@FirstName  = ''
			SET @LastName = ''
			SET @DateOfBirth = GETDATE()
			SET @GenderDescription = ''
			SET @PhoneNumber = ''
			SET @PhoneType = 0
			SET @Email = ''
			SET @EmailType = 0
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
			SET @RelationshipDateOfBirth = GETDATE()
			SET @PrimaryCarrierName = ''
			SET @FPolicyHolderPhoneNumber = ''
			SET @FPolicyHolderName = ''
			SET @FPolicyHolderDateOfBirth = GETDATE()
			SET @FPolicyHolderRelationship = ''
			SET @FPolicyHolderGenderIDFK = 0
			SET @SecondaryCarrierName = ''
			SET @SPolicyHolderPhoneNumber = ''
			SET @SPolicyHolderName = ''
			SET @SPolicyHolderDateOfBirth = GETDATE()
			SET @SPolicyHolderRelationship = ''
			SET @SPolicyHolderGenderIDFK = 0
			SET @Message = 'Sorry User email: '+ @Email + ' already exists'

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


