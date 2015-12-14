--data BookInfo = Book Int String [String]
--				deriving (Show)


-- we use Record Syntax to access individual value of a Composite Dat type (customerID, 
--	customerName, customerAddress are eg. of Record Syntax)

data Customer = Customer {
					customerID		::	CustomerID,
					customerName	::	CustomerName,
					customerAddress	::	Address
				} deriving Show

type CustomerID 	= Int
type CustomerName 	= String
type Address 		= [String]

customer2 = Customer {
				customerID = 271828
				, customerAddress = ["1048576 Disk Drive",
				"Milpitas, CA 95134",
				"USA"]
				, customerName = "Jane Q. Citizen"
}


