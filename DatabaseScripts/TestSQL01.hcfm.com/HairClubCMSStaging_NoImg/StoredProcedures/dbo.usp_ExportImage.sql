/* CreateDate: 01/05/2022 11:48:54.597 , ModifyDate: 01/05/2022 11:54:27.013 */
GO
CREATE PROCEDURE dbo.usp_ExportImage (
	@ImageFolderPath NVARCHAR(1000)
   ,@Filename NVARCHAR(1000)
   ,@apptPhotoGUID NVARCHAR(200)
   )
AS
BEGIN
   DECLARE @ImageData VARBINARY (max);
   DECLARE @Path2OutFile NVARCHAR (2000);
   DECLARE @Obj INT

   SET NOCOUNT ON

   SELECT @ImageData = (
         SELECT convert (VARBINARY (max), AppointmentPhoto, 1)
         FROM datAppointmentPhoto
		 where AppointmentPhotoGUID = @apptPhotoGUID
         );

   SET @Path2OutFile = CONCAT (
         @ImageFolderPath
         ,'\'
         , @Filename
         );
    BEGIN TRY
     EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
     EXEC sp_OASetProperty @Obj ,'Type',1;
     EXEC sp_OAMethod @Obj,'Open';
     EXEC sp_OAMethod @Obj,'Write', NULL, @ImageData;
     EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
     EXEC sp_OAMethod @Obj,'Close';
     --EXEC sp_OADestroy @Obj;
    END TRY

 BEGIN CATCH
  --EXEC sp_OADestroy @Obj;
 END CATCH

   SET NOCOUNT OFF
END
GO
