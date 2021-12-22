/* CreateDate: 08/27/2012 08:40:09.657 , ModifyDate: 12/03/2021 10:24:48.587 */
GO
CREATE TABLE [dbo].[lkpPhoneSegment](
	[PhoneSegmentID] [int] NOT NULL,
	[PhoneSegmentSortOrder] [int] NOT NULL,
	[PhoneSegmentDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhoneSegmentDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpPhoneSegment] PRIMARY KEY CLUSTERED
(
	[PhoneSegmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpPhoneSegment]  WITH CHECK ADD  CONSTRAINT [FK_lkpPhoneSegment_lkpPhoneSegment] FOREIGN KEY([PhoneSegmentID])
REFERENCES [dbo].[lkpPhoneSegment] ([PhoneSegmentID])
GO
ALTER TABLE [dbo].[lkpPhoneSegment] CHECK CONSTRAINT [FK_lkpPhoneSegment_lkpPhoneSegment]
GO
