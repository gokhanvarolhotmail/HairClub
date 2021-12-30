/* CreateDate: 08/18/2011 15:55:32.567 , ModifyDate: 08/18/2011 15:55:32.917 */
GO
CREATE TABLE [dbo].[DimSalespersonGroups](
	[SalesPersonGroupsId] [int] IDENTITY(1,1) NOT NULL,
	[Groups] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG1]
GO
