/* CreateDate: 10/10/2007 17:13:04.833 , ModifyDate: 01/25/2010 08:11:31.790 */
GO
/***********************************************************************

PROCEDURE:		spsvc_UpdateDncInHCM

VERSION:		v2.0

DESTINATION SERVER:	HCTESTSQL1\SQL2005

DESTINATION DATABASE: 	BOS

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		Howard Abelow v1.5 and 2.0 - Originally Designed by Sean Knight

IMPLEMENTOR: 		Howard Abelow

DATE IMPLEMENTED: 	10/10/2007

LAST REVISION DATE: 	10/10/2007

------------------------------------------------------------------------
NOTES: 	--Updates DNC Flag in oncd_contact for HCM
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_UpdateDncInHCM

***********************************************************************/


CREATE   PROCEDURE [dbo].[spsvc_UpdateDncInHCM]
AS
    UPDATE  c
    SET   cst_do_not_call = 'Y',
            updated_date = CONVERT(datetime, CONVERT(varchar(11), getdate())),
            updated_by_user_code = 'SVCACCOUNT',
			cst_dnc_date = CONVERT(datetime, CONVERT(varchar(11), getdate()))
    FROM    HCM.dbo.[oncd_contact] c WITH ( NOLOCK )
            INNER JOIN HCM.dbo.[oncd_contact_phone] p WITH ( NOLOCK )
				ON c.[contact_id] = p.[contact_id]
				AND p.[primary_flag] = 'Y'
            INNER JOIN dbo.DNC_OUT d WITH ( NOLOCK )
				ON RTRIM(p.area_code)+ RTRIM(p.[phone_number]) = d.phone  -- only DNC records that have a last contact MORE than 90 days ago
				AND d.LastContactDate <= DateAdd(day, -90, CAST(Convert(Varchar(11), GetDate()) as DateTime))
				AND c.[creation_date] <= DateAdd(day, -90, CAST(Convert(Varchar(11), GetDate()) as DateTime))
				AND d.[DNC] = 1
				AND d.DNCCode NOT IN ('WIR', 'NXX')
				AND (d.EBRExpiration < GETDATE() OR d.EBRExpiration IS NULL)
				AND CONVERT(datetime,CONVERT(varchar(11),d.FileCreationDate)) =	CONVERT(datetime,CONVERT(varchar(11),getdate()))
GO
