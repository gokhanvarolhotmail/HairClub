/* CreateDate: 03/20/2009 14:11:51.563 , ModifyDate: 01/07/2016 14:19:18.107 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:		spsvc_DNC_Update_In_HCM

DESTINATION SERVER:	hcsql3\sql2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		OnContact PSO Fred Remers

IMPLEMENTOR: 		Fred Remers

DATE IMPLEMENTED:

LAST REVISION DATE:

------------------------------------------------------------------------
NOTES: 	--Updates DNC Flag in oncd_contact for HCM
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_DNC_Update_In_HCM

***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_DNC_Update_In_HCM]
AS
	RETURN

	--WW - MJW: Disable per HC request 2016-01-07\
	-- until finer logic can be decided
	/*
    UPDATE  c
    SET   cst_do_not_call = 'Y',
            updated_date = CONVERT(datetime, CONVERT(varchar(11), getdate())),
            updated_by_user_code = 'SVCACCOUNT',
			cst_dnc_date = CONVERT(datetime, CONVERT(varchar(11), getdate()))
    FROM    HCM.dbo.[oncd_contact] c WITH ( NOLOCK )
            INNER JOIN HCM.dbo.[oncd_contact_phone] p WITH ( NOLOCK )
				ON c.[contact_id] = p.[contact_id]
				AND p.[primary_flag] = 'Y'
            INNER JOIN cstd_dnc_out d WITH ( NOLOCK )
				ON RTRIM(p.area_code)+ RTRIM(p.[phone_number]) = d.phone  -- only DNC records that have a last contact MORE than 90 days ago
				AND d.LastContactDate <= DateAdd(day, -90, CAST(Convert(Varchar(11), GetDate()) as DateTime))
				AND c.[creation_date] <= DateAdd(day, -90, CAST(Convert(Varchar(11), GetDate()) as DateTime))
				AND d.[DNC] = 1
				AND d.DNCCode NOT IN ('WIR', 'NXX')
				AND (d.EBRExpiration < GETDATE() OR d.EBRExpiration IS NULL)
				AND CONVERT(datetime,CONVERT(varchar(11),d.FileCreationDate)) =	CONVERT(datetime,CONVERT(varchar(11),getdate()))
	*/
GO
