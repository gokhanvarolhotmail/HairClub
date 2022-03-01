/* CreateDate: 02/24/2022 11:43:18.777 , ModifyDate: 02/24/2022 11:43:18.777 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [RE].[RegExIndex](@Pattern [nvarchar](4000), @Input [nvarchar](max), @Options [int])
RETURNS [int] WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.RegularExpressionFunctions].[RegExIndex]
GO
