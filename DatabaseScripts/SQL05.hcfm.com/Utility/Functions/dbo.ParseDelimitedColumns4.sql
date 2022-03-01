/* CreateDate: 02/24/2022 11:43:09.490 , ModifyDate: 02/24/2022 11:43:09.490 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[ParseDelimitedColumns4](@record [nvarchar](max), @delim [nvarchar](255))
RETURNS  TABLE (
	[Cnt] [int] NULL,
	[C1] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C2] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C3] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C4] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.ParseDelimitedColumns4class].[ParseDelimitedColumns4]
GO
