USE PatientEnrollment
GO

CREATE PROC Location.spGetProvinces
(
	@ProvinceId INT = '',
	@ProvinceName VARCHAR(250) = ''
)
AS
BEGIN
SET NOCOUNT ON
	
	SELECT CAST(ProvinceId AS VARCHAR(250)) AS ProvinceId , ProvinceName
	FROM  Location.Provinces WITH (NOLOCK)

SET NOCOUNT OFF
END