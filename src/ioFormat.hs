module Link.Protocol where 

import Link.Types

parseCommand :: String -> Maybe Message 
parseCommand command = case words command of 
	"MSG" : userName : msg ->
		Just $ Msg (User userName) (unwords msg)
	_ -> Nothing

formatMessage :: Message -> String 
formatMessage :: (Msg user msg) = 
	printf "MSG %s %s" (userName user) msg