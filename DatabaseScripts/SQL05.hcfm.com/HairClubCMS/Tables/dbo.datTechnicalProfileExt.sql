/* CreateDate: 05/05/2020 17:42:52.680 , ModifyDate: 05/05/2020 18:28:46.640 */
GO
CREATE TABLE [dbo].[datTechnicalProfileExt](
	[TechnicalProfileExtID] [int] NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[LastTrichoViewDate] [datetime] NULL,
	[LastExtServiceDate] [datetime] NULL,
	[HairHealthID] [int] NULL,
	[ScalpHealthID] [int] NULL,
	[CleanserUsedSalesCodeID] [int] NULL,
	[ElixirFormulation] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MassagePressureID] [int] NULL,
	[LaserDeviceSalesCodeID] [int] NULL,
	[CleanserSalesCodeID] [int] NULL,
	[ConditionerSalesCodeID] [int] NULL,
	[IsMinoxidilUsed] [bit] NULL,
	[MinoxidilSalesCodeID] [int] NULL,
	[IsScalpEnzymeCleanserUsed] [bit] NULL,
	[Other] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceDuration] [int] NULL,
	[ServiceTimeUnitID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsSurgeryClient] [bit] NULL,
	[GraftCount] [int] NULL,
	[LastSurgeryDate] [datetime] NULL,
	[OtherServiceSalesCodeID] [int] NULL,
	[OtherServiceDuration] [int] NULL,
	[OtherServiceTimeUnitID] [int] NULL,
 CONSTRAINT [PK_datTechnicalProfileExt] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileExtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [UK_datTechnicalProfileExt_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
