/* CreateDate: 07/02/2021 16:55:39.217 , ModifyDate: 07/02/2021 16:55:39.217 */
GO
CREATE TABLE [Synapse_pool].[LeadsWithOutCampaign](
	[ID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewCampaignId] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalIdCampaign] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]
GO
