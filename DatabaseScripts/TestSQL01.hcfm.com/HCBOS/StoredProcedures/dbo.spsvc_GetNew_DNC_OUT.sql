/* CreateDate: 10/08/2007 15:38:46.307 , ModifyDate: 01/25/2010 08:11:31.790 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:		spsvc_GetNew_DNC_OUT

VERSION:		v2.0

DESTINATION SERVER:	HCTESTSQL1\SQL2005

DESTINATION DATABASE: 	BOS

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		Howard Abelow

IMPLEMENTOR: 		Howard Abelow

DATE IMPLEMENTED: 	10/9/2007

LAST REVISION DATE: 	10/9/2007

------------------------------------------------------------------------
NOTES: 	Gest a query for insert into the DNC_OUT table with new records.
			This was originally inline from DTS written by S.Knight
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_GetNew_DNC_OUT

***********************************************************************/


CREATE PROCEDURE [dbo].[spsvc_GetNew_DNC_OUT] AS

--Used to get last activity date
--ISSALE - purchase EBR
--ISAPPTSHOW - contact EBR
--INCALL - contact EBR
--Insert only new records


 SELECT  staging.[Phone]
			,	MAX(Activity.[Date]) LastContactDate
			FROM [dnc_staging] staging
				INNER JOIN  [HCWH1\SQL2005].[Warehouse].[dbo].[Lead] Lead ON staging.[RecordID] = Lead.[RecordID]
				INNER JOIN [HCWH1\SQL2005].[Warehouse].[dbo].[Activity] Activity ON Lead.[RecordID] = Activity.[RecordID]
		WHERE (Activity.[act_code] = 'INCALL' OR Activity.[result_code] IN ('SHOWSALE', 'SHOWNOSALE'))
			AND staging.[Phone] NOT IN (SELECT [Phone] FROM [DNC_OUT])
		GROUP BY staging.[Phone]
		ORDER BY staging.[Phone]
GO
