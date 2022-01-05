/* CreateDate: 07/18/2016 07:45:10.710 , ModifyDate: 01/04/2022 10:56:36.737 */
GO
CREATE TABLE [dbo].[lkpEFTType](
	[EFTTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EFTTypeSortOrder] [int] NOT NULL,
	[EFTTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EFTTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpEFTType] PRIMARY KEY CLUSTERED
(
	[EFTTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpEFTType] ADD  DEFAULT ((1)) FOR [IsActiveFlag]
GO
