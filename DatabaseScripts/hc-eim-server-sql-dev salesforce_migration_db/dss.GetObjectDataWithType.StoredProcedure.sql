/****** Object:  StoredProcedure [dss].[GetObjectDataWithType]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
                    CREATE PROCEDURE [dss].[GetObjectDataWithType]਍                        䀀伀戀樀攀挀琀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
                        @DataType INT਍                    䄀匀ഀഀ
                    BEGIN਍                        匀䔀䰀䔀䌀吀 嬀伀戀樀攀挀琀䤀搀崀ഀഀ
                            ,[CreatedTime]਍                            Ⰰ嬀䐀爀漀瀀瀀攀搀吀椀洀攀崀ഀഀ
                            ,[LastModified]਍                            Ⰰ嬀伀戀樀攀挀琀䐀愀琀愀崀ഀഀ
                        FROM [dss].[SyncObjectData]਍                        圀䠀䔀刀䔀 嬀伀戀樀攀挀琀䤀搀崀 㴀 䀀伀戀樀攀挀琀䤀搀 䄀一䐀 嬀䐀愀琀愀吀礀瀀攀崀 㴀 䀀䐀愀琀愀吀礀瀀攀 䄀一䐀 嬀䐀爀漀瀀瀀攀搀吀椀洀攀崀 䤀匀 一唀䰀䰀ഀഀ
                    END਍䜀伀ഀഀ
