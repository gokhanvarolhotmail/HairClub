/* CreateDate: 05/05/2020 17:42:53.497 , ModifyDate: 05/05/2020 18:28:46.927 */
GO
CREATE TABLE [dbo].[datTechnicalProfileXtrands](
	[TechnicalProfileXtrandsID] [int] NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[LastTrichoViewDate] [datetime] NULL,
	[LastXtrandsServiceDate] [datetime] NULL,
	[HairStrandGroupID] [int] NULL,
	[HairHealthID] [int] NULL,
	[LaserDeviceSalesCodeID] [int] NULL,
	[ShampooSalesCodeID] [int] NULL,
	[ConditionerSalesCodeID] [int] NULL,
	[Other] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsMinoxidilUsed] [bit] NULL,
	[MinoxidilSalesCodeID] [int] NULL,
	[ServiceDuration] [int] NULL,
	[ServiceTimeUnitID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[Strands] [int] NULL,
	[OtherServiceSalesCodeID] [int] NULL,
	[OtherServiceDuration] [int] NULL,
	[OtherServiceTimeUnitID] [int] NULL,
 CONSTRAINT [PK_datTechnicalProfileXtrands] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileXtrandsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [UK_datTechnicalProfileXtrands_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
