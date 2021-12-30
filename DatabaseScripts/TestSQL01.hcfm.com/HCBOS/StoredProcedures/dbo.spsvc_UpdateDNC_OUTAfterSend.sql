/* CreateDate: 10/09/2007 10:19:09.220 , ModifyDate: 01/25/2010 08:11:31.790 */
GO
/***********************************************************************

PROCEDURE:		spsvc_UpdateDNC_OUTAfterSend

VERSION:		v2.0

DESTINATION SERVER:	HCTESTSQL1\SQL2005

DESTINATION DATABASE: 	BOS

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		Howard Abelow v1.5 and 2.0 - Originally Designed by Sean Knight

IMPLEMENTOR: 		Howard Abelow

DATE IMPLEMENTED: 	10/9/2007

LAST REVISION DATE: 	10/9/2007

------------------------------------------------------------------------
NOTES: 	Updates the DNC_OUT table wity a send flag and date.
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_UpdateDNC_OUTAfterSend

***********************************************************************/


CREATE    PROCEDURE [dbo].[spsvc_UpdateDNC_OUTAfterSend] AS

UPDATE	do
SET		FileCreationDate= GETDATE()
		,	sent = 1
FROM    [dnc_staging] d
				INNER JOIN  [DNC_OUT] do
					ON d.phone = do.phone
						AND do.DNC = 0
GO
