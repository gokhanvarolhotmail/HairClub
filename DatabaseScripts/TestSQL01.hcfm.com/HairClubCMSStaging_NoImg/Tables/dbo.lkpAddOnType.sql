/* CreateDate: 04/24/2017 08:10:29.220 , ModifyDate: 12/28/2021 09:20:54.623 */
GO
CREATE TABLE [dbo].[lkpAddOnType](
	[AddOnTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AddOnTypeSortOrder] [int] NOT NULL,
	[AddOnTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AddOnTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsMonthlyAddOnType] [bit] NOT NULL,
 CONSTRAINT [PK_lkpAddOnTypeID] PRIMARY KEY CLUSTERED
(
	[AddOnTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAddOnType] ADD  DEFAULT ((0)) FOR [IsMonthlyAddOnType]
GO
