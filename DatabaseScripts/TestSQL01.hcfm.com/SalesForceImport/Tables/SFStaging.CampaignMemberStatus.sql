/* CreateDate: 03/03/2022 13:54:33.757 , ModifyDate: 03/03/2022 22:19:14.790 */
GO
CREATE TABLE [SFStaging].[CampaignMemberStatus](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[CampaignId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Label] [varchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDefault] [bit] NULL,
	[HasResponded] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
 CONSTRAINT [pk_CampaignMemberStatus] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
