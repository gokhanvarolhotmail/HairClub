/* CreateDate: 10/03/2019 23:03:42.823 , ModifyDate: 10/03/2019 23:03:42.823 */
GO
CREATE PROCEDURE [bief_dds].[_DBErrorLog_TagValueList] (
      @List    varchar(1000) OUTPUT
    , @Tag1    varchar(64)  = NULL
    , @Value1  varchar(64)  = NULL
    , @Tag2    varchar(64)  = NULL
    , @Value2  varchar(64)  = NULL
    , @Tag3    varchar(64)  = NULL
    , @Value3  varchar(64)  = NULL
    , @Tag4    varchar(64)  = NULL
    , @Value4  varchar(64)  = NULL
    , @Tag5    varchar(64)  = NULL
    , @Value5  varchar(64)  = NULL
    , @Tag6    varchar(64)  = NULL
    , @Value6  varchar(64)  = NULL
    , @Tag7    varchar(64)  = NULL
    , @Value7  varchar(64)  = NULL
    , @Tag8    varchar(64)  = NULL
    , @Value8  varchar(64)  = NULL
    , @Tag9    varchar(64)  = NULL
    , @Value9  varchar(64)  = NULL
    , @Tag10   varchar(64)  = NULL
    , @Value10 varchar(64)  = NULL
    , @Tag11   varchar(64)  = NULL
    , @Value11 varchar(64)  = NULL
    , @Tag12   varchar(64)  = NULL
    , @Value12 varchar(64)  = NULL
    , @Tag13   varchar(64)  = NULL
    , @Value13 varchar(64)  = NULL
    , @Tag14   varchar(64)  = NULL
    , @Value14 varchar(64)  = NULL
    , @Tag15   varchar(64)  = NULL
    , @Value15 varchar(64)  = NULL
    , @Tag16   varchar(64)  = NULL
    , @Value16 varchar(64)  = NULL
    , @Tag17   varchar(64)  = NULL
    , @Value17 varchar(64)  = NULL
    , @Tag18   varchar(64)  = NULL
    , @Value18 varchar(64)  = NULL
    , @Tag19   varchar(64)  = NULL
    , @Value19 varchar(64)  = NULL
    , @Tag20   varchar(64)  = NULL
    , @Value20 varchar(64)  = NULL
    , @Tag21   varchar(64)  = NULL
    , @Value21 varchar(64)  = NULL
    , @Tag22   varchar(64)  = NULL
    , @Value22 varchar(64)  = NULL
    , @Tag23   varchar(64)  = NULL
    , @Value23 varchar(64)  = NULL
    , @Tag24   varchar(64)  = NULL
    , @Value24 varchar(64)  = NULL
    , @Tag25   varchar(64)  = NULL
    , @Value25 varchar(64)  = NULL
    , @Tag26   varchar(64)  = NULL
    , @Value26 varchar(64)  = NULL
    , @Tag27   varchar(64)  = NULL
    , @Value27 varchar(64)  = NULL
    , @Tag28   varchar(64)  = NULL
    , @Value28 varchar(64)  = NULL
    , @Tag29   varchar(64)  = NULL
    , @Value29 varchar(64)  = NULL
    , @Tag30   varchar(64)  = NULL
    , @Value30 varchar(64)  = NULL
    , @Tag31   varchar(64)  = NULL
    , @Value31 varchar(64)  = NULL
    , @Tag32   varchar(64)  = NULL
    , @Value32 varchar(64)  = NULL
    , @Tag33   varchar(64)  = NULL
    , @Value33 varchar(64)  = NULL
    , @Tag34   varchar(64)  = NULL
    , @Value34 varchar(64)  = NULL
    , @Tag35   varchar(64)  = NULL
    , @Value35 varchar(64)  = NULL
    , @Tag36   varchar(64)  = NULL
    , @Value36 varchar(64)  = NULL
    , @Tag37   varchar(64)  = NULL
    , @Value37 varchar(64)  = NULL
    , @Tag38   varchar(64)  = NULL
    , @Value38 varchar(64)  = NULL
    , @Tag39   varchar(64)  = NULL
    , @Value39 varchar(64)  = NULL
    , @Tag40   varchar(64)  = NULL
    , @Value40 varchar(64)  = NULL
    , @Tag41   varchar(64)  = NULL
    , @Value41 varchar(64)  = NULL
    , @Tag42   varchar(64)  = NULL
    , @Value42 varchar(64)  = NULL
    , @Tag43   varchar(64)  = NULL
    , @Value43 varchar(64)  = NULL
    , @Tag44   varchar(64)  = NULL
    , @Value44 varchar(64)  = NULL
    , @Tag45   varchar(64)  = NULL
    , @Value45 varchar(64)  = NULL
    , @Tag46   varchar(64)  = NULL
    , @Value46 varchar(64)  = NULL
    , @Tag47   varchar(64)  = NULL
    , @Value47 varchar(64)  = NULL
    , @Tag48   varchar(64)  = NULL
    , @Value48 varchar(64)  = NULL
    , @Tag49   varchar(64)  = NULL
    , @Value49 varchar(64)  = NULL
    , @Tag50   varchar(64)  = NULL
    , @Value50 varchar(64)  = NULL
    , @Tag51   varchar(64)  = NULL
    , @Value51 varchar(64)  = NULL
    , @Tag52   varchar(64)  = NULL
    , @Value52 varchar(64)  = NULL
    , @Tag53   varchar(64)  = NULL
    , @Value53 varchar(64)  = NULL
    , @Tag54   varchar(64)  = NULL
    , @Value54 varchar(64)  = NULL
    , @Tag55   varchar(64)  = NULL
    , @Value55 varchar(64)  = NULL
    , @Tag56   varchar(64)  = NULL
    , @Value56 varchar(64)  = NULL
    , @Tag57   varchar(64)  = NULL
    , @Value57 varchar(64)  = NULL
    , @Tag58   varchar(64)  = NULL
    , @Value58 varchar(64)  = NULL
    , @Tag59   varchar(64)  = NULL
    , @Value59 varchar(64)  = NULL
    , @Tag60   varchar(64)  = NULL
    , @Value60 varchar(64)  = NULL

) AS

