/* CreateDate: 05/05/2020 17:42:46.953 , ModifyDate: 05/05/2020 17:43:06.057 */
GO
CREATE TABLE [dbo].[datCenterDeclineBatch](
	[CenterDeclineBatchGUID] [uniqueidentifier] NOT NULL,
	[CenterFeeBatchGUID] [uniqueidentifier] NOT NULL,
	[RunDate] [datetime] NULL,
	[RunByEmployeeGUID] [uniqueidentifier] NULL,
	[IsCompletedFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsExported] [int] NOT NULL,
	[CenterDeclineBatchStatusID] [int] NOT NULL,
 CONSTRAINT [PK_datCenterDeclineBatch] PRIMARY KEY CLUSTERED
(
	[CenterDeclineBatchGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
