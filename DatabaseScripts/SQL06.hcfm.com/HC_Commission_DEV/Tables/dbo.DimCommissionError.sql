/* CreateDate: 10/05/2012 08:46:31.393 , ModifyDate: 10/05/2012 08:46:31.410 */
GO
CREATE TABLE [dbo].[DimCommissionError](
	[CommissionErrorID] [int] NULL,
	[SortOrder] [int] NULL,
	[CommissionTypeID] [int] NULL,
	[CommissionError] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommissionErrorShort] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
