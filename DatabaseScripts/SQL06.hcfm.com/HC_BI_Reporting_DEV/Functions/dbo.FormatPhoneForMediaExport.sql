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

create   FUNCTION [dbo].[FormatPhoneForMediaExport] (@PhoneNumber VARCHAR(20))
	RETURNS VARCHAR(20) AS
BEGIN
	SET @PhoneNumber = REPLACE(@PhoneNumber, 'Unassigned', ' ')
	SET @PhoneNumber = REPLACE(@PhoneNumber, '(', ' ')
	SET @PhoneNumber = REPLACE(@PhoneNumber, ')', ' ')
	SET @PhoneNumber = REPLACE(@PhoneNumber, '-', ' ')
	SET @PhoneNumber = REPLACE(@PhoneNumber, '  ', ' ')

	RETURN(@PhoneNumber)
END
