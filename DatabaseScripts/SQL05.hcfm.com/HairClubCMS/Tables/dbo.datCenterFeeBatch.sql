/* CreateDate: 05/05/2020 17:42:46.850 , ModifyDate: 09/30/2021 19:29:55.303 */
GO
CREATE TABLE [dbo].[datCenterFeeBatch](
	[CenterFeeBatchGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NOT NULL,
	[FeePayCycleID] [int] NOT NULL,
	[FeeMonth] [int] NOT NULL,
	[FeeYear] [int] NOT NULL,
	[CenterFeeBatchStatusId] [int] NOT NULL,
	[RunDate] [datetime] NULL,
	[RunByEmployeeGUID] [uniqueidentifier] NULL,
	[DownloadDate] [datetime] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsExported] [int] NOT NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedByEmployeeGUID] [uniqueidentifier] NULL,
	[AreSalesOrdersCreated] [bit] NOT NULL,
	[IsMonetraProcessingCompleted] [bit] NOT NULL,
	[AreMonetraResultsProcessed] [bit] NOT NULL,
	[IsACHFileCreated] [bit] NOT NULL,
	[AreAccumulatorsExecuted] [bit] NOT NULL,
	[AreARPaymentsApplied] [bit] NOT NULL,
	[IsNACHAFileCreated] [bit] NOT NULL,
 CONSTRAINT [PK_datCenterFeeBatch] PRIMARY KEY CLUSTERED
(
	[CenterFeeBatchGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
