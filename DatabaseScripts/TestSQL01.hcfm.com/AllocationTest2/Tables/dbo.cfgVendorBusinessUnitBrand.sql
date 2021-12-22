/* CreateDate: 10/31/2019 20:53:42.723 , ModifyDate: 11/01/2019 09:57:48.990 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgVendorBusinessUnitBrand](
	[VendorBusinessUnitBrandID] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NOT NULL,
	[BusinessUnitBrandID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[IsCenterReceivingEnabled] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
