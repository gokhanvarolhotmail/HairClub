/* CreateDate: 04/26/2018 09:34:34.390 , ModifyDate: 04/26/2018 09:34:34.390 */
GO
create procedure [dbo].[sp_MSupd_dboSolutionsOffered]     @c1 varchar(50) = NULL,     @c2 varchar(50) = NULL,     @c3 int = NULL,     @c4 int = NULL,     @c5 nvarchar(10) = NULL,     @pkc1 varchar(50) = NULL,     @bitmap binary(1)
as
begin   if (substring(@bitmap,1,1) & 1 = 1)
begin  update [dbo].[SolutionsOffered] set     [SolutionsCode] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [SolutionsCode] end,     [Description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Description] end,     [Active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Active] end,     [SortOrder] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SortOrder] end,     [BusinessUnitBrandDescriptionShort] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [BusinessUnitBrandDescriptionShort] end
where [SolutionsCode] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end   else
begin  update [dbo].[SolutionsOffered] set     [Description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Description] end,     [Active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Active] end,     [SortOrder] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SortOrder] end,     [BusinessUnitBrandDescriptionShort] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [BusinessUnitBrandDescriptionShort] end
where [SolutionsCode] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end  end   --
GO
