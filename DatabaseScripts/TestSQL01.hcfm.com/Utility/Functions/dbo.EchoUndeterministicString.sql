/* CreateDate: 02/24/2022 11:44:28.990 , ModifyDate: 02/24/2022 11:44:28.990 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[EchoUndeterministicString](@SQL [nvarchar](4000))
RETURNS [nvarchar](4000) WITH EXECUTE AS CALLER, RETURNS NULL ON NULL INPUT
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.UserDefinedFunctions].[EchoUndeterministicString]
GO
