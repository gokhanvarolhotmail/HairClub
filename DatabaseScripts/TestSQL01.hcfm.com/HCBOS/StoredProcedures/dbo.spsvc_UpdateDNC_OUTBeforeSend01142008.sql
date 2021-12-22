/* CreateDate: 01/14/2008 16:47:19.633 , ModifyDate: 01/25/2010 08:11:31.807 */
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


Create    PROCEDURE [dbo].[spsvc_UpdateDNC_OUTBeforeSend01142008] AS

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
			,	MAX(Activity.[Date]) LastContactDate
			,	NULL AS LastSaleDate
			FROM [dnc_staging] staging
				INNER JOIN  [HCWH1\SQL2005].[Warehouse].[dbo].[Lead] Lead ON staging.[RecordID] = Lead.[RecordID]
				INNER JOIN [HCWH1\SQL2005].[Warehouse].[dbo].[Activity] Activity ON Lead.[RecordID] = Activity.[RecordID]
		WHERE (Activity.[act_code] = 'INCALL' OR Activity.[result_code] IN ('SHOWSALE', 'SHOWNOSALE'))
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
