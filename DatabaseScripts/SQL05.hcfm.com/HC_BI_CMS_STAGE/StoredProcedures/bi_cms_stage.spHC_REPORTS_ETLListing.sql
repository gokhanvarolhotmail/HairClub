/* CreateDate: 03/15/2011 17:20:54.470 , ModifyDate: 10/26/2011 11:52:30.307 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_REPORTS_ETLListing]


AS
-------------------------------------------------------------------------
-- [[spHC_REPORTS_ETLListing]] is used to retrieve records for ETL listing
-- report
--
-- exec [bi_cms_stage].[spHC_REPORTS_ETLListing]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/16/2009  BURBAS       Initial Creation
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



	SELECT PKG.DataPkgKey, PKG.ExecStartDT, PKG.ExecStopDT, PKG.[Status] as PackageStatus,
		PackageSuccessful = CASE WHEN TBL.BadDataPkgKeys IS NULL THEN 'Yes' ELSE 'No' END,
		DATEDIFF(N,PKG.ExecStartDT,PKG.ExecStopDT) as TotalRunTimeInMinutes
	FROM bief_stage.syn_META_AuditDataPkg PKG
	LEFT JOIN
		-- Create list of data packages that didn't finish.
		(select distinct DataPkgKey as BadDataPkgKeys from  bief_stage.syn_meta_auditdatapkgdetail
		where ((isnull(isextracted,0) = 0
		or isnull(istransformed, 0) = 0
		or isnull(isvalidated, 0) = 0) And NOT [Status] = 'Load Inferred Members Complete')
		or isnull(isloaded,0) = 0) TBL
		ON PKG.DataPkgKey = TBL.BadDataPkgKeys
	--order by PKG.DataPkgKey desc


END
GO
