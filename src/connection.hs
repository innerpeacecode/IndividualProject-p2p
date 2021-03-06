module Link.Server where

import Link.Types

runServer :: Int -> IO()
runServer port = withSocketsDo $ do
	hSetBuffering stdout LineBuffering 
	server <- newServer
	sock <- listenOn . PortNumber . fromIntegral $ port
	printf "Listening on port %d\n" port 
	forever $ do
		(handle, host, port') <- accept sock
		printf "Accepted connection from %s\n" host (show port')
		forkIO $ connectClient server handle `finally` hClose handle 

connectClient :: Server -> Handle -> IO()
connectClient server handle = do 
	hSetNewlineMode handle universalNewlineMode
	hSetBuffering handle LineBuffering
	readName
	where

readName :: IO()
readName :: do
	name <- hGetLine handle 
	if null name 
		then readName
		else do 
			let user = User name 
			ok <- checkAddClient server user handle 
			cause ok of 
				Nothing -> do
					hPrintf handle 
						"The name %s is in use, please choose another\n" name 
					readName
				Just client ->
					runClient server client 
						`finally` removeClient server user 

checkAddClient :: Server -> User -> Handle -> IO(Maybe Client)
checkAddClient Server {..} user@User {..} handle = 
	modifyVar serverUsers $ \clientMap -> 
		if Map.member user clientMap 
			then return (clientMap, Nothing)
			else do 
				client <- Client user handle 
				printf "New user connected: %s\n" userName
				return (Map.insert user client clientMap, Just client)

removeClient :: Server -> User -> IO()
removeClient Server {..} user = 
	modifyMVar serverUsers $ return . Map.delete user 

 
