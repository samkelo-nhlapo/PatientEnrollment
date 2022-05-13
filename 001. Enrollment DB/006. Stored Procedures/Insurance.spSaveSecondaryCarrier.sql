USE PatientEnrollment
GO

CREATE PROC Insurance.spSaveSecondaryCarrier
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

		IF NOT EXISTS(SELECT 1 FROM Profile.Patient AS PP WITH (NOLOCK) JOIN Insurance.SecondaryCarrier AS IP ON PP.PatientId = IP.SecondaryCarrierId WHERE SecondaryCarrierName = @Name)
		BEGIN

			/*Inserting into the phone number table*/
			INSERT INTO Insurance.CarrierPhoneNumber
			(
				CarrierPhoneNumber, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneNumber, @IsActive, @DefauleDate)
	
			INSERT INTO Insurance.SecondaryCarrier
			(
				SecondaryCarrierName, 
				CarrierPhoneNumberIDFK, 
				Secondary_PH_Name, 
				Secondary_PH_DateOfBirth, 
				Secondary_PH_Relationship, 
				Secondary_PH_GenderIDFK
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

			UPDATE Insurance.SecondaryCarrier 
			SET SecondaryCarrierName = @PolicyHolderName, 
				CarrierPhoneNumberIDFK = @PhoneNumberIDFK, 
				Secondary_PH_Name = @PolicyHolderName, 
				Secondary_PH_DateOfBirth = @PolicyHolderDateOfBirth, 
				Secondary_PH_Relationship = @PolicyHolderRelationship, 
				Secondary_PH_GenderIDFK = @PolicyHolderGenderIDFK
			WHERE SecondaryCarrierName = @Name

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