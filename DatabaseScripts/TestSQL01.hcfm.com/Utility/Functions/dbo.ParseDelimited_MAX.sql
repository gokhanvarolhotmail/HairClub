/* CreateDate: 02/24/2022 11:44:29.877 , ModifyDate: 02/24/2022 11:44:29.877 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[ParseDelimited_MAX](@record [nvarchar](max), @delim [nvarchar](255))
RETURNS  TABLE (
	[FieldNum] [int] NULL,
	[Field] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.ParseDelimitedclass].[ParseDelimited]
GO
