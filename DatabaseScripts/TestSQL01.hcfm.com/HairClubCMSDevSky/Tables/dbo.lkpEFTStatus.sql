/* CreateDate: 08/27/2008 11:59:23.963 , ModifyDate: 12/29/2021 15:38:46.383 */
GO
CREATE TABLE [dbo].[lkpEFTStatus](
	[EFTStatusID] [int] NOT NULL,
	[EFTStatusSortOrder] [int] NOT NULL,
	[EFTStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EFTStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsCardDeclinedFlag] [bit] NULL,
	[IsEFTActiveFlag] [bit] NULL,
	[IsFrozenFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpEFTStatus] PRIMARY KEY CLUSTERED
(
	[EFTStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpEFTStatus] ADD  CONSTRAINT [DF_lkpEFTStatus_IsCardDeclinedFlag]  DEFAULT ((0)) FOR [IsCardDeclinedFlag]
GO
ALTER TABLE [dbo].[lkpEFTStatus] ADD  CONSTRAINT [DF_lkpEFTStatus_IsEFTActiveFlag]  DEFAULT ((0)) FOR [IsEFTActiveFlag]
GO
ALTER TABLE [dbo].[lkpEFTStatus] ADD  CONSTRAINT [DF_lkpEFTStatus_IsFrozenFlag]  DEFAULT ((0)) FOR [IsFrozenFlag]
GO
ALTER TABLE [dbo].[lkpEFTStatus] ADD  CONSTRAINT [DF_lkpEFTStatus_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
