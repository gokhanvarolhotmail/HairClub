/****** Object:  UserDefinedFunction [ODS].[ConvertInput]    Script Date: 1/7/2022 4:05:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [ODS].[ConvertInput] (@MyValueIn [int]) RETURNS int
AS
BEGIN  
    DECLARE @MyValueOut int;  
    SET @MyValueOut = @MyValueIn +2 ;  
    RETURN(@MyValueOut);  
END
GO
