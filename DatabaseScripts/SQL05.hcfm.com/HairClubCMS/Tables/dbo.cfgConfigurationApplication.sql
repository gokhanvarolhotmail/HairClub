/* CreateDate: 05/05/2020 17:42:41.220 , ModifyDate: 05/05/2020 17:42:59.897 */
GO
CREATE TABLE [dbo].[cfgConfigurationApplication](
	[ConfigurationApplicationID] [int] NOT NULL,
	[Version32ReleaseDate] [date] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[Version41ReleaseDate] [date] NOT NULL,
	[ScheduleCreateRange] [int] NULL,
	[HairSystemOrderCounter] [int] NOT NULL,
	[HairSystemOrderMaximumDaysInFuture] [int] NOT NULL,
	[AccountingExportBatchCounter] [int] NOT NULL,
	[AccountingExportDefaultPath] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemTurnaroundDaysRange1] [int] NOT NULL,
	[HairSystemTurnaroundDaysRange2] [int] NOT NULL,
	[HairSystemTurnaroundDaysRange3] [int] NOT NULL,
	[HairSystemTurnaroundLongHairExtraDays] [int] NOT NULL,
	[HairSystemTurnaroundLongHairLength] [int] NOT NULL,
	[AccountingExportReceiveAPVarianceGLNumber] [int] NULL,
	[AccountingExportReceiveAPCreditGLNumber] [int] NULL,
	[LastUpdateClientEFT] [datetime] NULL,
	[MonetraProcessingBufferInMinutes] [int] NOT NULL,
	[SalesConsultationDayBuffer] [int] NOT NULL,
	[NumberOfRefundMonths] [int] NOT NULL,
	[PhotoQuality] [int] NOT NULL,
	[IsPreviousConsultationWarningEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_cfgConfigurationApplication] PRIMARY KEY CLUSTERED
(
	[ConfigurationApplicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
