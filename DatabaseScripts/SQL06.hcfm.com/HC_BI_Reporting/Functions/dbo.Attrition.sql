--select dbo.Attrition(131, 131, 2, '12/1/12', '12/31/12')
CREATE FUNCTION [dbo].[Attrition] (
	@open_pcp INTEGER
,	@close_pcp INTEGER
,	@net_nb1_conv INTEGER
,	@begdt DATETIME
,	@enddt DATETIME
)
RETURNS DECIMAL(38,1) AS
BEGIN
RETURN(
	CASE WHEN @open_pcp + @close_pcp = 0 THEN 0 ELSE
	(
		CONVERT(NUMERIC(7,2), @open_pcp + @net_nb1_conv - @close_pcp)
	)
	/
	(
		(
			CONVERT(NUMERIC(7,2), @open_pcp + @close_pcp)
		)/2.0
	) *
	(
		365.0 / (DATEDIFF(day, @begdt, @enddt)+1.0)
	) * 100
	 END
)
END
