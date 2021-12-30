/* CreateDate: 05/05/2020 17:42:54.770 , ModifyDate: 05/05/2020 17:42:54.770 */
GO
create procedure [sp_MSupd_dbolkpPhotoLens]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 bit = NULL,
		@c6 datetime = NULL,
		@c7 nvarchar(25) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 int = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 nvarchar(100) = NULL,
		@c13 float = NULL,
		@c14 float = NULL,
		@c15 nvarchar(100) = NULL,
		@c16 nvarchar(4000) = NULL,
		@c17 nvarchar(100) = NULL,
		@c18 nvarchar(100) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[lkpPhotoLens] set
		[PhotoLensSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [PhotoLensSortOrder] end,
		[PhotoLensDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [PhotoLensDescription] end,
		[PhotoLensDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [PhotoLensDescriptionShort] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end,
		[Size] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Size] end,
		[Units] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Units] end,
		[Model] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Model] end,
		[FOVX] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [FOVX] end,
		[FOVY] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [FOVY] end,
		[Manufacturer] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Manufacturer] end,
		[HelpText] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [HelpText] end,
		[DescriptionResourceKey] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [DescriptionResourceKey] end,
		[HelpTextResourceKey] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [HelpTextResourceKey] end
	where [PhotoLensID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[PhotoLensID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpPhotoLens]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
