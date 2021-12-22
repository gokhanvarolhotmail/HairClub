/* CreateDate: 10/04/2010 12:08:45.140 , ModifyDate: 05/26/2020 10:49:22.910 */
GO
CREATE TABLE [dbo].[lkpVendorType](
	[VendorTypeID] [int] NOT NULL,
	[VendorTypeSortOrder] [int] NOT NULL,
	[VendorTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[VendorTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpVendorType] PRIMARY KEY CLUSTERED
(
	[VendorTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpVendorType] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
