USE saveplus

DECLARE @bk VARCHAR( 3)
DECLARE @bch VARCHAR( 3)
DECLARE @start_date DATETIME
DECLARE @end_date DATETIME
DECLARE @days INT


SET @start_date = '01/01/1900'
SET @end_date = '06/30/2016'
SET @bk = '005'
SET @bch = '008'

SET @days = DATEDIFF(DAY ,@start_date, @end_date)

SELECT		a.bch,
			A .acct_no,
          A.name + ' ' + A. and_or AS [name],
          A.acct_group ,
          A.caclass ,
          A.ebal2 AS [balance],
          A.last_trans AS [last transaction date],
          A.last_trans + V.min_dormant AS [date turned dormant]
FROM ca_account A WITH (NOLOCK ) LEFT JOIN v_ca_min_dormant V WITH ( NOLOCK)
                                          ON     A .bk = V .bk
                                                 AND A .bch = V .bch
                                                 AND A .caclass = V .caclass
WHERE  
               A.bk = @bk
               AND A .bch = @bch
               AND (( DATEDIFF(DAY ,A. last_trans,@end_date ) - V. min_dormant) BETWEEN 0 AND @days )
               AND ( V.min_dormant > 0 )  
			   and a.ebal2 > 0  
ORDER BY A. bk, A.bch , A .last_trans ASC
