/* CreateDate: 07/21/2016 14:24:56.550 , ModifyDate: 07/21/2016 14:24:56.550 */
GO
CREATE TABLE [dbo].[lkpMosaicGroup](
	[MosaicGroupID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MosaicGroupDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IndividualPercentage] [numeric](3, 2) NULL,
	[HouseholdPercentage] [numeric](3, 2) NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_lkpMosaicGroup] PRIMARY KEY CLUSTERED
(
	[MosaicGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
