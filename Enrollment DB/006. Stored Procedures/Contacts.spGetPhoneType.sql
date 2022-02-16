USE PatientEnrollment
GO

CREATE PROC Contacts.spGetPhoneType
(
	@PhonetypeId INT = 0,
	@PhoneType VARCHAR(250) = ''
)
AS
BEGIN
SET NOCOUNT ON
	
	SELECT CAST(PhoneTypeId AS VARCHAR(250)) AS PhoneTypeId, PhoneTypeDescription
	FROM Contacts.PhoneTypes WITH(NOLOCK)

SET NOCOUNT OFF
END