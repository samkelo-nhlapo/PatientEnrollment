USE PatientEnrollment
GO

CREATE OR ALTER PROC Contacts.spSaveUserContacts
(
	@Email VARCHAR(250) = '',
	@EmailTypeIDFK INT = 0,
	@PhoneNumber VARCHAR(15) = '',
	@PhoneTypeIDK INT = 0,
	@Messege VARCHAR(250) OUTPUT
)
AS
BEGIN

SET NOCOUNT ON

BEGIN TRY

	
	/*Declare variables*/	
	DECLARE @IsActive BIT = 0,
			@DefaultDate DATETIME = GETDATE(),
			@UserName VARCHAR(200),
			@ErrorSchema VARCHAR(200),
			@ErrorProc VARCHAR(200),
			@ErrorNumber INT,
			@ErrorState INT,
			@ErrorSeverity INT,
			@ErrorLine INT,
			@ErrorMessage VARCHAR(200),
			@ErrorDateTime DATETIME
	
	--Transaction 
	BEGIN TRAN InsertPatient WITH MARK N'Inserting a Patient'

		/*Checking if Email exists and adding both email and phone number*/
		IF NOT EXISTS( SELECT 1 FROM Contacts.Emails WITH(NOLOCK) WHERE Email = @Email )
		BEGIN

			SET @IsActive = 1
	
			INSERT INTO Contacts.Emails
			(
				Email, 
				EmailTypeIDFK, 
				IsActive, 
				UpdateDate
			)
			VALUES(@Email, @EmailTypeIDFK, @IsActive, @DefaultDate)
	
			INSERT INTO Contacts.Phones
			(
				PhoneNumber, 
				PhoneTypeIDFK, 
				IsActive, 
				UpdateDate
			)
			VALUES(@PhoneNumber, @PhoneTypeIDK, @IsActive, @DefaultDate)

			SET @Messege = ''
			
			--Transaction
			COMMIT TRAN InsertPatient

		END ELSE
		BEGIN
			
			ROLLBACK TRAN InsertPatient
	
			SET @Email = ''
			SET @EmailTypeIDFK = 0
			SET @PhoneNumber = ''
			SET @PhoneTypeIDK = 0
			SET @Messege = 'Sorry Email already exists please'
	
		END
END TRY
BEGIN CATCH

		ROLLBACK TRAN InsertPatient

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