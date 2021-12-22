/* CreateDate: 11/04/2019 13:27:49.063 , ModifyDate: 11/04/2019 13:27:49.063 */
GO
CREATE TABLE [dba].[HairSystemOrdersToProcessX](
	[HairSystemAllocationGUID] [uniqueidentifier] NOT NULL,
	[HairSystemAllocationDate] [datetime] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
