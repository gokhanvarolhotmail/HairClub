/* CreateDate: 12/11/2006 10:59:02.677 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Updates DNC for HCM
CREATE   PROCEDURE [dbo].[spsvc_UpdateDncInHCM_OneTime]
	@scrubDate DateTime
AS




	--Update open OUTCAL with a DNC disposition using new table

	UPDATE hcm.dbo.gmin_mngr

	SET 	result_code='DNC'

	,		result_date=CONVERT(datetime,CONVERT(varchar(11),@scrubDate))

	FROM hcm.dbo.hcmtbl_DNC_Phone  a WITH(NOLOCK)

		INNER JOIN dbo.DNC_OUT d on a.phone  = d.phone

			-- only DNC records that have a last contact MORE than 90 days ago

			AND d.LastContactDate <=  DateAdd(day, -90, CAST(Convert(Varchar(11),@scrubDate) as DateTime))

		INNER JOIN hcm.dbo.gmin_mngr c ON a.recordid=c.recordid

			AND   c.act_code='OUTCAL'

  			AND   c.result_code = ''
GO
