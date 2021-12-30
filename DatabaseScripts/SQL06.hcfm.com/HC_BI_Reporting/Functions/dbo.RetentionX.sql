/* CreateDate: 12/15/2015 11:06:44.557 , ModifyDate: 11/01/2016 09:24:10.233 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--select dbo.RetentionX(321, 317, 21)
CREATE FUNCTION [dbo].[RetentionX] (
	@open_pcp INTEGER
,	@close_pcp INTEGER
,	@net_nb1_conv INTEGER
)
RETURNS DECIMAL(38,3) AS
BEGIN
RETURN(
	CASE WHEN @open_pcp + @close_pcp = 0 THEN 0 ELSE
	1- (
		CONVERT(NUMERIC(7,2), @open_pcp + @net_nb1_conv - @close_pcp)
	)
	/
	(
		(
			CONVERT(NUMERIC(7,2), @open_pcp + @close_pcp)
		)/2.0
	)
	 END
)
END
GO
