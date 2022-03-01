/* CreateDate: 02/24/2022 11:44:28.633 , ModifyDate: 02/24/2022 11:44:28.633 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [RE].[RegExMatch](@Pattern [nvarchar](4000), @Input [nvarchar](max), @Options [int])
RETURNS [nvarchar](max) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.RegularExpressionFunctions].[RegExMatch]
GO
