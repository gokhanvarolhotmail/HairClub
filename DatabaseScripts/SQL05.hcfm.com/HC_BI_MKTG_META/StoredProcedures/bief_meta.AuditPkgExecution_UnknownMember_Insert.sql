/* CreateDate: 05/03/2010 12:23:09.140 , ModifyDate: 05/03/2010 12:23:09.140 */
GO
CREATE PROCEDURE [bief_meta].[AuditPkgExecution_UnknownMember_Insert]


AS
-------------------------------------------------------------------------
-- [AuditPkgExecution_UnknownMember_Insert] is used to add
-- the unknown member to the table.
--
--
--   exec [bief_meta].[AuditPkgExecution_UnknownMember_Insert]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET IDENTITY_INSERT [bief_meta].[AuditPkgExecution] ON


	INSERT INTO bief_meta.AuditPkgExecution(PkgExecKey, ParentPkgExecKey, BatchExecKey
				, ExecutionInstanceGUID, PkgName, PkgGUID, PkgVersionGUID
                , PkgVersionMajor, PkgVersionMinor, ExecStartDT, ExecStopDT, PkgDuration, Status, StatusDT)
		VALUES     (-1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)

	SET IDENTITY_INSERT [bief_meta].[AuditPkgExecution] OFF

	-- Cleanup
	-- Reset SET NOCOUNT to OFF.
	SET NOCOUNT OFF

	-- Cleanup temp tables

	-- Return success
	RETURN 0

END
GO
