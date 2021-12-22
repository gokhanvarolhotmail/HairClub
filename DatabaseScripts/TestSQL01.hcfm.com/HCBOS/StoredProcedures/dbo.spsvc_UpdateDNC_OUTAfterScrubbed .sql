/* CreateDate: 10/10/2007 16:26:20.847 , ModifyDate: 01/25/2010 08:11:31.790 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:		spsvc_UpdateDNC_OUTAfterScrubbed

VERSION:		v2.0

DESTINATION SERVER:	HCTESTSQL1\SQL2005

DESTINATION DATABASE: 	BOS

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		Howard Abelow v1.5 and 2.0 - Originally Designed by Sean Knight

IMPLEMENTOR: 		Howard Abelow

DATE IMPLEMENTED: 	10/10/2007

LAST REVISION DATE: 	10/10/2007

------------------------------------------------------------------------
NOTES: 	Updates the DNC_OUT table wity a send flag and date.
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_UpdateDNC_OUTAfterScrubbed

***********************************************************************/


CREATE    PROCEDURE [dbo].[spsvc_UpdateDNC_OUTAfterScrubbed ] AS


UPDATE  d
SET     dnc = ( CASE WHEN LEN(RTRIM(LTRIM(ListFlag))) = 0 THEN 0
                     ELSE 1
                END ),
        DNCCode = ( CASE WHEN LEN(RTRIM(LTRIM(ListFlag))) = 0 THEN NULL
                         ELSE ListFlag
                    END ),
        ebrexpiration = ( CASE WHEN LEN(RTRIM(LTRIM(expirationDate))) = 0 THEN NULL
                               ELSE convert(datetime, expirationDate)
                          END ),
        lastupdate = getdate()
FROM    [InquiryScrubbed] i
        INNER JOIN  [DNC_OUT] d
			ON i.[Phone] = d.phone
GO
