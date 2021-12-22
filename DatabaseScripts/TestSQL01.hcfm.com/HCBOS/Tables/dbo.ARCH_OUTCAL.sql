/* CreateDate: 09/12/2006 11:02:03.940 , ModifyDate: 09/12/2006 11:02:03.940 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARCH_OUTCAL](
	[act_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_desc] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountOfproject_code] [float] NULL,
	[archive_code] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
