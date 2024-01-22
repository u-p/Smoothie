# 
# Author: Umesh Patil (umesh.patil@gmail.com)
#

#! time tracker
currTime=0


#! steps = no. of all possible retrieval-attachment pairs.
#! If there are multiple options at a stage they are counted separately.
# steps=9 # cond-1 & 2
steps=8 # cond-3


#! stages = no. of input words/stages
# stages=9 # cond-1 & 2
stages=8 # cond-3


#! step tracker
currStep=0


#! tracker & limit for memory chunks
chunkID=0
maxChunks=20


#! length of the retrieval que
#maxRetQ=10
retQLen=0

maxCues=5


#! Print trace & function calls to stdout
# verbose=FALSE
# verbose.func=FALSE
verbose=TRUE
verbose.func=TRUE




## -- Retrieval que --
# ret.que[*,1] = index of all chunks in the retrieval que
# ret.que[*,2] = activation of the chunk
ret.que = array(, c(retQLen,2))


## -- DM: all chunks (except goal-chunk) --
# array of lists with dim = [maxChunks, 1]
chunks = array(list(NULL), c(maxChunks,1))


## -- Syn-obj chunks --
## ?? are these only syn-obj chunks or any chunk, e.g. pic chunks?
#
# ret.hist[i,j] = time stamp of the jth retrieval of chunk i
# default value is -1 since some chunks will have 0 at creation time (1st presentation)
ret.hist = array(rep(-1,maxChunks*stages), c(maxChunks,stages))


## -- List of retrieval cues --

# cues.list[[*,1]] = feature name
# cues.list[[*,2]] = feature value
# cues.list[[*,3]] = fan

# UP 2020
# no need of creating an array with NULL entries
# 
# cues.list = array(, c(maxCues,3))
cues.list = NULL


# UP 2020
# pre-create an array of random numbers to avoid the
# problem of strange random no. generation in the noise function
randNo = rlogis(1000, location=0, scale=par.ans)

