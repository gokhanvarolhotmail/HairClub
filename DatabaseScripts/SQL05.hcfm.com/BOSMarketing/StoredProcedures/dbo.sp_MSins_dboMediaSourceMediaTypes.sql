/* CreateDate: 07/30/2015 15:49:41.993 , ModifyDate: 07/30/2015 15:49:41.993 */
GO
create procedure [sp_MSins_dboMediaSourceMediaTypes]
    @c1 smallint,
    @c2 varchar(50),
    @c3 varchar(50)
as
begin
	insert into [dbo].[MediaSourceMediaTypes](
		[MediaID],
		[MediaCode],
		[Media]
	) values (
    @c1,
    @c2,
    @c3	)
end
GO
