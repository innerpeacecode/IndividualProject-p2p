--main = interact wordCount
--		where wordCount input = show (length (lines input)) ++ "\n"



-- file: ch02/myDrop.hs

myDrop n xs = if n <= 0 || null xs 
	then xs 
	else myDrop (n - 1) (tail xs)

data BookInfo = Book Int String [String]
					deriving (Show)

myInfo = Book 9780135072455 "Algebra of Programming"
		["Richard Bird", "Oege de Moor"]

