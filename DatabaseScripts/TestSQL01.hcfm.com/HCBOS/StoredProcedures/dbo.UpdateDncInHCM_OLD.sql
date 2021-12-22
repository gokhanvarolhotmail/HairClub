/* CreateDate: 09/28/2006 16:09:53.367 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
--Updates DNC for HCM
CREATE   PROCEDURE [dbo].[UpdateDncInHCM_OLD]
AS


DECLARE @dnc_table Table (

	phone varchar(10),

	dnc bit)


	--Create table variable and set DNC  to 1 if DNC or EBR is expired

	INSERT INTO @dnc_table (phone,dnc)

	SELECT 	phone

	,	(CASE WHEN dnc=1 AND DNCCode <> 'WIR'  THEN 1 ELSE 0 END) dnc  -- not used: AND (ebrexpiration < getdate() OR ebrexpiration IS NULL)

	FROM dbo.dnc_out

	WHERE dnc=1



	--Join the two tables and update appropriate fields

	UPDATE hcm.dbo.gmin_mngr

	SET 	result_code='DNC'

	,	result_date=CONVERT(datetime,CONVERT(varchar(11),getdate()))

	FROM hcm.dbo.gmin_phone  a WITH(NOLOCK)

	INNER JOIN @dnc_table d ON a.phone=d.phone

	INNER JOIN hcm.dbo.gmin_mngr c ON a.recordid=c.recordid

	AND   c.act_code='OUTCAL'

  	AND   c.result_code = ''
GO
