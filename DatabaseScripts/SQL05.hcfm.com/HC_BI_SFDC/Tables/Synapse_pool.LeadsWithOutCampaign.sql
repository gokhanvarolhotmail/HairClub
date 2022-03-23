/* CreateDate: 03/21/2022 07:50:18.900 , ModifyDate: 03/21/2022 13:43:26.003 */
GO
CREATE TABLE [Synapse_pool].[LeadsWithOutCampaign](
	[ID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewCampaignId] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalIdCampaign] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]
GO
