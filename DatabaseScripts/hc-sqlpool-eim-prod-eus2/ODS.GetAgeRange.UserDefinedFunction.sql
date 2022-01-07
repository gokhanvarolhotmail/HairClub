/****** Object:  UserDefinedFunction [ODS].[GetAgeRange]    Script Date: 1/7/2022 4:05:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [ODS].[GetAgeRange] (@MyValueIn [int],@year [int]) RETURNS varchar(15)
AS
BEGIN  
    DECLARE @MyValueOut varchar(15);
	DECLARE @AgeRange int;
	SET @AgeRange = @year - @MyValueIn;
	SET @MyValueOut =
			CASE 
	  			 WHEN (@AgeRange >= 1 AND @AgeRange <= 17) THEN 'Under 18'
				 WHEN @AgeRange >= 18 AND @AgeRange <= 24 THEN '18 to 24'
				 WHEN @AgeRange >= 25 AND @AgeRange <= 34 THEN '25 to 34'
				 WHEN @AgeRange >= 35 AND @AgeRange <= 44 THEN '35 to 44'
				 WHEN @AgeRange >= 45 AND @AgeRange <= 54 THEN '45 to 54'
				 WHEN @AgeRange >= 55 AND @AgeRange <= 64 THEN '55 to 64'
				 WHEN @AgeRange >= 65 AND @AgeRange <= 120 THEN '65 +'
				 ELSE 'Uknown'
				 END;
    RETURN(@MyValueOut);  
END
GO
