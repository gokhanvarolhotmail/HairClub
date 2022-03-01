/* CreateDate: 02/24/2022 11:44:28.413 , ModifyDate: 02/24/2022 11:44:28.413 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [RE].[RegExReplaceX](@Pattern [nvarchar](4000), @Input [nvarchar](max), @Repacement [nvarchar](max), @Options [int])
RETURNS [nvarchar](max) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.RegularExpressionFunctions].[RegExReplaceX]
GO
