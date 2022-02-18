/* CreateDate: 08/27/2008 11:26:10.147 , ModifyDate: 01/31/2022 08:32:31.773 */
GO
CREATE TABLE [dbo].[lkpAdhesiveFront](
	[AdhesiveFrontID] [int] NOT NULL,
	[AdhesiveFrontSortOrder] [int] NOT NULL,
	[AdhesiveFrontDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AdhesiveFrontDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAdhesiveFront] PRIMARY KEY CLUSTERED
(
	[AdhesiveFrontID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAdhesiveFront] ADD  CONSTRAINT [DF_lkpAdhesiveFront_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
