USE [PatientEnrollment]
GO

/****** Object:  StoredProcedure [Location].[spGetCountries]    Script Date: 13-Feb-22 07:44:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [Location].[spGetCountries]
(
	@CountryId INT = 0,
	@CountryName VARCHAR(250) = ''
)
AS
BEGIN

SET NOCOUNT ON

	SELECT 
		CAST(CountryId AS VARCHAR(250)) AS CountryId, 
		CountryName 
	FROM Location.Countries 

SET NOCOUNT OFF

END
GO


