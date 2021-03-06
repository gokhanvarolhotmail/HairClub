/* CreateDate: 02/26/2017 22:35:10.167 , ModifyDate: 02/27/2017 11:58:09.603 */
GO
CREATE TABLE [dbo].[lkpMassagePressure](
	[MassagePressureID] [int] IDENTITY(1,1) NOT NULL,
	[MassagePressureSortOrder] [int] NOT NULL,
	[MassagePressureDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MassagePressureDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpMassagePressure] PRIMARY KEY CLUSTERED
(
	[MassagePressureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
