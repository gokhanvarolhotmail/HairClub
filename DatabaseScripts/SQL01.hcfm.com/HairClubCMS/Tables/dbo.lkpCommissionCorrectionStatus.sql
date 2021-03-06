/* CreateDate: 02/24/2015 07:35:34.640 , ModifyDate: 05/26/2020 10:49:01.380 */
GO
CREATE TABLE [dbo].[lkpCommissionCorrectionStatus](
	[CommissionCorrectionStatusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CommissionCorrectionStatusSortOrder] [int] NOT NULL,
	[CommissionCorrectionStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CommissionCorrectionStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpCommissionCorrectionStatus] PRIMARY KEY CLUSTERED
(
	[CommissionCorrectionStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
