/* CreateDate: 11/04/2019 10:16:49.880 , ModifyDate: 11/04/2019 10:16:49.880 */
GO
CREATE TABLE [dba].[HairSystemOrdersToProcess](
	[HairSystemAllocationGUID] [uniqueidentifier] NOT NULL,
	[HairSystemAllocationDate] [datetime] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
