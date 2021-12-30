/* CreateDate: 11/05/2015 14:40:04.667 , ModifyDate: 11/05/2015 14:40:28.503 */
GO
CREATE TABLE [dbo].[Canada_Lat_Long](
	[Country] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[District] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[District_Short] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL
) ON [PRIMARY]
GO
