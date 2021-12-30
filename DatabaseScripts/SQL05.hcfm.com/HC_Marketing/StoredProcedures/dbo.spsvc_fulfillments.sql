/* CreateDate: 03/06/2019 16:25:46.820 , ModifyDate: 07/16/2019 09:46:43.520 */
GO
/***********************************************************************
PROCEDURE:				spsvc_fulfillments
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					James Lee
IMPLEMENTOR:			James Lee
DATE IMPLEMENTED:		3/14/2019
DESCRIPTION:			3/14/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spsvc_fulfillments
***********************************************************************/
CREATE PROCEDURE [dbo].[spsvc_fulfillments]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @cname as char(3)
DECLARE @begdt as datetime
DECLARE @enddt as datetime
DECLARE @filename as varchar(20)


SELECT @begdt =  CAST(convert(varchar(11),dateadd(dd,-1,getdate())) AS DATETIME)
SELECT @enddt = @begdt  + ' 23:59:59'
SELECT @filename = @cname + CAST(MONTH(getdate()) as varchar(2))+ CAST(DAY(getdate()) as varchar(2)) + CAST(YEAR(getdate()) as varchar(4)) + '.txt'


SELECT	DISTINCT
		'recordid' = CAST(lead.ContactID__c AS VARCHAR(10))
,		'center number' = CAST(lead.CenterID__c AS INT)
,		'center name' = CAST('HCM' AS VARCHAR(3))
,		'center address 1' = CASE WHEN lead.CenterID__c LIKE '2%' THEN '1515 S. Federal Hwy' ELSE CAST(cc.[address1] as varchar(50)) END
,		'center address 2' = CASE WHEN lead.CenterID__c LIKE '2%' THEN 'Suite 401' ELSE CAST(cc.[address2] AS VARCHAR(50)) END
,		'center city' = CASE WHEN lead.CenterID__c LIKE '2%' THEN 'Boca Raton' ELSE CAST(cc.city AS varchar(50)) END
,		'center state' = CASE WHEN lead.CenterID__c LIKE '2%' THEN 'FL' ELSE CAST(LS.statedescriptionshort AS VARCHAR(10)) END
,		'center zip' = CASE WHEN lead.CenterID__c LIKE '2%' THEN '33432' ELSE CAST(cc.postalcode AS VARCHAR(10)) END
,		'contact fname' = CAST(RTRIM(lead.FirstName) AS VARCHAR(50))
,		'contact lname' = CAST(RTRIM(lead.LastName) AS VARCHAR(50))
,		'contact address 1' = CAST(RTRIM(Address__c.Street__c) AS VARCHAR(60))
,		'contact address 2' = CAST(RTRIM(Address__c.Street2__c) AS VARCHAR(60))
,		'contact city' = CAST(RTRIM(Address__c.City__c) AS VARCHAR(60))
,		'contact state' = CAST(RTRIM(Address__c.State__c) AS VARCHAR(20))
,		'contact zip' = CAST(RTRIM(Address__c.Zip__c) AS VARCHAR(15))
,		'contact create date' = lead.CreatedDate
,		'promo' = CAST(lead.Promo_Code_Legacy__c AS VARCHAR(50))
,		'create by' = CAST(UserCode__c AS VARCHAR(20))
,		'promo2' = 'A'
,		'cst_gender' = CAST(RTRIM(lead.Gender__c) AS VARCHAR(10))
,		'type' = CAST(dbo.GETTYPECODE(lead.Language__c, lead.Gender__c) AS VARCHAR(2))
,		'filename' = 'HCM'  + CAST(MONTH(getdate()) as varchar(2))+ CAST(DAY(getdate()) as varchar(2)) + CAST(YEAR(getdate()) as varchar(4)) + '.txt'
,		'email' = CAST(ec.name AS VARCHAR(100))
,		'phone' = CAST(p.PhoneAbr__c AS VARCHAR(50))
FROM	HC_BI_SFDC.dbo.Address__c
		LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead
			ON Address__c.Lead__c = lead.Id
			AND Address__c.Primary__c = 1
		LEFT OUTER JOIN HC_BI_SFDC.dbo.Email__c ec
			ON lead.Id = ec.Lead__c
			AND ec.Primary__c = 1
		LEFT OUTER JOIN HC_BI_SFDC.dbo.Phone__c p
			ON lead.Id = p.Lead__c
			AND p.Primary__c = 1
		LEFT OUTER JOIN HC_BI_SFDC.dbo.Task
			ON lead.Id = Task.WhoId
		LEFT OUTER JOIN HC_BI_SFDC.dbo.[User] u
			ON u.Id = lead.CreatedById
		INNER JOIN SQL01.HairClubCMS.dbo.cfgCenter CC
			ON lead.CenterID__c = CC.CenterID
		INNER JOIN SQL01.HairClubCMS.dbo.lkpState LS
			ON CC.StateID = LS.StateID
WHERE	CAST(lead.CenterID__c AS INT) <> 355
		AND ISNULL(Task.IsDeleted, 0) = 0
		AND ISNULL(lead.IsDeleted, 0) = 0
		AND ISNULL(Address__c.IsDeleted, 0) = 0
		AND ISNULL(ec.IsDeleted, 0) = 0
		AND ISNULL(p.IsDeleted, 0) = 0
		AND ( Task.Result__c = 'Brochure' OR ISNULL(Task.ReceiveBrochure__c, 0) = 1 )
		AND ( lead.FirstName IS NOT NULL OR	LEN(LTRIM(RTRIM(lead.FirstName))) > 0 )
		AND ( lead.LastName IS NOT NULL OR	LEN(LTRIM(RTRIM(lead.LastName))) > 0 )
		AND ( Zip__c IS NOT NULL OR	LEN(LTRIM(RTRIM(Zip__c))) > 0 )
		AND ( Gender__c IS NOT NULL OR	LEN(LTRIM(RTRIM(Gender__c))) > 0 )
		AND Zip__c <> 'XXX'
		AND State__c <> 'XX'
		AND City__c IS NOT NULL
		AND Task.ActivityDate BETWEEN @begdt AND @enddt
ORDER BY CAST(RTRIM(lead.LastName) AS VARCHAR(50))

END
GO
