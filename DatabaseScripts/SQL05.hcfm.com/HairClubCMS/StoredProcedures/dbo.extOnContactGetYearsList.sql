/* CreateDate: 12/11/2012 14:57:18.843 , ModifyDate: 12/11/2012 14:57:18.843 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetYearsList

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetYearsList

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetYearsList
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetYearsList]
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @DateNow int
	DECLARE @x int

	SET @DateNow = DATEPART(yy,GETDATE())
	SET @x = 0

	CREATE TABLE #tmp
	  (
	   YearValue int
	  ,YearName varchar(20)
	  )

    INSERT intO #tmp (YearValue, YearName)
	VALUES (0, 'Year')

	WHILE @x < 101
	  BEGIN
		INSERT  intO #tmp (YearValue, YearName)
		VALUES  (@DateNow, @DateNow)
		SELECT  @DateNow = @DateNow - 1
		SELECT  @x = @x + 1
	  END

	SELECT * FROM #tmp
END
GO
