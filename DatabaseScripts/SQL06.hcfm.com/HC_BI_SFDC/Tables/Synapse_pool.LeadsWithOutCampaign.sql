/* CreateDate: 03/21/2022 13:00:03.690 , ModifyDate: 03/21/2022 13:00:06.623 */
GO
CREATE TABLE [Synapse_pool].[LeadsWithOutCampaign](
	[ID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewCampaignId] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalIdCampaign] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]
GO
