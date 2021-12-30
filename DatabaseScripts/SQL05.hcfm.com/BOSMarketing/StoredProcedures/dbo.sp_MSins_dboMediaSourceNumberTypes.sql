/* CreateDate: 07/30/2015 15:49:42.030 , ModifyDate: 07/30/2015 15:49:42.030 */
GO
create procedure [sp_MSins_dboMediaSourceNumberTypes]
    @c1 tinyint,
    @c2 varchar(50)
as
begin
	insert into [dbo].[MediaSourceNumberTypes](
		[NumberTypeID],
		[NumberType]
	) values (
    @c1,
    @c2	)
end
GO
