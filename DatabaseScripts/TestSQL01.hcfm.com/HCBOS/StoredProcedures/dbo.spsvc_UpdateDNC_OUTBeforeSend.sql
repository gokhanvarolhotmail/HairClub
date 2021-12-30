/* CreateDate: 10/09/2007 10:12:57.327 , ModifyDate: 01/25/2010 08:11:31.790 */
GO
/***********************************************************************

PROCEDURE:		spsvc_UpdateDNC_OUT_BeforeSend

VERSION:		v2.0

DESTINATION SERVER:	HCTESTSQL1\SQL2005

DESTINATION DATABASE: 	BOS

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		Howard Abelow v1.5 and 2.0 - Originally Designed by Sean Knight

IMPLEMENTOR: 		Howard Abelow

DATE IMPLEMENTED: 	10/9/2007

LAST REVISION DATE: 	10/9/2007

------------------------------------------------------------------------
NOTES: 	Updates the DNC_OUT table with new records and updated phones.
	3/30/2009 MB - Added step to join to the oncd_activity_contact table before
		joining the oncd_activity table from the oncd_contact table.  The exclusion
		of that table resulted in a low number of matches for the DNC process
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_UpdateDNC_OUTBeforeSend

***********************************************************************/


CREATE    PROCEDURE [dbo].[spsvc_UpdateDNC_OUTBeforeSend] AS

declare @newContact TABLE
    (
      phone varchar(10),
      LastContactDate datetime,
      LastSaleDate datetime
    )

--Used to get last activity date
--ISSALE - purchase EBR
--ISAPPTSHOW - contact EBR
--INCALL - contact EBR


INSERT  INTO @newContact
SELECT  staging.[Phone]
,	MAX(Activity.[Due_Date]) LastContactDate
,	NULL AS LastSaleDate
FROM [dnc_staging] staging
	INNER JOIN  [HCM].dbo.[oncd_contact] Lead
		ON staging.[RecordID] = Lead.[contact_id]
	INNER JOIN [HCM].dbo.[oncd_activity_contact] CA
		ON Lead.[contact_id] = CA.[contact_id]
	INNER JOIN [HCM].dbo.[oncd_activity] Activity
		ON CA.activity_id = Activity.[activity_id]
WHERE (Activity.[action_code] = 'INCALL' OR Activity.[result_code] IN ('SHOWSALE', 'SHOWNOSALE'))
	AND staging.[Phone] IN (SELECT [Phone] FROM [DNC_OUT])
GROUP BY staging.[Phone]
ORDER BY staging.[Phone]



	--UPDATE records only
	UPDATE  d
	SET	[Phone] = c.phone
		,	[LastContactDate] = c.LastContactDate
		,	[LastSaleDate] = c.LastSaleDate
	FROM @newContact c
			INNER JOIN [DNC_OUT] d
				ON c.phone = d.[Phone]










select top 10 *
from [HCM].dbo.[oncd_activity_contact]
GO
