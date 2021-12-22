/* CreateDate: 05/05/2009 15:20:53.723 , ModifyDate: 08/03/2012 10:18:44.100 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

FUNCTION:				FormatPhoneForMediaExport

VERSION:				v1.1

DESTINATION SERVER:		HCSQL2

DESTINATION DATABASE: 	Infostore

RELATED APPLICATION:  	Media Export

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		10/14/08

LAST REVISION DATE: 	10/14/08

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns a formatted phone number string
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

SELECT [dbo].FormatPhoneForMediaExport ('(800)123-4567')
grant execute on FormatPhoneForMediaExport to iis
***********************************************************************/

CREATE   FUNCTION [dbo].[FormatPhoneForMediaExport] (@PhoneNumber VARCHAR(20))
	RETURNS VARCHAR(20) AS
BEGIN
	SET @PhoneNumber = REPLACE(@PhoneNumber, 'Unassigned', ' ')
	SET @PhoneNumber = REPLACE(@PhoneNumber, '(', ' ')
	SET @PhoneNumber = REPLACE(@PhoneNumber, ')', ' ')
	SET @PhoneNumber = REPLACE(@PhoneNumber, '-', ' ')
	SET @PhoneNumber = REPLACE(@PhoneNumber, '  ', ' ')

	RETURN(@PhoneNumber)
END
GO
