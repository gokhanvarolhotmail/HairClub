/* CreateDate: 02/24/2022 11:43:18.850 , ModifyDate: 02/24/2022 11:43:18.850 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [RE].[RegExEscape](@Input [nvarchar](max))
RETURNS [nvarchar](max) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.RegularExpressionFunctions].[RegExEscape]
GO
