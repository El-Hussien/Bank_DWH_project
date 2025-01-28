SELECT B.BranchId,
	B.BranchName,
	B.Branch_Location,
	E.[Employee ID],
	E.[First Name],
	E.[Last Name],
	E.Salary,
	E.Position,
	E.SuperVisor_ID,
	D.Dnumber,
	D.Dname,
	D.MGRID
FROM Branch B LEFT JOIN employee E
ON B.BranchId = E.[Branch ID]
LEFT JOIN Department D
ON E.DNO = D.Dnumber