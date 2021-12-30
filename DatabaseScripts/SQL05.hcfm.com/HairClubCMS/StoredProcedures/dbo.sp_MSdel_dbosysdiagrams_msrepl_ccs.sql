/* CreateDate: 02/27/2017 09:49:55.800 , ModifyDate: 02/27/2017 09:49:55.800 */
GO
create procedure [dbo].[sp_MSdel_dbosysdiagrams_msrepl_ccs]
		@pkc1 int
as
begin
	delete [dbo].[sysdiagrams]
where [diagram_id] = @pkc1
end
GO
