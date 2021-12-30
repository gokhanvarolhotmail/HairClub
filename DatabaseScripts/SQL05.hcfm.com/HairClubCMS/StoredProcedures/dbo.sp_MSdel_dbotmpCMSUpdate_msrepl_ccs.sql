/* CreateDate: 02/27/2017 09:26:21.797 , ModifyDate: 02/27/2017 09:26:21.797 */
GO
create procedure [dbo].[sp_MSdel_dbotmpCMSUpdate_msrepl_ccs]
		@pkc1 int
as
begin
	delete [dbo].[tmpCMSUpdate]
where [CMSUpdateId] = @pkc1
end
GO
