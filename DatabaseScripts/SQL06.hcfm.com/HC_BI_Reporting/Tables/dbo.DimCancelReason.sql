CREATE TABLE [dbo].[DimCancelReason](
	[CancelReasonID] [int] NOT NULL,
	[MembershipCode] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CancelReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
