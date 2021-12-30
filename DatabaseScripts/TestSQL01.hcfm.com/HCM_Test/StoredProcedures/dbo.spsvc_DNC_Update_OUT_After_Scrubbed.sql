/* CreateDate: 03/20/2009 14:59:39.723 , ModifyDate: 05/01/2010 14:48:09.777 */
GO
/***********************************************************************

PROCEDURE:		spsvc_DNC_Update_OUT_After_Scrubbed

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

SAMPLE EXECUTION: EXEC spsvc_DNC_Update_OUT_After_Scrubbed

***********************************************************************/


CREATE PROCEDURE [dbo].[spsvc_DNC_Update_OUT_After_Scrubbed] AS


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
FROM    [cstd_dnc_inquiry_scrubbed] i
        INNER JOIN  [cstd_dnc_out] d
			ON i.[Phone] = d.phone
GO
