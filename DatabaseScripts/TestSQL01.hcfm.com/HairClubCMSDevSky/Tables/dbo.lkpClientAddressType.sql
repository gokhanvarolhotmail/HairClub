/* CreateDate: 05/14/2012 17:29:33.130 , ModifyDate: 12/29/2021 15:38:46.107 */
GO
CREATE TABLE [dbo].[lkpClientAddressType](
	[ClientAddressTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientAddressTypeSortOrder] [int] NOT NULL,
	[ClientAddressTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientAddressTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpClientAddressType] PRIMARY KEY NONCLUSTERED
(
	[ClientAddressTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpClientAddressType] ADD  CONSTRAINT [DF_lkpClientAddressType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
