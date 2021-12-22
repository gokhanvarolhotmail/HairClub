/* CreateDate: 09/22/2008 15:07:29.093 , ModifyDate: 09/22/2008 15:07:29.093 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetYearsList
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/29/2008
-- Date Implemented:		7/29/2008
-- Date Last Modified:		7/29/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	BOS
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_GetYearsList
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetYearsList]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DateNow INT
	DECLARE @x INT

	SET @DateNow = DATEPART(yy,GetDate())
	SET @x = 0

	CREATE TABLE #tmp
	  (
	   YearValue INT
	  ,YearName VARCHAR(20)
	  )

    INSERT  INTO #tmp (YearValue, YearName)
	VALUES  (0, 'Year')

	WHILE @x < 101
	  BEGIN
		INSERT  INTO #tmp (YearValue, YearName)
		VALUES  (@DateNow, @DateNow)
		SELECT  @DateNow = @DateNow - 1
		SELECT  @x = @x + 1
	  END

	SELECT * FROM #tmp
END
GO
