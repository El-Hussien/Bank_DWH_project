SELECT C.Customer_ID, 
	C.[First Name], 
	C.[Last Name], 
	C.Email, 
	C.State, 
	C.Age, 
	C.Gender, 
	C.BD, 
	CP.[Mobile Number]
FROM customer C LEFT JOIN Customer_Phones CP
ON C.Customer_ID = CP.Customer_ID