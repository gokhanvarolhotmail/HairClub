/* CreateDate: 03/20/2009 14:11:15.897 , ModifyDate: 10/27/2014 09:57:12.483 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:		spsvc_DNC_Update_OUT_Before_Send

DESTINATION SERVER:	hcsql3\sql2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		OnContact PSO Fred Remers

IMPLEMENTOR: 		Fred Remers

DATE IMPLEMENTED:

LAST REVISION DATE: 	2014-09-17	MJW	Add WITH (NOLOCK)s to oncd_activity subquery

------------------------------------------------------------------------
NOTES: 	Updates the DNC_OUT table with new records and updated phones.
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_DNC_Update_OUT_Before_Send

***********************************************************************/


CREATE PROCEDURE [dbo].[spsvc_DNC_Update_OUT_Before_Send] AS

declare @newContact TABLE
    (
      phone varchar(10),
      LastContactDate datetime,
      LastSaleDate datetime
    )

	INSERT  INTO @newContact
		 SELECT  cstd_dnc_staging.phone,
				(select MAX(oncd_activity.due_date) from oncd_activity WITH (NOLOCK)
					inner join oncd_activity_contact WITH (NOLOCK) on oncd_activity_contact.contact_id = cstd_dnc_staging.contact_id
						and oncd_activity_contact.activity_id = oncd_activity.activity_id
					where (oncd_activity.action_code = 'INCALL' or oncd_activity.result_code IN ('SHOWSALE', 'SHOWNOSALE'))) as LastContactDate,
			NULL AS LastSaleDate
			FROM cstd_dnc_staging
			WHERE cstd_dnc_staging.phone in (SELECT phone FROM cstd_dnc_out)
			group by cstd_dnc_staging.phone, cstd_dnc_staging.contact_id
			order by cstd_dnc_staging.phone


	--UPDATE records only
	UPDATE  d
	SET	phone = c.phone,
		LastContactDate = c.LastContactDate,
		LastSaleDate = c.LastSaleDate
	FROM @newContact c
			INNER JOIN cstd_dnc_out d
				ON c.phone = d.phone
GO
