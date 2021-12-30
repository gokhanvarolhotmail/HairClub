/* CreateDate: 04/06/2021 11:38:32.697 , ModifyDate: 04/06/2021 11:38:32.697 */
GO
CREATE TABLE [dbo].[CampaignMemberStatus](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[CampaignId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Label] [nvarchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [int] NULL,
	[IsDefault] [bit] NULL,
	[HasResponded] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime] NULL
) ON [PRIMARY]
GO
