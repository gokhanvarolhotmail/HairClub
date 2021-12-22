/* CreateDate: 08/10/2006 13:53:15.733 , ModifyDate: 01/25/2010 08:11:31.760 */
GO
--Updates DNC for HCM
CREATE   PROCEDURE [dbo].[UpdateDncInHCM]
AS




	--Update open OUTCAL with a DNC disposition using new table

	UPDATE hcm.dbo.gmin_mngr

	SET 	result_code='DNC'

	,		result_date=CONVERT(datetime,CONVERT(varchar(11),getdate()))

	FROM hcm.dbo.hcmtbl_DNC_Phone  a WITH(NOLOCK)

		INNER JOIN dbo.DNC_OUT d on a.phone  = d.phone

			-- only DNC records that have a last contact MORE than 90 days ago

			AND d.LastContactDate <=  DateAdd(day, -90, CAST(Convert(Varchar(11),GetDate()) as DateTime))

		INNER JOIN hcm.dbo.gmin_mngr c ON a.recordid=c.recordid

			AND   c.act_code='OUTCAL'

  			AND   c.result_code = ''
GO
