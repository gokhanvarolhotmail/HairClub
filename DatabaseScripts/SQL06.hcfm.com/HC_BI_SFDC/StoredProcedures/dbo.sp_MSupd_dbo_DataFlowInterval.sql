/* CreateDate: 10/04/2019 14:09:30.133 , ModifyDate: 10/04/2019 14:09:30.133 */
GO
create procedure [sp_MSupd_dbo_DataFlowInterval]
		@c1 int = NULL,
		@c2 varchar(50) = NULL,
		@c3 int = NULL,
		@c4 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[_DataFlowInterval] set
		[IntervalType] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [IntervalType] end,
		[Interval] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Interval] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [IsActiveFlag] end
	where [DataFlowIntervalKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DataFlowIntervalKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[_DataFlowInterval]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
