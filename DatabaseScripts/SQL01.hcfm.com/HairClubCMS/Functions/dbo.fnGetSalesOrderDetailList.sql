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
