/* CreateDate: 01/28/2009 16:12:57.067 , ModifyDate: 12/07/2021 16:20:16.163 */
GO
CREATE TABLE [dbo].[lkpPhoneType](
	[PhoneTypeID] [int] NOT NULL,
	[PhoneTypeSortOrder] [int] NOT NULL,
	[PhoneTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhoneTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[CanTextMessageFlag] [bit] NULL,
	[PhoneSegmentId] [int] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpPhoneType] PRIMARY KEY CLUSTERED
(
	[PhoneTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpPhoneType] ADD  CONSTRAINT [DF_lkpPhoneType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpPhoneType]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpPhoneType_lkpPhoneSegment] FOREIGN KEY([PhoneSegmentId])
REFERENCES [dbo].[lkpPhoneSegment] ([PhoneSegmentID])
GO
ALTER TABLE [dbo].[lkpPhoneType] CHECK CONSTRAINT [FK_lkpPhoneType_lkpPhoneSegment]
GO
ALTER TABLE [dbo].[lkpPhoneType]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpPhoneType_lkpPhoneType] FOREIGN KEY([PhoneTypeID])
REFERENCES [dbo].[lkpPhoneType] ([PhoneTypeID])
GO
ALTER TABLE [dbo].[lkpPhoneType] CHECK CONSTRAINT [FK_lkpPhoneType_lkpPhoneType]
GO
