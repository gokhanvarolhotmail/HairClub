/* CreateDate: 01/09/2009 09:39:53.977 , ModifyDate: 06/14/2009 09:00:08.447 */
GO
CREATE TABLE [dbo].[CampaignListTypes](
	[ListID] [int] IDENTITY(1,1) NOT NULL,
	[ListName] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ListDescription] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateCreated] [smalldatetime] NULL,
	[CreatedBy] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ListTypeID] PRIMARY KEY CLUSTERED
(
	[ListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
