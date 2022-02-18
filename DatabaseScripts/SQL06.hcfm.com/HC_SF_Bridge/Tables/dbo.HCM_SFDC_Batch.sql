/* CreateDate: 02/17/2022 13:35:42.960 , ModifyDate: 02/17/2022 13:35:42.960 */
GO
CREATE TABLE [dbo].[HCM_SFDC_Batch](
	[BatchID] [int] NOT NULL,
	[BatchStartDate] [datetime] NULL,
	[BatchEndDate] [datetime] NULL,
	[IsCompletedFlag] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
