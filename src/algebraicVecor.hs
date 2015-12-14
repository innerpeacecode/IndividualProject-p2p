
data Cartesian2D = Cartesian2D Double Double 
					deriving (Eq, Show)

data Polar2D = Polar2D Double Double 
				deriving (Eq, Show) 

myNot True = False
myNot False = True

sumList (x:xs) = x + sumList xs
sumList [] = 0