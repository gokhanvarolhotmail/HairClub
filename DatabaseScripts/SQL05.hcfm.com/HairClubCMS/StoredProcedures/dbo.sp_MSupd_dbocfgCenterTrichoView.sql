/* CreateDate: 05/05/2020 17:42:41.187 , ModifyDate: 05/05/2020 17:42:41.187 */
GO
create procedure [sp_MSupd_dbocfgCenterTrichoView]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 bit = NULL,
		@c4 bit = NULL,
		@c5 bit = NULL,
		@c6 bit = NULL,
		@c7 bit = NULL,
		@c8 bit = NULL,
		@c9 bit = NULL,
		@c10 bit = NULL,
		@c11 bit = NULL,
		@c12 bit = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(25) = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 bit = NULL,
		@c18 bit = NULL,
		@c19 bit = NULL,
		@c20 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgCenterTrichoView] set
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[IsProfileAvailable] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [IsProfileAvailable] end,
		[IsScalpAvailable] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [IsScalpAvailable] end,
		[IsScopeAvailable] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsScopeAvailable] end,
		[IsDensityAvailable] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [IsDensityAvailable] end,
		[IsWidthAvailable] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsWidthAvailable] end,
		[IsScaleAvailable] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsScaleAvailable] end,
		[IsHealthAvailable] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsHealthAvailable] end,
		[IsHMIAvailable] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsHMIAvailable] end,
		[IsSurveyAvailable] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsSurveyAvailable] end,
		[IsTrichoViewReportAvailable] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsTrichoViewReportAvailable] end,
		[CreateDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdateUser] end,
		[IsImageEditorAvailable] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [IsImageEditorAvailable] end,
		[IsSebumAvailable] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsSebumAvailable] end,
		[IsScalpHealthAvailable] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsScalpHealthAvailable] end,
		[IsHighResUploadAvailable] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsHighResUploadAvailable] end
	where [CenterTrichoViewID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterTrichoViewID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgCenterTrichoView]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
