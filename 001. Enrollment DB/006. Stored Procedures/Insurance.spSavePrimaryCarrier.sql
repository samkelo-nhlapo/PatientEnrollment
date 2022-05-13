USE PatientEnrollment
GO

CREATE PROC Insurance.spSavePrimaryCarrier
(
	@Name VARCHAR(250),
	@PhoneNumber VARCHAR(250) = '',
	@PolicyHolderName VARCHAR(250),
	@PolicyHolderDateOfBirth DATETIME,
	@PolicyHolderRelationship VARCHAR(250),
	@PolicyHolderGenderIDFK INT,
	@Message VARCHAR(250) OUTPUT
)
AS
BEGIN
	
	DECLARE @PhoneNumberIDFK UNIQUEIDENTIFIER = NEWID(),
			@IsActive BIT = 0,
			@DefauleDate DATETIME = GETDATE(),
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
	
	BEGIN TRY

		IF NOT EXISTS(SELECT 1 FROM Profile.Patient AS PP WITH (NOLOCK) JOIN Insurance.PrimaryCarrier AS IP ON PP.PatientId = IP.PrimaryCarrierId WHERE PrimaryCarrierName = @Name)
		BEGIN

			/*Inserting into the phone number table*/
			INSERT INTO Insurance.CarrierPhoneNumber
			(
				CarrierPhoneNumber, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneNumber, @IsActive, @DefauleDate)
	
			INSERT INTO Insurance.PrimaryCarrier
			(
				PrimaryCarrierName, 
				PrimaryCarrierPhoneNumberIDFK, 
				Primary_PH_Name, 
				Primary_PH_DateOfBirth, 
				Primary_PH_Relationship, 
				Primary_PH_GenderIDFK
			)
			VALUES(@Name, @PhoneNumberIDFK, @PolicyHolderName, @PolicyHolderDateOfBirth, @PolicyHolderRelationship, @PolicyHolderGenderIDFK)
		
		END ELSE 
		BEGIN
			
			INSERT INTO Insurance.CarrierPhoneNumber
			(
				CarrierPhoneNumber, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneNumber, @IsActive, @DefauleDate)

			UPDATE Insurance.PrimaryCarrier 
			SET PrimaryCarrierName = @PolicyHolderName, 
				PrimaryCarrierPhoneNumberIDFK = @PhoneNumberIDFK, 
				Primary_PH_Name = @PolicyHolderName, 
				Primary_PH_DateOfBirth = @PolicyHolderDateOfBirth, 
				Primary_PH_Relationship = @PolicyHolderRelationship, 
				Primary_PH_GenderIDFK = @PolicyHolderGenderIDFK
			WHERE PrimaryCarrierName = @Name

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