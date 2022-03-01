/* CreateDate: 02/24/2022 11:43:19.003 , ModifyDate: 02/24/2022 11:43:19.003 */
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
