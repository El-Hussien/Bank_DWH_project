USE Union_Bank_OLAP

CREATE TABLE Union_Bank_OLAP.dbo.Fact_Transactions (
    Fact_Transaction_PK_SK INT PRIMARY KEY IDENTITY,
    FK_Account INT,
    FK_Date INT,
	FK_Transaction_Type INT,
	Transaction_ID BIGINT,
    Amount money,
	SSC TINYINT,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Union_Bank_OLAP.dbo.Fact_Loans (
    Fact_Loans_PK_SK INT PRIMARY KEY IDENTITY,
    FK_Loan INT,
    FK_Customer INT,
	FK_Branch INT,
	FK_Start_Date INT,
	FK_End_Date INT,
    Loan_Amount VARCHAR(50),
	SSC TINYINT,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Union_Bank_OLAP.dbo.Dim_Accounts (
	AccountNumber_PK_SK INT PRIMARY KEY IDENTITY,
	AccountNumber_PK_BK INT,
	Account_Type NVARCHAR(255),
	Balance FLOAT,
	Status NVARCHAR(255),
	SSC TINYINT,
	Start_Date DATETIME,
	End_Date DATETIME,
	Is_Current TINYINT
);

CREATE TABLE Union_Bank_OLAP.dbo.Dim_Card (
	CardNumber_PK_SK INT PRIMARY KEY IDENTITY,
	CardNumber_BK VARCHAR(50),
	Card_Type NVARCHAR(50),
	Card_Status NVARCHAR(50),
	Expiry_Date DATE,
	CSV INT,
	FK_AccountNumber INT,
	SSC TINYINT,
	Start_Date DATETIME,
	End_Date DATETIME,
	Is_Current TINYINT
);

CREATE TABLE Union_Bank_OLAP.dbo.Dim_Transcation_Type (
	Transaction_Type_PK_SK INT PRIMARY KEY IDENTITY,
	Transaction_Type_PK_BK INT,
	Transcation_Type VARCHAR(100),
);

CREATE TABLE Union_Bank_OLAP.dbo.Dim_Customer (
	Customer_PK_SK INT PRIMARY KEY IDENTITY,
	Customer_PK_BK INT,
	Customer_First_Name VARCHAR(50),
	Customer_Last_Name VARCHAR(50),
	Customer_Email VARCHAR(50),
	Customer_State VARCHAR(50),
	Customer_Age INT,
	Customer_Gender VARCHAR(50),
	Customer_BD DATE,
	Customer_Mobile_Number VARCHAR(15),
	SSC TINYINT,
	Start_Date DATETIME,
	End_Date DATETIME,
	Is_Current TINYINT
);

CREATE TABLE Dim_Loan(
	Loan_ID_PK_SK INT PRIMARY KEY IDENTITY,
	Loan_ID_PK_BK INT,
	Loan_Months_Terms VARCHAR(50),
	Loan_Start_Date DATE,
	Loan_End_Date DATE,
	Loan_Type VARCHAR(50),
	Interest_Rate FLOAT,
	SSC TINYINT,
	Start_Date DATETIME,
	End_Date DATETIME,
	Is_Current TINYINT
);


CREATE TABLE Dim_Branch(
	Branch_PK_SK INT PRIMARY KEY IDENTITY,
	Branch_PK_BK INT,
	Branch_Name NVARCHAR(255),
	Branch_Location NVARCHAR(255),
	Employee_ID_BK INT,
	Emp_First_Name VARCHAR(50),
	Emp_Last_Name VARCHAR(50),
	Emp_Salary FLOAT,
	Emp_Position VARCHAR(50),
	Emp_Supervior_ID INT,
	Dept_Number_BK INT,
	Dept_Name VARCHAR(50),
	MGR_ID INT,
	SSC TINYINT,
	Start_Date DATETIME,
	End_Date DATETIME,
	Is_Current TINYINT
);

CREATE TABLE Dim_ATM(
	ATM_PK_SK INT PRIMARY KEY IDENTITY,
	ATM_PK_BK INT,
	ATM_Location NVARCHAR(255),
	ATM_Status NVARCHAR(255),
	FK_Branch INT,
	SSC TINYINT,
	Start_Date DATETIME,
	End_Date DATETIME,
	Is_Current TINYINT
);


CREATE TABLE [dbo].[Dim_Date](
 --[DateSK] [int] IDENTITY(1,1) NOT NULL--Use this line if you just want an autoincrementing counter AND COMMENT BELOW LINE
 [DateSK] [int] NOT NULL--TO MAKE THE ID THE YYYYMMDD FORMAT USE THIS LINE AND COMMENT ABOVE LINE.
 , [Date] [datetime] NOT NULL
 , [Day] [char](2) NOT NULL
 , [DaySuffix] [varchar](4) NOT NULL
 , [DayOfWeek] [varchar](9) NOT NULL
 , [DOWInMonth] [TINYINT] NOT NULL
 , [DayOfYear] [int] NOT NULL
 , [WeekOfYear] [tinyint] NOT NULL
 , [WeekOfMonth] [tinyint] NOT NULL
 , [Month] [char](2) NOT NULL
 , [MonthName] [varchar](9) NOT NULL
 , [Quarter] [tinyint] NOT NULL
 , [QuarterName] [varchar](6) NOT NULL
 , [Year] [char](4) NOT NULL
 , [StandardDate] [varchar](10) NULL
 , [HolidayText] [varchar](50) NULL
 CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED 
 (
 [DateSK] ASC
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
 ) ON [PRIMARY]

GO


--Populate Date dimension

TRUNCATE TABLE Dim_Date

--IF YOU ARE USING THE YYYYMMDD format for the primary key then you need to comment out this line.
--DBCC CHECKIDENT (DimDate, RESEED, 60000) --In case you need to add earlier dates later.

DECLARE @tmpDOW TABLE (DOW INT, Cntr INT)--Table for counting DOW occurance in a month
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(1,0)--Used in the loop below
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(2,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(3,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(4,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(5,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(6,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(7,0)

DECLARE @StartDate datetime
 , @EndDate datetime
 , @Date datetime
 , @WDofMonth INT
 , @CurrentMonth INT
 
SELECT @StartDate = '1/1/2000'  -- Set The start and end date 
 , @EndDate = '1/1/2050'--Non inclusive. Stops on the day before this.
 , @CurrentMonth = 1 --Counter used in loop below.

SELECT @Date = @StartDate

WHILE @Date < @EndDate
 BEGIN
 
 IF DATEPART(MONTH,@Date) <> @CurrentMonth 
 BEGIN
 SELECT @CurrentMonth = DATEPART(MONTH,@Date)
 UPDATE @tmpDOW SET Cntr = 0
 END

 UPDATE @tmpDOW
 SET Cntr = Cntr + 1
 WHERE DOW = DATEPART(DW,@DATE)

 SELECT @WDofMonth = Cntr
 FROM @tmpDOW
 WHERE DOW = DATEPART(DW,@DATE) 

 INSERT INTO Dim_Date
 (
 [DateSK],--TO MAKE THE DateSK THE YYYYMMDD FORMAT UNCOMMENT THIS LINE... Comment for autoincrementing.
 [Date]
 , [Day]
 , [DaySuffix]
 , [DayOfWeek]
 , [DOWInMonth]
 , [DayOfYear]
 , [WeekOfYear]
 , [WeekOfMonth] 
 , [Month]
 , [MonthName]
 , [Quarter]
 , [QuarterName]
 , [Year]
 )
 SELECT CONVERT(VARCHAR,@Date,112), --TO MAKE THE DateSK THE YYYYMMDD FORMAT UNCOMMENT THIS LINE COMMENT FOR AUTOINCREMENT
 @Date [Date]
 , DATEPART(DAY,@DATE) [Day]
 , CASE 
 WHEN DATEPART(DAY,@DATE) IN (11,12,13) THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'th'
 WHEN RIGHT(DATEPART(DAY,@DATE),1) = 1 THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'st'
 WHEN RIGHT(DATEPART(DAY,@DATE),1) = 2 THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'nd'
 WHEN RIGHT(DATEPART(DAY,@DATE),1) = 3 THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'rd'
 ELSE CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'th' 
 END AS [DaySuffix]
 , CASE DATEPART(DW, @DATE)
 WHEN 1 THEN 'Sunday'
 WHEN 2 THEN 'Monday'
 WHEN 3 THEN 'Tuesday'
 WHEN 4 THEN 'Wednesday'
 WHEN 5 THEN 'Thursday'
 WHEN 6 THEN 'Friday'
 WHEN 7 THEN 'Saturday'
 END AS [DayOfWeek]
 , @WDofMonth [DOWInMonth]--Occurance of this day in this month. If Third Monday then 3 and DOW would be Monday.
 , DATEPART(dy,@Date) [DayOfYear]--Day of the year. 0 - 365/366
 , DATEPART(ww,@Date) [WeekOfYear]--0-52/53
 , DATEPART(ww,@Date) + 1 -
 DATEPART(ww,CAST(DATEPART(mm,@Date) AS VARCHAR) + '/1/' + CAST(DATEPART(yy,@Date) AS VARCHAR)) [WeekOfMonth]
 , DATEPART(MONTH,@DATE) [Month]--To be converted with leading zero later. 
 , DATENAME(MONTH,@DATE) [MonthName]
 , DATEPART(qq,@DATE) [Quarter]--Calendar quarter
 , CASE DATEPART(qq,@DATE) 
 WHEN 1 THEN 'First'
 WHEN 2 THEN 'Second'
 WHEN 3 THEN 'Third'
 WHEN 4 THEN 'Fourth'
 END AS [QuarterName]
 , DATEPART(YEAR,@Date) [Year]

 SELECT @Date = DATEADD(dd,1,@Date)
 END

--You can replace this code by editing the insert using my functions dbo.DBA_fnAddLeadingZeros
UPDATE dbo.Dim_Date
 SET [DAY] = '0' + [DAY]
 WHERE LEN([DAY]) = 1

UPDATE dbo.Dim_Date
 SET [MONTH] = '0' + [MONTH]
 WHERE LEN([MONTH]) = 1

UPDATE dbo.Dim_Date
 SET STANDARDDATE = [MONTH] + '/' + [DAY] + '/' + [YEAR]


ALTER TABLE Dim_Date
ALTER COLUMN Date DATE

INSERT INTO Dim_Date (DateSK, Date) 
VALUES (9999, '9999-01-01');