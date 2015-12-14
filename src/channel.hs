module Link.Types where

type UserName = String 
type ChannelName = String

data User = User {userName :: !UserName}
			deriving (Show, Eq, Ord)

data Channel = Channel {
	channelName :: ChannelName,
	channelUsers :: TVar (Set.Set User),
	channelChan :: TChan Message 
	}

