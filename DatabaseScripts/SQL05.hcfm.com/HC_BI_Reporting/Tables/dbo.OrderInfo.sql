/* CreateDate: 02/11/2019 16:53:15.340 , ModifyDate: 02/11/2019 16:53:15.340 */
GO
CREATE TABLE [dbo].[OrderInfo](
	[SubscriptionID] [int] NOT NULL,
	[Order] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileType] [bit] NULL,
	[Format] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED
(
	[SubscriptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
