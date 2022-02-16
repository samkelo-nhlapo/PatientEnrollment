USE PatientEnrollment
GO

CREATE PROC Location.spGetCities
(
	@CityId INT,
	@CityName VARCHAR(250)
)
AS
BEGIN
SET NOCOUNT ON

	SELECT 
		CAST(CityId AS VARCHAR(250)) AS CityId, 
		CityName 
	FROM Location.Cities WITH(NOLOCK)

SET NOCOUNT OFF
END