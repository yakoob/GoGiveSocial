
<cfoutput>
Please note that this donation will appear on your credit card statement as "GGS Donation", which processed this donation on behalf of #reply.account.name()#.<br><br>
<cfif val(reply.account.taxId())>Your contribution is tax-deductible to the extent allowed by law. You may save or print this receipt for your records. This receipt may be useful to you when completing your tax return.</cfif><br><br>
Method of Payment: <b>Credit Card</b><br>
Name on Credit Card: <b>#reply.payment.name()#</b><br>
Credit Card Last 4 Digits: <b>#right(reply.payment.bin(), 4)#</b><br>
Total Billed to Your Credit Card:  <b>#dollarformat(evaluate(reply.payment.amount()/100))#</b><br>
Tax Deductible Amount: <b>#dollarformat(evaluate( (reply.payment.amount() - reply.payment.fee()) / 100 ))#</b><br>
Date: <b>#dateformat(reply.payment.date(), "mm/dd/yyyy")#</b><br>
Time: <b>#timeformat(reply.payment.date(), "hh:mm:ss tt")# PST</b><br>
Transaction ##: <b>don2000#reply.payment.transactionLogId()#</b><br>
Authorization:  <b>Approved</b><br><br>
<cfif val(reply.account.taxId())>Nonprofit </cfif>Organization: <b>#reply.account.name()#</b>
<cfif val(reply.account.taxId())><br>Tax Identification Number: <b>#reply.account.taxId()#</b></cfif>
<br><br>
Your contribution is being made to GoGiveSocial LLC, which will distribute your donation to the nonprofit organization that you indicated. If you have questions about your donation, please contact a customer service representative at support@gogivesocial.com.
</cfoutput>


<!--- 
Name: yakoob ahmad
Address: 6515 nancy rd.
City: Rancho Palos Verdes
State/Province: CA
Zip/Postal Code: 90275
Country: United States
E-mail: yakoob@coldfusionsocial.com
Phone: 310-227-9953 
--->