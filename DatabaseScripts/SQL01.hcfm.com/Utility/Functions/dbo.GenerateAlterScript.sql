/* CreateDate: 02/24/2022 11:43:33.030 , ModifyDate: 02/24/2022 11:43:33.030 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[GenerateAlterScript](@SQL [nvarchar](max))
RETURNS [nvarchar](max) WITH EXECUTE AS CALLER, RETURNS NULL ON NULL INPUT
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.StringFunctions].[GenerateAlterScript]
GO
