/* CreateDate: 03/09/2020 16:11:11.900 , ModifyDate: 03/09/2020 16:26:45.260 */
GO
CREATE TABLE [dbo].[tmpLFSFForecast](
	[DateAiredEST] [datetime] NULL,
	[TimeEST] [datetime] NULL,
	[Day] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Market] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Station] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumber] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
