runClient :: Server -> Client -> IO()
runClient Server{..} Client{..} = forever $ do 
	r <- try $ race readCommand readMessage 
	case r of 
		Left (e :: SomeException) ->
			printf "Exception: %s\n" (show e)
		Right cm -> case cm of 
			Left mcommand -> case mcommand of 
				Nothing -> printf("Could not pass command\n")
				Just command -> handleCommand command 
			Right message -> handleMessage message
	where


handleCommand :: Message -> IO()
handleCommand (Msg user msg) = 
	clientMap <- readMVar serverUsers
	case Map.lookup user clientMap of 
		Nothing ->
			printf "No such user: %s\n" (userName user)
		Just client ->
			sendMessage (Msg clientUser msg) client
handleMessage :: Message -> IO()
handleMessage = printToHandle clientToHandle . formatMessage 

race :: IO a -> IO b -> IO (Either a b) 
race ioa iob = do 
	m <- newEmptyMVar 
	bracket (forkIO (fmap Left ioa) (putMVar m)) killThread $ \_ -> 
		bracket (forkIO (fmap Right iob) (putMVar m)) killThread $ \_ -> 
			readMVar m