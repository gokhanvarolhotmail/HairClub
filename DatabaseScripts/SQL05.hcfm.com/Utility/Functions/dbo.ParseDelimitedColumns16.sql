/* CreateDate: 02/24/2022 11:43:09.240 , ModifyDate: 02/24/2022 11:43:09.240 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[ParseDelimitedColumns16](@record [nvarchar](max), @delim [nvarchar](255))
RETURNS  TABLE (
	[Cnt] [int] NULL,
	[C1] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C2] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C3] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C4] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C5] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C6] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C7] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C8] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C9] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C10] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C11] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C12] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C13] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C14] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C15] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C16] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.ParseDelimitedColumns16class].[ParseDelimitedColumns16]
GO