/* CreateDate: 04/07/2009 14:06:39.053 , ModifyDate: 07/21/2014 01:18:30.713 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_dnc_out](
	[DNCOutID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Phone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastContactDate] [datetime] NULL,
	[LastSaleDate] [datetime] NULL,
	[FileCreationDate] [datetime] NULL,
	[DNC] [bit] NULL,
	[DNCCode] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EBRExpiration] [datetime] NULL,
	[Sent] [bit] NULL,
	[LastUpdate] [datetime] NULL,
	[Timestamp] [datetime] NULL,
 CONSTRAINT [PK_DNC_OUT] PRIMARY KEY CLUSTERED
(
	[DNCOutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_dnc_out] ADD  CONSTRAINT [DF_DNC_OUT_DNC]  DEFAULT ((0)) FOR [DNC]
GO
ALTER TABLE [dbo].[cstd_dnc_out] ADD  CONSTRAINT [DF_DNC_OUT_Sent]  DEFAULT ((0)) FOR [Sent]
GO
ALTER TABLE [dbo].[cstd_dnc_out] ADD  CONSTRAINT [DF_DNC_OUT_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [dbo].[cstd_dnc_out] ADD  CONSTRAINT [DF_DNC_OUT_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO
