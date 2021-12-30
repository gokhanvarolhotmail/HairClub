/* CreateDate: 04/14/2009 07:33:54.820 , ModifyDate: 02/18/2013 19:04:02.980 */
GO
CREATE VIEW [dbo].[vwCfgCurrencyExchangeRate]
AS
SELECT     cer.CurrencyExchangeRateID, lkpCT.CurrencyTypeDescription, cer.ExchangeRate, cer.BeginDate, cer.EndDate, cer.IsActiveFlag, cer.CreateDate,
                      cer.CreateUser, cer.LastUpdate, cer.LastUpdateUser, cer.UpdateStamp
FROM         dbo.cfgCurrencyExchangeRate AS cer LEFT OUTER JOIN
                      dbo.lkpCurrencyType AS lkpCT ON lkpCT.CurrencyTypeID = cer.CurrencyTypeID
GO
