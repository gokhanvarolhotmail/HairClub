/* CreateDate: 01/13/2014 15:03:52.870 , ModifyDate: 03/04/2014 14:14:37.210 */
GO
CREATE TABLE [dbo].[tmpCeridian](
	[Last Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[First Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Home Department] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Depart#] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[eeEEnum] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Pay Period Start Date] [datetime] NULL,
	[Pay Period End Date] [datetime] NULL,
	[Check Date] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salary Hours] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Regular Hours] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OT Hours] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Double OT Hours] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PTO Hours] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bereavement Hours] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Jury Hours] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Travel Hours] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProcessedFlag] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpCeridian] ADD  CONSTRAINT [DF_tmpCeridian_IsProcessedFlag]  DEFAULT ((0)) FOR [IsProcessedFlag]
GO
