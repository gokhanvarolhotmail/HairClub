/* CreateDate: 10/17/2007 08:55:07.387 , ModifyDate: 10/17/2007 08:55:07.390 */
GO
CREATE TABLE [dbo].[hcmtbl_Noshows_ToExport](
	[recordId] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[firstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[center] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[apptDate] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[apptTime] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gender] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creative] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sendcount] [int] NULL,
	[centerid] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[langtype] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
