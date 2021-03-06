/* CreateDate: 08/27/2008 11:40:01.593 , ModifyDate: 03/04/2022 16:09:12.790 */
GO
CREATE TABLE [dbo].[lkpEFTAccountType](
	[EFTAccountTypeID] [int] NOT NULL,
	[EFTAccountTypeSortOrder] [int] NOT NULL,
	[EFTAccountTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EFTAccountTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpEFTAccountType] PRIMARY KEY CLUSTERED
(
	[EFTAccountTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpEFTAccountType] ADD  CONSTRAINT [DF_lkpEFTAccountType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
