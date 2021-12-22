CREATE TABLE [dbo].[cfgCenterDistributorJoin](
	[CenterDistributorId] [int] IDENTITY(1,1) NOT NULL,
	[CenterId] [int] NOT NULL,
	[DistributorId] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NULL,
PRIMARY KEY CLUSTERED
(
	[CenterDistributorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterDistributorJoin]  WITH CHECK ADD FOREIGN KEY([CenterId])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenterDistributorJoin]  WITH CHECK ADD FOREIGN KEY([DistributorId])
REFERENCES [dbo].[cfgCenter] ([CenterID])
