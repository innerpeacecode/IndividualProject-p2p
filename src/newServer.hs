-- Server has been changed to add a map of channels 

data Server = Server {
	serverUsers :: MVar (Map.Map User Client),
	serverChannels :: TVar (Map.Map ChannelName Channel)
}

data Client = CLient {
	clientUser 			:: !User,
	clientHandle 		:: !Handle,
	cientChan 			:: TChan Message,
	clientChannelChans 	:: TVar (Map.Map CHannelName (TChan Message))
}

data Message = Msg User String
				| Tell ChannelName String
				| Join ChannelName 
				| Leave ChannelName
				| MsgReply User String
				| TellReply ChannelName User String
				| Joined ChannelName User 
				| Leaved ChannelName User
					deriving (Show, Eq)

						