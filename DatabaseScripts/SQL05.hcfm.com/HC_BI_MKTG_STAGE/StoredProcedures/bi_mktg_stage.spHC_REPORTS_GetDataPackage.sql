/* CreateDate: 03/16/2011 22:02:17.530 , ModifyDate: 03/16/2011 22:02:17.530 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_REPORTS_GetDataPackage]
@DataPkgKey				int

AS
-------------------------------------------------------------------------
-- [spGBP_REPORTS_GetDataPackage] is used to retrieve information
-- for a single data package.
--
-- exec [[bi_mktg_stage]].[[spHC_REPORTS_GetDataPackage] @DataPkgKey=55
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/16/2009  BURBAS       Initial Creation
--  v4.0    04/02/2010  EKnapp       Added table counts.
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



	SELECT PKG.DataPkgKey, PKG.ExecStartDT, PKG.ExecStopDT, PKG.[Status] as PackageStatus,
		DATEDIFF(N,PKG.ExecStartDT,PKG.ExecStopDT) as TotalRunTimeInMinutes,
		PKGDET.DataPkgDetailKey, PKGDET.TableName, PKGDET.ExtractStartDT, PKGDET.ExtractStopDT,
		PKGDET.ExtractCnt, PKGDET.IsExtracted, PKGDET.TransformStartDT, PKGDET.TransformStopDT,
		PKGDET.IsTransformed, PKGDET.ValidateStartDT, PKGDET.ValidateStopDT, PKGDET.IsValidated,
		PKGDET.CleanupStartDT, PKGDET.CleanupStopDT, PKGDET.IsCleanedup,
		PKGDET.[Status] As DetailStatus, PKG.StatusDT as DetailStatusDate,
		PKGDET.LoadStartDT, PKGDET.LoadStopDT, PKGDET.IsLoaded,
		PKGDET.IgnoreRowCnt, PKGDET.InsertRowCnt, PKGDET.UpdateRowCnt,
		PKGDET.UpdateSCD1RowCnt, PKGDET.UpdateSCD2RowCnt, PKGDET.ExceptionRowCnt, PKGDET.TableInitialRowCnt, PKGDET.TableFinalRowCnt
	FROM bief_stage.syn_META_AuditDataPkg PKG
	INNER JOIN bief_stage.syn_META_AuditDataPkgDetail PKGDET
		ON PKG.DataPkgKey=PKGDET.DataPkgKey
	WHERE PKG.DataPkgKey=@DataPkgKey
	ORDER BY PKGDET.DataPkgDetailKey DESC

END
GO
