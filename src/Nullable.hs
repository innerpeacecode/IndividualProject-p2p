

data Perhaps a = ReallyJust a 
				| NothingAtAll
				deriving (Show)

--printYo = ReallyJust "True"

printYo = ReallyJust (ReallyJust "True")