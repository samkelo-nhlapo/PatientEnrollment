USE [PatientEnrollment]
GO

/****** Object:  StoredProcedure [Location].[spInsertSouthAfrican_Cities]    Script Date: 03-Feb-22 09:24:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER   PROC [Location].[spInsertSouthAfrican_Cities]
(
	@CityName VARCHAR(250),
	@Province VARCHAR(250),
	@IsActive BIT,
	@UpdateDate DATETIME,
	@Message VARCHAR(250) OUTPUT
)
AS
BEGIN
	
	
		INSERT INTO Location.Cities
		(
			CityName, 
			ProvinceIDFK, 
			IsActive, 
			UpdateDate
		)
		VALUES(@CityName, (SELECT ProvinceId FROM Location.Provinces WHERE ProvinceName = @Province), @IsActive, @UpdateDate)
		
		SET @Message = ''
	
END
GO


