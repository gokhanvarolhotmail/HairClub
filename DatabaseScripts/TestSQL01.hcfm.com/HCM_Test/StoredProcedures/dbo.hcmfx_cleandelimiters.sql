/* CreateDate: 11/29/2006 09:53:47.893 , ModifyDate: 05/01/2010 14:48:12.150 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.hcmfx_cleandelimiters(@phone as varchar(20), @newphone varchar(10) output) AS

--DECLARATIONS
	DECLARE @phonelen as numeric
	DECLARE @char as char(1)
	DECLARE @cntr as int

--INITIALIZE LOCAL VARIABLES
	SELECT @phonelen = DATALENGTH(@phone)
	SELECT @cntr = 1
	SELECT @newphone = ''

WHILE @cntr <= @phonelen BEGIN


	SELECT @char = SUBSTRING(@phone,@cntr,1)

	IF @char LIKE '[0-9]' BEGIN
		SELECT @newphone = @newphone +  @char
	END
	SELECT @cntr = @cntr+1

END

RETURN
GO
