/* CreateDate: 02/24/2015 07:35:34.547 , ModifyDate: 03/04/2022 16:09:12.517 */
GO
CREATE TABLE [dbo].[lkpCommissionPlanSection](
	[CommissionPlanSectionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CommissionPlanSectionSortOrder] [int] NOT NULL,
	[CommissionPlanSectionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CommissionPlanSectionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpCommissionPlanSection] PRIMARY KEY CLUSTERED
(
	[CommissionPlanSectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
