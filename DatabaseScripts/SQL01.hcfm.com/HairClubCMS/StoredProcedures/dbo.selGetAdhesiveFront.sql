-- =============================================
-- Author:		rrojas
-- Create date: 27/08/2020
-- Description:	Get adhesive front attachments values TFS14594
-- =============================================
CREATE PROCEDURE selGetAdhesiveFront
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	select [AdhesiveFrontID]
      ,[AdhesiveFrontSortOrder]
      ,[AdhesiveFrontDescription]
      ,[AdhesiveFrontDescriptionShort]
      ,[IsActiveFlag]
      ,[CreateDate]
      ,[CreateUser]
      ,[LastUpdate]
      ,[LastUpdateUser]
      ,[UpdateStamp]
  FROM [dbo].[lkpAdhesiveFront] where IsActiveFlag=1
END
