/* CreateDate: 05/05/2020 17:42:55.183 , ModifyDate: 05/05/2020 17:42:55.183 */
GO
create procedure [sp_MSins_dbolkpSalesCodeImage]
    @c1 nvarchar(25),
    @c2 image,
    @c3 int,
    @c4 datetime,
    @c5 nvarchar(25),
    @c6 datetime,
    @c7 nvarchar(25)
as
begin
	insert into [dbo].[lkpSalesCodeImage] (
		[SalesCodeID],
		[SalesCodeImage],
		[PhotoCaptionID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		default	)
end
GO
