USE HealthcareForm
GO

CREATE PROC Profile.spGetGender
(
	@GenderId INT = 0,
	@GenderDescription VARCHAR(250) = ''
)
AS
BEGIN

	SET NOCOUNT ON
	
		SELECT CAST(GenderId AS VARCHAR(250)) AS GenderId, GenderDescription 
		FROM Profile.Gender WITH(NOLOCK)
	
	SET NOCOUNT OFF

END