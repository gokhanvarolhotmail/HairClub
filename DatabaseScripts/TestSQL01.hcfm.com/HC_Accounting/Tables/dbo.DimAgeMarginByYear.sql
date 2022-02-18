/* CreateDate: 07/29/2013 10:02:55.317 , ModifyDate: 07/29/2013 10:07:17.133 */
GO
CREATE TABLE [dbo].[DimAgeMarginByYear](
	[AgeDescription] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeLow] [int] NULL,
	[AgeHigh] [int] NULL,
	[AgeID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
