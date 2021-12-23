/* CreateDate: 03/05/2018 07:05:56.970 , ModifyDate: 03/05/2018 07:05:57.147 */
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
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgVendorBusinessUnitBrand] PRIMARY KEY CLUSTERED
(
	[VendorBusinessUnitBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgVendorBusinessUnitBrand]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgVendorBusinessUnitBrand_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgVendorBusinessUnitBrand] CHECK CONSTRAINT [FK_cfgVendorBusinessUnitBrand_cfgVendor]
GO
ALTER TABLE [dbo].[cfgVendorBusinessUnitBrand]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgVendorBusinessUnitBrand_lkpBusinessUnitBrand] FOREIGN KEY([BusinessUnitBrandID])
REFERENCES [dbo].[lkpBusinessUnitBrand] ([BusinessUnitBrandID])
GO
ALTER TABLE [dbo].[cfgVendorBusinessUnitBrand] CHECK CONSTRAINT [FK_cfgVendorBusinessUnitBrand_lkpBusinessUnitBrand]
GO
