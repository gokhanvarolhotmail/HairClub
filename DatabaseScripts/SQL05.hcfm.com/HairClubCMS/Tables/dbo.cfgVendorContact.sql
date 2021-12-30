/* CreateDate: 05/05/2020 17:42:45.400 , ModifyDate: 05/05/2020 17:43:04.190 */
GO
CREATE TABLE [dbo].[cfgVendorContact](
	[VendorContactID] [int] NOT NULL,
	[VendorID] [int] NOT NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailMain] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAlternative] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactPhone] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactMobile] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactFax] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgVendorContact] PRIMARY KEY CLUSTERED
(
	[VendorContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
