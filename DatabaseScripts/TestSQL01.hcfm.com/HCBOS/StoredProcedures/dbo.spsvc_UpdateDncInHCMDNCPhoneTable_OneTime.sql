/* CreateDate: 12/11/2006 10:55:11.597 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Updates or inserts only true DNC records into new hcmtbl_DNC_Phone table for HCM Update

CREATE    PROCEDURE [dbo].[spsvc_UpdateDncInHCMDNCPhoneTable_OneTime]
	@scrubDate DateTime

AS

SET NOCOUNT ON

--Create table variable

DECLARE @dnc_table Table (

	phone varchar(10),

	dnccode varchar(5),

	ebrexpdate datetime)


	--Insert into table variable

	INSERT INTO @dnc_table (phone, dnccode, ebrexpdate)

	SELECT 	phone

	,	ISNULL (dnccode, 'XXX') dnccode

	,	ebrexpiration

	FROM dbo.dnc_out

	WHERE dnc=1

	AND DNCCode NOT IN ('WIR', 'NXX')

	AND CONVERT(datetime,CONVERT(varchar(11),FileCreationDate)) =	CONVERT(datetime,CONVERT(varchar(11),@scrubDate))  --LastUpdate



	-- First do an update on the DNCCode, EBR and Scrub Date

	UPDATE HCM.dbo.hcmtbl_DNC_Phone

	SET	DNCCode = d.dnccode

	,		EBRExpDate = CONVERT(datetime,CONVERT(varchar(11),d.ebrexpdate))

	,		LastScrubDate = CONVERT(datetime,CONVERT(varchar(11),@scrubDate))

	FROM @dnc_table d

	INNER JOIN HCM.dbo.hcmtbl_DNC_Phone  p ON d.phone = p.phone




	--Join the two tables and insert the new records

	INSERT INTO HCM.dbo.hcmtbl_DNC_Phone(RecordId, Phone, DNCCode, EBRExpDate, LastScrubDate)

	SELECT  a.recordid

	,	 d.phone

	,	 d.dnccode

	,	CONVERT(datetime,CONVERT(varchar(11),ebrexpdate))

	,	CONVERT(datetime,CONVERT(varchar(11),@scrubDate))

	FROM hcm.dbo.gmin_phone  a WITH(NOLOCK)

	INNER JOIN @dnc_table d ON a.phone=d.phone

	AND d.phone NOT IN(SELECT Phone FROM HCM.dbo.hcmtbl_DNC_Phone)
GO
