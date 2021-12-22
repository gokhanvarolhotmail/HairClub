/* CreateDate: 01/14/2008 16:03:23.870 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_UpdateDNC_OUTBeforeSend

***********************************************************************/


CREATE    PROCEDURE [dbo].[spsvc_UpdateDNC_OUTBeforeSend-WILL TEST THIS AFTERWARDS] AS

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
				INNER JOIN  [HCM].dbo.[oncd_contact] Lead ON staging.[RecordID] = Lead.[contact_id]
				INNER JOIN [HCM].dbo.[oncd_activity] Activity ON Lead.[contact_id] = Activity.[activity_id]
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
GO
