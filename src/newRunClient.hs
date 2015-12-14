runClient :: Server -> Client -> IO()
runClient Server {..} client@Client {..} = do
	commandThread <- forkIO $ readCommands
	run `finally` do 
		killThread commandThread
		clientChannelMap <- readTVarIO clientChannelChans
		forM_ (Map.keys clientChannelMap) $ \channelNme ->
			handleMessage (Leave channelName)
	where

run :: IO()
run = forever $ do
	r <- try . atomically $ do
		clientChannelMap <- readTVar clientChannelChans
		foldr (orElse . readTChan) retry
			$ clientChan : Map.elems clientChannelMap
	case r of 
		Left (e :: SomeException) -> printf "Exception: %s\n" (show e)
		Right message 	 		->  handleMessage message


readCommands :: IO()
readCommands = forever $ do
	command <- hGetLine clientHandle
	printf "<%s>: %s\n" (userName clientUser) command
	case parseCommand command of
		Nothing -> printf "Could not parse command: %s\n" command
		Just c -> sendMessageIO client c


handleMessage :: Message -> IO()
handleMessage (Join channelName) = atomically $ do
	clientChannelMap <- readTVar clientChannelChans -- get user's hannels
	-- if user has not already joined the channel
	unless (Map.member channelName clientChannelMap) $ do
		channelMap <- readTVar serverChannels -- get server channels
		channel@Channel {channelChan} <-
			case Map.lookup channelName channelMap of 
				Just (channel@Channel {channelUsers}) -> do
					-- if the channel already exists on the server, add user to it
					modifyTVar' channelUsers $ Set.insert clientUser
					return channel
				Nothing
					-- else create a new channel with this user in it and add it to the server
					channel <- newChannel channelName $ Set.singleton clientUser
					modifyTVar' serverChannels $ Map.insert channelName channel
					return channel
		-- duplicate channel TChan for this user and ad it to the user's channels
		clientChannelChan <- dupTChan channelChan
		modifyTVar' clientChannelChans $ Map.insert channelName clientChannelChan
		-- send a JOINED message to the channel for this user
		tellMessage channel $ Joined channelName clientUser
															