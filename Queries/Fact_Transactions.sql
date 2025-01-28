select a.[Account Number], tt.Transaction_Type_Id, ts.TransactionDate, ts.Amount, ts.TransactionId
from transactions_ATM_Account ts inner join Account a
ON a.[Account Number] = ts.[Account Number]
inner join Transcations tt
ON tt.Transaction_Type_Id = ts.TransactionTypeId