/* CreateDate: 07/06/2011 17:22:52.050 , ModifyDate: 07/06/2011 17:22:52.143 */
GO
CREATE TABLE [dbo].[CampaignNames](
	[CampaignID] [int] IDENTITY(1,1) NOT NULL,
	[CampaignName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateCreated] [smalldatetime] NULL,
	[CreatedBy] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ListID] [int] NULL,
	[CampaignDescription] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_Centers] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_Regions] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_ResultStartDate] [smalldatetime] NULL,
	[Param_ResultEndDate] [smalldatetime] NULL,
	[Param_ShowStartDate] [smalldatetime] NULL,
	[Param_ShowEndDate] [smalldatetime] NULL,
	[Param_Gender] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_GenderID] [tinyint] NULL,
	[Param_Member1] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_CancelStartDate] [smalldatetime] NULL,
	[Param_CancelEndDate] [smalldatetime] NULL,
	[Param_SurStartDate] [smalldatetime] NULL,
	[Param_SurEndDate] [smalldatetime] NULL,
	[Param_SurpostStartDate] [smalldatetime] NULL,
	[Param_SurpostEndDate] [smalldatetime] NULL,
	[Param_DoNotMail] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_DoNotEmail] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_DoNotCall] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_DoNotContact] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_LeadCreationStartDate] [smalldatetime] NULL,
	[Param_LeadCreationEndDate] [smalldatetime] NULL,
	[Param_MembershipBeginStartDate] [smalldatetime] NULL,
	[Param_MembershipBeginEndDate] [smalldatetime] NULL,
	[Param_MembershipExpStartDate] [smalldatetime] NULL,
	[Param_MembershipExpEndDate] [smalldatetime] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Param_BeBacks] [bit] NULL,
	[Param_NoSaleReason] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Param_CancelReasonIDs] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_CampaignID] PRIMARY KEY CLUSTERED
(
	[CampaignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
