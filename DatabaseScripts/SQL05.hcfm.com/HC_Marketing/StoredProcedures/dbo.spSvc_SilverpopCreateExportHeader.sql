/* CreateDate: 11/17/2016 13:00:07.837 , ModifyDate: 03/15/2017 13:40:49.610 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SilverpopCreateExportHeader
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APPLICATION:	Silverpop Export
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/16/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

DECLARE	@ExportHeaderID INT


EXEC spSvc_SilverpopCreateExportHeader @ExportHeaderID OUTPUT


SELECT	@ExportHeaderID AS 'ExportHeaderID'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SilverpopCreateExportHeader]
(
	@ExportHeaderID INT OUTPUT
)
AS
BEGIN

DECLARE @LastExportDate DATETIME
,		@StartDate DATETIME
,       @EndDate DATETIME


SET @LastExportDate = (SELECT MAX(EH.ExportEndDate) FROM datExportHeader EH WHERE EH.IsCompletedFlag = 1)


IF @LastExportDate IS NULL
BEGIN
	SET @LastExportDate = DATEADD(MINUTE, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
END


SET @EndDate = GETDATE()
SET @StartDate = DATEADD(MINUTE, -1, @LastExportDate)


INSERT  INTO datExportHeader (
			ExportStartDate
		,	ExportEndDate
        ,	IsCompletedFlag
        ,	CreateDate
        ,	CreateUser
        ,	LastUpdate
        ,	LastUpdateUser
		)
VALUES  (
			@StartDate
        ,	@EndDate
        ,	0
        ,	GETDATE()
        ,	'SP-Export'
        ,	GETDATE()
        ,	'SP-Export'
		)


SELECT	@ExportHeaderID = SCOPE_IDENTITY()

END
GO
