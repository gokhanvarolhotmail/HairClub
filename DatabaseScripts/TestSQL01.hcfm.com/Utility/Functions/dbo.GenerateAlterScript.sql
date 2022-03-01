/* CreateDate: 02/24/2022 11:44:29.077 , ModifyDate: 02/24/2022 11:44:29.077 */
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
