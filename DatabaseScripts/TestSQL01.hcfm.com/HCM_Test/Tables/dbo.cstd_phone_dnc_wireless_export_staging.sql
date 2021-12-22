/* CreateDate: 03/22/2016 11:02:14.677 , ModifyDate: 03/22/2016 11:02:14.677 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_phone_dnc_wireless_export_staging](
	[phonenumber] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EBRDate] [datetime] NULL,
	[ExportID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
