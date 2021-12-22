/***********************************************************************
PROCEDURE:
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		01/04/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC SpApp_LDAPListCentersFromUserName 'aptak'
***********************************************************************/
CREATE PROCEDURE SpApp_LDAPListCentersFromUserName
(
	@User VARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	ID INT
,	Description VARCHAR(255)
)


INSERT  INTO #Centers
        EXEC selADCentersFromUserName @User


SELECT  C.ID
,       C.Description
FROM    #Centers C
ORDER BY C.ID


END
