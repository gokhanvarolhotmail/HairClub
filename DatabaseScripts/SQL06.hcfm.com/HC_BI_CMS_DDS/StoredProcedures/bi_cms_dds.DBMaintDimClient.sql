create PROCEDURE [bi_cms_dds].[DBMaintDimClient]

AS




update DWCli
set contactkey=isnull(DWCont.ContactKey,-1)
from HC_BI_CMS_DDS.bi_cms_dds.DimClient DWCli
JOIN HairClubCMS.dbo.datClient srcCli
	on DWCli.ClientSSID=srcCli.ClientGUID
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DWCont with (nolock)
	on srcCli.ContactID=DWCont.ContactSSID
	where dwcont.contactkey is null


	--select COUNT(*) from bi_mktg_dds.FactActivity
