USE PatientEnrollment
GO

CREATE PROC Contacts.spGetEmailType
(
	@EmailtypeId INT = 0,
	@EmailType VARCHAR(250) = ''
)
AS
BEGIN
SET NOCOUNT ON
	
	SELECT CAST(EmailTypeId AS VARCHAR(250)) AS EmailTypeId, EmailTypeDescription 
	FROM Contacts.EmailTypes WITH(NOLOCK)

SET NOCOUNT OFF
END