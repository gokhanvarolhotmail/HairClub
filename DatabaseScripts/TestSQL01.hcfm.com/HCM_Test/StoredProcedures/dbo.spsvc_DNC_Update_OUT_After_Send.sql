/* CreateDate: 03/20/2009 14:11:33.680 , ModifyDate: 05/01/2010 14:48:09.733 */
GO
/***********************************************************************

PROCEDURE:		spsvc_DNC_Update_OUT_After_Send

DESTINATION SERVER:	hcsql3\sql2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		OnContact PSO Fred Remers

IMPLEMENTOR: 		Fred Remers

DATE IMPLEMENTED:

LAST REVISION DATE:

------------------------------------------------------------------------
NOTES: 	Updates the DNC_OUT table wity a send flag and date.
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_DNC_Update_OUT_After_Send

***********************************************************************/


CREATE PROCEDURE [dbo].[spsvc_DNC_Update_OUT_After_Send] AS

UPDATE	do
SET		FileCreationDate= GETDATE()
		,	sent = 1
FROM    [cstd_dnc_staging] d
				INNER JOIN  [cstd_dnc_out] do
					ON d.phone = do.phone
						AND do.DNC = 0
GO
