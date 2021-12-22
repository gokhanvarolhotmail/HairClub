/* CreateDate: 02/18/2013 07:28:18.667 , ModifyDate: 02/27/2017 09:49:36.980 */
GO
/***********************************************************************
		PROCEDURE: 				[fn_GetClientMembershipAccumLastUsedDate]
		DESTINATION SERVER:		SQL01
		DESTINATION DATABASE:	HairClubCMS
		AUTHOR:					Michael Maass
		DATE IMPLEMENTED:		2013-01-11
		--------------------------------------------------------------------------------------------------------
		NOTES: Converts UTC DateTime to Local Time for specific Center
		--------------------------------------------------------------------------------------------------------
		Sample Execution:
		SELECT dbo.[fn_GetClientMembershipAccumLastUsedDate] ('21948A51-CFF1-4587-9C1F-D98642DE990A', 8)
		***********************************************************************/
		CREATE FUNCTION [dbo].[fn_GetClientMembershipAccumLastUsedDate]
		(
			@ClientMembershipGUID CHAR(36), @AccumulatorID INT
		)
		RETURNS DATETIME
		AS
		BEGIN

			DECLARE @LastUsed DATETIME

			SELECT TOP 1 @LastUsed = so.OrderDate
			FROM datSalesOrder so
				inner join datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
				inner join cfgAccumulatorJoin aj on sod.SalesCodeID = aj.SalesCodeID
				inner join datClientMembershipAccum cma on so.ClientMembershipGUID = cma.ClientMembershipGUID AND aj.AccumulatorID = cma.AccumulatorID
			WHERE so.ClientMembershipGUID = @ClientMembershipGUID
				AND cma.AccumulatorID = @AccumulatorID
				AND so.IsVoidedFlag = 0
				AND so.IsRefundedFlag = 0
				AND cma.UsedAccumQuantity <> 0
			Order by so.OrderDate Desc

			RETURN @LastUsed

		END
GO
