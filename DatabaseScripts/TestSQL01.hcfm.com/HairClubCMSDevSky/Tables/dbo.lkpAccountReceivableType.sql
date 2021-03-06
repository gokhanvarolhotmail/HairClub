/* CreateDate: 05/14/2012 17:33:38.780 , ModifyDate: 12/29/2021 15:38:46.093 */
GO
CREATE TABLE [dbo].[lkpAccountReceivableType](
	[AccountReceivableTypeID] [int] NOT NULL,
	[AccountReceivableTypeSortOrder] [int] NOT NULL,
	[AccountReceivableTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccountReceivableTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsCreditFlag] [bit] NOT NULL,
 CONSTRAINT [PK_lkpAccountReceivableType] PRIMARY KEY CLUSTERED
(
	[AccountReceivableTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAccountReceivableType] ADD  DEFAULT ((0)) FOR [IsCreditFlag]
GO
