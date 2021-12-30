/* CreateDate: 05/14/2012 17:35:19.497 , ModifyDate: 12/29/2021 15:38:46.257 */
GO
CREATE TABLE [dbo].[lkpFeeFreezeReason](
	[FeeFreezeReasonID] [int] NOT NULL,
	[FeeFreezeReasonSortOrder] [int] NOT NULL,
	[FeeFreezeReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FeeFreezeReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpFeeFreezeReason] PRIMARY KEY CLUSTERED
(
	[FeeFreezeReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpFeeFreezeReason] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
