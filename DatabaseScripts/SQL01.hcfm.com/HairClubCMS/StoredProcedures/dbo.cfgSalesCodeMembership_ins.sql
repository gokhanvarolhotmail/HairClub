CREATE PROCEDURE cfgSalesCodeMembership_ins @memberid int,  @SalesCodeDescriptionShort varchar(15), @note varchar(200), @user varchar(20)
as

--DECLARE @memberid  INT
--SET  @memberid = 70
--113
--114


--SELECT * FROM cfgSalesCodeMembership_20180718 ORDER BY 1 DESC
--

DECLARE @SalesCodeCenterid int
DECLARE @salescodeinsert CURSOR

SET @salescodeinsert = CURSOR FOR
SELECT scc.SalesCodeCenterid
FROM dbo.cfgSalesCodeCenter scc INNER JOIN cfgsalescode c ON c.SalesCodeID = scc.SalesCodeID
WHERE c.SalesCodeDescriptionShort = @SalesCodeDescriptionShort ORDER BY centerid

	OPEN @salescodeinsert
	FETCH NEXT FROM  @salescodeinsert INTO @SalesCodeCenterid


	WHILE @@FETCH_STATUS = 0
		BEGIN

			If not exists (select 1 from cfgSalesCodeMembership where membershipid = @memberid and SalescodeCenterid = @SalesCodeCenterid)
              BEGIN
				INSERT INTO cfgSalesCodeMembership_20180718 (SalescodeCenterid, membershipid, price, TaxRate1ID, TaxRate2ID, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser, IsFinancedToARFlag)
				VALUES (@SalesCodeCenterid, @memberid,  NULL, NULL, NULL, 1, getdate(), @note, getdate(), @user, 0)
			  END

			FETCH NEXT FROM  @salescodeinsert INTO @SalesCodeCenterid
		END


CLOSE @salescodeinsert;
DEALLOCATE @salescodeinsert;
