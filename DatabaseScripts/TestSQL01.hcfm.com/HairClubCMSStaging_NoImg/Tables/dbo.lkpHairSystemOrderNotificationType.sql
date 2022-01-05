/* CreateDate: 10/04/2010 12:08:46.187 , ModifyDate: 01/04/2022 10:56:36.840 */
GO
CREATE TABLE [dbo].[lkpHairSystemOrderNotificationType](
	[HairSystemOrderNotificationTypeID] [int] NOT NULL,
	[HairSystemOrderNotificationTypeSortOrder] [int] NOT NULL,
	[HairSystemOrderNotificationTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderNotificationTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemOrderNotificationType] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderNotificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderNotificationType] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
