/* CreateDate: 01/03/2013 10:22:39.140 , ModifyDate: 01/03/2013 10:22:39.140 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[psoLog]
	@Message NVARCHAR(MAX), @ActivityId NCHAR(10) = NULL
AS
BEGIN
	INSERT INTO cstd_log (message, activity_id) VALUES (@Message, @ActivityId)
END
GO
