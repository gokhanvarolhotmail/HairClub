/* CreateDate: 03/14/2013 10:12:32.527 , ModifyDate: 03/14/2013 10:12:32.710 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimPayrollExport](
	[ExportID] [int] IDENTITY(1,1) NOT NULL,
	[CountryRegionDescriptionShort] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PayPeriodKey] [int] NOT NULL,
	[ExportDate] [datetime] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
