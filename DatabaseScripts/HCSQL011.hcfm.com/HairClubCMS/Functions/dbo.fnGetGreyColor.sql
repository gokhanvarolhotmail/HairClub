/* CreateDate: 05/23/2014 09:45:40.863 , ModifyDate: 05/23/2014 09:45:40.863 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetGreyColor]
(
	@HairSystemHairColorDescriptionShort nvarchar(10)
)
RETURNS NVARCHAR(10)
AS
BEGIN

    DECLARE @GreyColor NVARCHAR(10)


	SELECT @GreyColor = CASE WHEN @HairSystemHairColorDescriptionShort IS NULL THEN ''
							 WHEN @HairSystemHairColorDescriptionShort like '1%' THEN '60S'
							 WHEN @HairSystemHairColorDescriptionShort like '2%' THEN '60S'
							 WHEN @HairSystemHairColorDescriptionShort like '3%' THEN '60S'
							 WHEN @HairSystemHairColorDescriptionShort like '4%' THEN '60W'
							 WHEN @HairSystemHairColorDescriptionShort like '5%' THEN '60W'
							 WHEN @HairSystemHairColorDescriptionShort like '6%' THEN '60W'
							 ELSE '60G'
						END

    RETURN @GreyColor
END
GO
