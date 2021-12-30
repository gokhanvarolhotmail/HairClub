/* CreateDate: 05/05/2020 17:42:45.940 , ModifyDate: 05/05/2020 17:43:04.993 */
GO
CREATE TABLE [dbo].[lkpChargeDecision](
	[ChargeDecisionID] [int] NOT NULL,
	[ChargeDecisionSortOrder] [int] NOT NULL,
	[ChargeDecisionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ChargeDecisionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsCreditApproved] [bit] NULL,
	[VendorID] [int] NULL,
 CONSTRAINT [PK_lkpCreditDecision] PRIMARY KEY CLUSTERED
(
	[ChargeDecisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
