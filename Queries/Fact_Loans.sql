SELECT C.Customer_ID, 
	   COALESCE(L.LoanID, -1) AS LoanID, 
       COALESCE(B.BranchId, -1) AS BranchId,
       COALESCE(L.[Start Date], '9999-01-01') AS [Start Date],
       COALESCE(L.[End Date], '9999-01-01') AS [End Date],
       COALESCE(L.Amount, '0') AS Amount
FROM Customer C LEFT JOIN Loan L
ON L.[Customer ID] = C.Customer_ID
LEFT JOIN Branch B
ON B.BranchId = L.[Branch ID]