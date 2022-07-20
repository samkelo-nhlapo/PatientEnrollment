USE HealthcareForm
GO

CREATE OR ALTER PROC Profile.spGetMaritalStatus
(
	@MaritalStatusId INT = 0,
	@MaritalStatusDescription VARCHAR(250) = ''
)
AS
BEGIN

SET NOCOUNT ON

	SELECT CAST(MaritalStatusId AS VARCHAR(250)) AS MaritalStatusId, MaritalStatusDescription 
	FROM Profile.MaritalStatus WITH(NOLOCK)

SET NOCOUNT OFF

END