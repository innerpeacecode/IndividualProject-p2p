module Link.Types where 

data User = User {userName :: String}
			deriving (Show, Eq, Ord)

data Client = Client {
				clientUser :: User, 
				clientHandle :: Handle
				} deriving (Show, Eq)

data Server = Server {
				serverUsers :: MVar (Map.Map User Client)
				}
