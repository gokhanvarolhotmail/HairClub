/* CreateDate: 01/03/2014 07:07:46.457 , ModifyDate: 01/03/2014 07:07:46.457 */
GO
CREATE PROCEDURE [core].[sp_stop_purge]
AS
BEGIN
    INSERT INTO [core].[purge_info_internal] (stop_purge) VALUES (1)
END
GO
