/* CreateDate: 02/18/2013 06:45:39.437 , ModifyDate: 02/27/2017 09:49:37.757 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fnGetSalesOrderDetailList]
(@soguid uniqueidentifier)
RETURNS varchar(1000)
AS
BEGIN
	DECLARE @p_str VARCHAR(1000)
	SET @p_str = ''
	SELECT @p_str = @p_str + ',' + CAST(sc.SalesCodeDescription + ' (' + cast(sodet.Quantity as varchar(10)) + ')' AS VARCHAR(40))
		FROM datSalesOrderDetail sodet
			left outer join cfgSalesCode sc
				ON sodet.SalesCodeID = sc.SalesCodeID

	WHERE SalesOrderGUID = @SOGUID

	RETURN @p_str

END
GO
