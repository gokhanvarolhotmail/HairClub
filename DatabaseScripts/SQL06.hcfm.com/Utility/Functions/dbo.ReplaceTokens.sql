/* CreateDate: 02/24/2022 11:43:19.227 , ModifyDate: 02/24/2022 11:43:19.227 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[ReplaceTokens](@Input [nvarchar](max), @BeforeList [nvarchar](max), @AfterList [nvarchar](max), @delimiter [nvarchar](max), @IgnoreCase [bit], @GenerateAlter [bit], @TrimMultiLine [bit])
RETURNS [nvarchar](max) WITH EXECUTE AS CALLER, RETURNS NULL ON NULL INPUT
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.StringFunctions].[ReplaceTokens]
GO
