/* CreateDate: 02/24/2022 11:43:32.447 , ModifyDate: 02/24/2022 11:43:32.447 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [RE].[RegExReplace](@Input [nvarchar](max), @Pattern [nvarchar](4000), @Repacement [nvarchar](max))
RETURNS [nvarchar](max) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.RegularExpressionFunctions].[RegExReplace]
GO
