/* CreateDate: 02/24/2022 11:43:07.917 , ModifyDate: 02/24/2022 11:43:07.917 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [RE].[RegExIsMatch](@Pattern [nvarchar](4000), @Input [nvarchar](max), @Options [int])
RETURNS [bit] WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.RegularExpressionFunctions].[RegExIsMatch]
GO
