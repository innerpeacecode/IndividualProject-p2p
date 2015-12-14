module Link.Types where

data Client = Client {
				clientUser :: User,
				clientHandle :: Handle,
				clientChan :: Chan Message
				}

data Message = Msg User String 
				derinving (Show, Eq)