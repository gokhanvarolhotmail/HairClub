/****** Object:  StoredProcedure [dbo].[testSP]    Script Date: 2/22/2022 9:20:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[testSP] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT top 100 * from dbo.DimLead
END
GO
