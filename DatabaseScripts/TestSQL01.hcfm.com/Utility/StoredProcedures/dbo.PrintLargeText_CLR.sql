/* CreateDate: 02/24/2022 11:44:30.860 , ModifyDate: 02/24/2022 11:44:30.860 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PrintLargeText_CLR]
	@SQL [nvarchar](max),
	@TrimMultiline [bit] = True,
	@Printed [bit] = False OUTPUT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.StringFunctions].[PrintLargeText_CLR]
GO
