/****** Object:  StoredProcedure [dss].[RemoveObjectData]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
                    CREATE PROCEDURE [dss].[RemoveObjectData]਍                        䀀伀戀樀攀挀琀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
                        @DataType     INT = null,਍                        䀀刀攀洀漀瘀攀刀攀挀漀爀搀 䈀䤀吀 㴀 　ഀഀ
                    AS਍                    䈀䔀䜀䤀一ഀഀ
                        IF @RemoveRecord = 0਍                            唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀匀礀渀挀伀戀樀攀挀琀䐀愀琀愀崀 匀䔀吀 嬀䐀爀漀瀀瀀攀搀吀椀洀攀崀 㴀 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀ഀഀ
                                WHERE [ObjectId] = @ObjectId AND (@DataType IS NULL OR [DataType] = @DataType);਍                        䔀䰀匀䔀ഀഀ
                            DELETE FROM [dss].[SyncObjectData]਍                                圀䠀䔀刀䔀 嬀伀戀樀攀挀琀䤀搀崀 㴀 䀀伀戀樀攀挀琀䤀搀 䄀一䐀 ⠀䀀䐀愀琀愀吀礀瀀攀 䤀匀 一唀䰀䰀 伀刀 嬀䐀愀琀愀吀礀瀀攀崀 㴀 䀀䐀愀琀愀吀礀瀀攀⤀㬀ഀഀ
                    END਍䜀伀ഀഀ
