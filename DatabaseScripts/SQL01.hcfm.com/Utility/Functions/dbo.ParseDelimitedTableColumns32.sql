/* CreateDate: 02/24/2022 11:43:34.940 , ModifyDate: 02/24/2022 11:43:34.940 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[ParseDelimitedTableColumns32](@record [nvarchar](max), @ColumnDelimiter [nvarchar](255), @RowDelimiter [nvarchar](255))
RETURNS  TABLE (
	[RowNumber] [int] NULL,
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
	[C16] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C17] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C18] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C19] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C20] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C21] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C22] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C23] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C24] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C25] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C26] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C27] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C28] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C29] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C30] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C31] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C32] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.ParseDelimitedTableColumns32class].[ParseDelimitedTableColumns32]
GO
