/* CreateDate: 03/22/2016 11:02:14.683 , ModifyDate: 03/22/2016 11:02:14.683 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_phone_dnc_wireless_import_staging](
	[phonenumber] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EBRDate] [datetime] NULL,
	[ExportID] [uniqueidentifier] NULL,
	[field_1] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[field_2] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[field_3] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[field_4] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[field_5] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[field_6] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[field_7] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[field_8] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[field_9] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[field_10] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
