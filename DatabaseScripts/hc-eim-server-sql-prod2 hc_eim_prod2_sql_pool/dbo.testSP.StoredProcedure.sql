/****** Object:  StoredProcedure [dbo].[testSP]    Script Date: 3/1/2022 8:53:37 AM ******/
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
