/* CreateDate: 02/03/2015 13:35:45.270 , ModifyDate: 11/01/2016 09:24:05.850 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--select dbo.Retention(321, 317, 21, '1/1/2015', '12/31/2015')
CREATE FUNCTION [dbo].[Retention] (
	@open_pcp INTEGER
,	@close_pcp INTEGER
,	@net_nb1_conv INTEGER
,	@begdt DATETIME
,	@enddt DATETIME
)
RETURNS DECIMAL(38,5) AS
BEGIN
RETURN(
	CASE WHEN @open_pcp + @close_pcp = 0 THEN 0 ELSE
	1- ((CONVERT(DECIMAL(18,5), @open_pcp + @net_nb1_conv - @close_pcp))

	/
	((CONVERT(DECIMAL(18,5), @open_pcp + @close_pcp))/2.0) * (365.0 / (DATEDIFF(day, @begdt, @enddt)+1.0)))
	 END
)
END
GO