-----------------------------------------------------------------------
-- [_DBErrorLog_TagValueList] creates a Parameter/Value list.
-- This paramter/value list is included in the error string
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  ------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN
    -- Called to build up a tag/value pair string. Normally used for error messages.

	DECLARE		@strOutput	varchar(8000)
	SET @strOutput = ''

    -- Tag/Value 1
    IF @Tag1 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    -- This line begins the string
    SELECT @strOutput = '(' + @Tag1 + ': ' + ISNULL(RTRIM(@Value1), 'NULL') + ')'

    -- Tag/Value 2
    IF @Tag2 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag2 + ': ' + ISNULL(RTRIM(@Value2), 'NULL') + ')'

    -- Tag/Value 3
    IF @Tag3 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag3 + ': ' + ISNULL(RTRIM(@Value3), 'NULL') + ')'

    -- Tag/Value 4
    IF @Tag4 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag4 + ': ' + ISNULL(RTRIM(@Value4), 'NULL') + ')'

    -- Tag/Value 5
    IF @Tag5 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag5 + ': ' + ISNULL(RTRIM(@Value5), 'NULL') + ')'

    -- Tag/Value 6
    IF @Tag6 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag6 + ': ' + ISNULL(RTRIM(@Value6), 'NULL') + ')'

    -- Tag/Value 7
    IF @Tag7 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag7 + ': ' + ISNULL(RTRIM(@Value7), 'NULL') + ')'

    -- Tag/Value 8
    IF @Tag8 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag8 + ': ' + ISNULL(RTRIM(@Value8), 'NULL') + ')'

    -- Tag/Value 9
    IF @Tag9 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag9 + ': ' + ISNULL(RTRIM(@Value9), 'NULL') + ')'

    -- Tag/Value 10
    IF @Tag10 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag10 + ': ' + ISNULL(RTRIM(@Value10), 'NULL') + ')'

    -- Tag/Value 11
    IF @Tag11 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag11 + ': ' + ISNULL(RTRIM(@Value11), 'NULL') + ')'

    -- Tag/Value 12
    IF @Tag12 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag12 + ': ' + ISNULL(RTRIM(@Value12), 'NULL') + ')'

    -- Tag/Value 13
    IF @Tag13 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag13 + ': ' + ISNULL(RTRIM(@Value13), 'NULL') + ')'

    -- Tag/Value 14
    IF @Tag14 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag14 + ': ' + ISNULL(RTRIM(@Value14), 'NULL') + ')'

    -- Tag/Value 15
    IF @Tag15 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag15 + ': ' + ISNULL(RTRIM(@Value15), 'NULL') + ')'

    -- Tag/Value 16
    IF @Tag16 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag16 + ': ' + ISNULL(RTRIM(@Value16), 'NULL') + ')'

    -- Tag/Value 17
    IF @Tag17 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag17 + ': ' + ISNULL(RTRIM(@Value17), 'NULL') + ')'

    -- Tag/Value 18
    IF @Tag18 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag18 + ': ' + ISNULL(RTRIM(@Value18), 'NULL') + ')'

    -- Tag/Value 19
    IF @Tag19 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag19 + ': ' + ISNULL(RTRIM(@Value19), 'NULL') + ')'

    -- Tag/Value 20
    IF @Tag20 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag20 + ': ' + ISNULL(RTRIM(@Value20), 'NULL') + ')'

    -- Tag/Value 21
    IF @Tag21 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag21 + ': ' + ISNULL(RTRIM(@Value21), 'NULL') + ')'

    -- Tag/Value 22
    IF @Tag22 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag22 + ': ' + ISNULL(RTRIM(@Value22), 'NULL') + ')'

    -- Tag/Value 23
    IF @Tag23 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag23 + ': ' + ISNULL(RTRIM(@Value23), 'NULL') + ')'

    -- Tag/Value 24
    IF @Tag24 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag24 + ': ' + ISNULL(RTRIM(@Value24), 'NULL') + ')'

    -- Tag/Value 25
    IF @Tag25 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag25 + ': ' + ISNULL(RTRIM(@Value25), 'NULL') + ')'

    -- Tag/Value 26
    IF @Tag26 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag26 + ': ' + ISNULL(RTRIM(@Value26), 'NULL') + ')'

    -- Tag/Value 27
    IF @Tag27 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag27 + ': ' + ISNULL(RTRIM(@Value27), 'NULL') + ')'

    -- Tag/Value 28
    IF @Tag28 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag28 + ': ' + ISNULL(RTRIM(@Value28), 'NULL') + ')'

    -- Tag/Value 29
    IF @Tag29 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag29 + ': ' + ISNULL(RTRIM(@Value29), 'NULL') + ')'


    -- Tag/Value 30
    IF @Tag30 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag30 + ': ' + ISNULL(RTRIM(@Value30), 'NULL') + ')'

    -- Tag/Value 31
    IF @Tag31 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag31 + ': ' + ISNULL(RTRIM(@Value31), 'NULL') + ')'

    -- Tag/Value 32
    IF @Tag32 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag32 + ': ' + ISNULL(RTRIM(@Value32), 'NULL') + ')'

    -- Tag/Value 33
    IF @Tag33 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag33 + ': ' + ISNULL(RTRIM(@Value33), 'NULL') + ')'

    -- Tag/Value 34
    IF @Tag34 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag34 + ': ' + ISNULL(RTRIM(@Value34), 'NULL') + ')'

    -- Tag/Value 35
    IF @Tag35 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag35 + ': ' + ISNULL(RTRIM(@Value35), 'NULL') + ')'

    -- Tag/Value 36
    IF @Tag36 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag36 + ': ' + ISNULL(RTRIM(@Value36), 'NULL') + ')'

    -- Tag/Value 37
    IF @Tag37 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag37 + ': ' + ISNULL(RTRIM(@Value37), 'NULL') + ')'

    -- Tag/Value 38
    IF @Tag38 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag38 + ': ' + ISNULL(RTRIM(@Value38), 'NULL') + ')'

    -- Tag/Value 39
    IF @Tag39 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag39 + ': ' + ISNULL(RTRIM(@Value39), 'NULL') + ')'

    -- Tag/Value 40
    IF @Tag40 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag40 + ': ' + ISNULL(RTRIM(@Value40), 'NULL') + ')'

    -- Tag/Value 41
    IF @Tag41 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag41 + ': ' + ISNULL(RTRIM(@Value41), 'NULL') + ')'

    -- Tag/Value 42
    IF @Tag42 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag42 + ': ' + ISNULL(RTRIM(@Value42), 'NULL') + ')'

    -- Tag/Value 43
    IF @Tag43 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag43 + ': ' + ISNULL(RTRIM(@Value43), 'NULL') + ')'

    -- Tag/Value 44
    IF @Tag44 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag44 + ': ' + ISNULL(RTRIM(@Value44), 'NULL') + ')'

    -- Tag/Value 45
    IF @Tag45 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag45 + ': ' + ISNULL(RTRIM(@Value45), 'NULL') + ')'

    -- Tag/Value 46
    IF @Tag46 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag46 + ': ' + ISNULL(RTRIM(@Value46), 'NULL') + ')'

    -- Tag/Value 47
    IF @Tag47 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag47 + ': ' + ISNULL(RTRIM(@Value47), 'NULL') + ')'

    -- Tag/Value 48
    IF @Tag48 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag48 + ': ' + ISNULL(RTRIM(@Value48), 'NULL') + ')'

    -- Tag/Value 49
    IF @Tag49 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag49 + ': ' + ISNULL(RTRIM(@Value49), 'NULL') + ')'

    -- Tag/Value 50
    IF @Tag50 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag50 + ': ' + ISNULL(RTRIM(@Value50), 'NULL') + ')'

    -- Tag/Value 51
    IF @Tag51 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag51 + ': ' + ISNULL(RTRIM(@Value51), 'NULL') + ')'

    -- Tag/Value 52
    IF @Tag52 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag52 + ': ' + ISNULL(RTRIM(@Value52), 'NULL') + ')'

    -- Tag/Value 53
    IF @Tag53 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag53 + ': ' + ISNULL(RTRIM(@Value53), 'NULL') + ')'

    -- Tag/Value 54
    IF @Tag54 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag54 + ': ' + ISNULL(RTRIM(@Value54), 'NULL') + ')'

    -- Tag/Value 55
    IF @Tag55 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag55 + ': ' + ISNULL(RTRIM(@Value55), 'NULL') + ')'

    -- Tag/Value 56
    IF @Tag56 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag56 + ': ' + ISNULL(RTRIM(@Value56), 'NULL') + ')'

    -- Tag/Value 57
    IF @Tag57 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag57 + ': ' + ISNULL(RTRIM(@Value57), 'NULL') + ')'

    -- Tag/Value 58
    IF @Tag58 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag58 + ': ' + ISNULL(RTRIM(@Value58), 'NULL') + ')'

    -- Tag/Value 59
    IF @Tag59 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag59 + ': ' + ISNULL(RTRIM(@Value59), 'NULL') + ')'


    -- Tag/Value 60
    IF @Tag60 IS NULL BEGIN
		SELECT @List = SUBSTRING(@strOutput,1,1000)
        RETURN(0)
    END
    SELECT @strOutput = @strOutput + ' (' + @Tag60 + ': ' + ISNULL(RTRIM(@Value60), 'NULL') + ')'


	-- All parameters were filled only return first 1000 characters
	SELECT @List = SUBSTRING(@strOutput,1,1000)
    RETURN(0)
END
GO
