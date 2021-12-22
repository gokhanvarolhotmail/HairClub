/*===============================================================================================
-- Procedure Name:			rptEndOfDayVariance
-- Procedure Description:
--
-- Created By:				Hdu
-- Implemented By:			Hdu
-- Last Modified By:		Hdu
--
-- Date Created:			10/11/2012
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES:

	10/17/12	MLM		Modified the table Structure to tied RegisterLog to RegisterClose
	10/30/12	MLM		Modified the Query to return results from RegisterTender Table

--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptEndOfDayVariance] 201, '2012-10-12', 0
================================================================================================*/
CREATE PROCEDURE [dbo].[rptEndOfDayVariance]
(
	@CenterID INT,
	@CloseDate DATETIME,
	@BusinessSegments INT = 0 -- 0 All, 1 Non-Surgery, 2 Surgery
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT tType.TenderTypeDescription
		,ISNULL(tResults.TenderQuantity,0.00) AS TenderQuantity
		,ISNULL(tResults.TenderTotal,0.00) as TenderTotal
		,ISNULL(tResults.RegisterQuantity,0.00) as RegisterQuantity
		,ISNULL(tResults.RegisterTotal,0.00) as RegisterTender
		,ISNULL(tResults.TotalVariance,0.00) as TotalVariance
		,CASE WHEN tType.TenderTypeDescriptionShort IN ('Cash','Check') THEN 1 ELSE tType.TenderTypeSortOrder END AS ROWGROUPING
	FROM dbo.LkpTenderType tType
		LEFT OUTER JOIN (
							Select tt.TenderTypeID
								,tt.TenderTypeDescription
								,SUM(ISNULL(TenderQuantity, 0.00)) TenderQuantity
								,SUM(ISNULL(TenderTotal, 0.00)) TenderTotal
								,SUM(ISNULL(RegisterQuantity, 0.00)) RegisterQuantity
								,SUM(ISNULL(RegisterTotal, 0.00)) RegisterTotal
								,SUM(ISNULL(TotalVariance, 0.00)) TotalVariance
							FROM dbo.lkpTenderType tt
								INNER JOIN dbo.datRegisterTender rt on tt.TenderTypeID = rt.TenderTypeID
								INNER JOIN dbo.datRegisterClose rc on rt.RegisterCloseGUID = rc.RegisterCloseGUID
								INNER JOIN dbo.datRegisterLog rl on rc.RegisterLogGUID = rl.RegisterLogGUID
								INNER JOIN dbo.cfgRegister r on rl.RegisterID = r.RegisterID
								INNER JOIN dbo.datSalesOrderTender sot on rc.RegisterCloseGUID = sot.RegisterCloseGUID
								INNER JOIN dbo.datSalesOrder so ON so.SalesOrderGUID = sot.SalesOrderGUID
										LEFT JOIN datClientMembership cm ON cm.ClientMembershipGUID = so.ClientMembershipGUID
										LEFT JOIN datClient cl ON cl.ClientGUID = cm.ClientGUID
											LEFT JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
												LEFT JOIN [dbo].[lkpBusinessSegment] bs ON bs.BusinessSegmentID = m.BusinessSegmentID
							WHERE rl.RegisterDate = @CloseDate
									AND rl.CenterID = @CenterID
									--AND (@BusinessSegments = 0
									--		OR (@BusinessSegments = 1 AND bs.BusinessSegmentDescriptionShort IN ('BIO','EXT'))
									--		OR (@BusinessSegments = 2 AND bs.BusinessSegmentDescriptionShort IN ('SUR'))
									--	)
							GROUP BY tt.TenderTypeID, tt.TenderTypeDescription
		) tResults on tType.TenderTypeID = tResults.TendertypeID

END
