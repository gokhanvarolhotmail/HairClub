/* CreateDate: 04/30/2019 10:44:31.487 , ModifyDate: 04/30/2019 10:44:31.487 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpOutput](
	[CenterNumber] [int] NULL,
	[CenterDescriptionNumber] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MainGroupKey] [int] NULL,
	[MainGroupDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MainGroupSortOrder] [int] NULL,
	[ClientIdentifier] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientLastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientFirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOrderDetailKey] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FullDate] [smalldatetime] NULL,
	[SalesCodeDescriptionShort] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDescription] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[qty] [int] NULL,
	[ExtendedPrice] [decimal](18, 4) NULL,
	[Tax1] [decimal](18, 4) NULL,
	[Tax2] [decimal](18, 4) NULL,
	[Consultant] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CancelReasonDescription] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDepartmentSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Stylist] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Voided] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMembershipKey] [int] NULL,
	[NB_GrossNB1Cnt] [int] NULL,
	[NB_TradCnt] [int] NULL,
	[NB_TradAmt] [decimal](18, 4) NULL,
	[NB_GradCnt] [int] NULL,
	[NB_GradAmt] [decimal](18, 4) NULL,
	[NB_ExtCnt] [int] NULL,
	[NB_ExtAmt] [decimal](18, 4) NULL,
	[NB_XtrCnt] [int] NULL,
	[NB_XtrAmt] [decimal](18, 4) NULL,
	[S_SurCnt] [int] NULL,
	[S_PostExtCnt] [int] NULL,
	[S_PostExtAmt] [decimal](18, 4) NULL,
	[NB_AppsCnt] [int] NULL,
	[NB_BIOConvCnt] [int] NULL,
	[NB_MDPCnt] [int] NULL,
	[NB_MDPAmt] [decimal](18, 4) NULL,
	[NB_NetNBCnt] [int] NULL,
	[NB_NetNBAmt] [decimal](18, 4) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
