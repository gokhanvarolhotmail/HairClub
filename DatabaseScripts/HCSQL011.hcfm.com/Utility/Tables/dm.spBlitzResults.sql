/* CreateDate: 10/30/2014 11:35:48.550 , ModifyDate: 10/30/2014 11:35:48.550 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dm].[spBlitzResults](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CheckDate] [datetime] NULL,
	[BlitzVersion] [int] NULL,
	[Priority] [tinyint] NULL,
	[FindingsGroup] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Finding] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DatabaseName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[URL] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Details] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QueryPlan] [xml] NULL,
	[QueryPlanFiltered] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CheckID] [int] NULL,
 CONSTRAINT [PK_9C838D19-506F-4F4B-820E-970C43A08ABC] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
