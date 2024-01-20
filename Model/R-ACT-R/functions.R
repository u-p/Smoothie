#-----------------------------------------------------------------------
#
# An R implementation of the cue-based retrieval theory based on:
#
# 1. Richard L. Lewis and Shravan Vasishth. An activation-based
# model of sentence processing as skilled memory retrieval.
# Cognitive Science, 29:1-45, May 2005.
#
# 2. Richard L. Lewis, Shravan Vasishth, and Julie Van Dyke.
# Computational principles of working memory in sentence comprehension.
# Trends in Cognitive Sciences, 10(10):447-454, 2006.
# 
# Author: Umesh Patil (umesh.patil@gmail.com)
#
#-----------------------------------------------------------------------


######################################################
# computes base activation and adds noise for each
# chunk in the retrieval que
######################################################

get.activation <- function(chunkName){
  if(verbose.func){
    print("in get.activation", quote=FALSE)
  }
  
  spread.act = base.act = partial.match = 0
  chID = get.ChunkId(chunkName)
  
  if(!is.null(cues.list)){
    W = par.ga/(length(cues.list[,2]) - 1 + 1)
    #! length '- 1' to exclude 'type' feature
    #! length '+ 1' to exclude 'goal-cat' feature which is normally part of the goal buffer
    
    
    if(!is.null(chID)){
      currChunk = chunks[[chID,1]]
      
      j=2
      while(j <=length(cues.list[,2])){

        k=1
        while(k <=length(currChunk)){
          if(cues.list[[j,2]] == currChunk[k]){
            spread = (par.mas - log(as.numeric(cues.list[[j,3]])))
            spread.act = W * spread

            if(verbose){
              print(paste("spreading act", spread.act, "(W =", W, ", Sij =", spread, ") from", 
                        cues.list[[j,2]], "to chunk", currChunk[["name"]]), quote=FALSE)
              }

          }
          k=k+1
        }
        j=j+1
      }
    }
  }

  if(!is.null(chID)){

    # original equation
    # base.act = Bi(chID) + noise(0, par.ans)

    # equation with a new 'noise' function
    base.act = Bi(chID) + noise2()

    # # 
    # # the noise should not be included since 'par.ans' captures the
    # # noise only at the time of retrieval
    # # 
    # # !! but then shouldn't the calculation be different when 'add.time()'
    # # !! is called after a retrieval?
    # # 
    # base.act = Bi(chID)
  }

  return(act = spread.act + base.act + partial.match)

}

######################################################
# logistic noise
######################################################

noise2 <- function(){
  if(verbose.func){
    print("in Noise 2", quote=FALSE)
  }
  # generate a random number between 1 and 1000 that functions
  # as the index into an array of random numbers of size 1000
  return(randNo[floor(runif(1)*1000)])
}


######################################################
# return the chunkID for the chunk with 
# name == 'chunkName'
######################################################

get.ChunkId <- function(chunkName){
  if(chunkID > 0){
    for(i in 1:chunkID){
      if(chunks[[i,1]][["name"]] == chunkName){
        return(i)
      }
    }
  }
  return(NULL)
}


######################################################
# adds new chunk to the DM
######################################################

add.chunk <- function(newChunk){
	
	if(verbose){
	print("adding chunk:", quote=FALSE)
	print(paste("", names(newChunk)), quote=FALSE)
	print(paste("", newChunk), quote=FALSE)
	print("", quote=FALSE)
	}
	
	chunkID <<- chunkID+1
	chunks[[chunkID,1]] <<- newChunk
	ret.hist[chunkID,1] <<- currTime
	}


######################################################
# increment the time counter
######################################################

add.time <- function(dur, txt='NA'){
  
  # UP: 01.11.2021
  # moved up here
  if(verbose.func){
    print("In add.time", quote=FALSE)
    print(a.out)
  }

	currTime <<- currTime + dur

	if(getActivation){
	  # a.out = c(round(currSim), currStep, txt, round(currTime*1000), # 'currStep' doesn't make sense; 'currStage' is more appropriate here
	  a.out = c(round(currSim), currStage, txt, round(currTime*1000),
	            round(get.activation("knopf"), 4), round(get.activation("flasche"), 4),
	            round(get.activation("ballon"), 4), round(get.activation("blume"), 4))
	  
	  # cSim = round(currSim)
	  # cStep = currStep
	  # cTime = round(currTime*1000)
	  # act.knopf = round(get.activation("knopf"), 4)
	  # act.flasche = round(get.activation("flasche"), 4)
	  # act.ballon = round(get.activation("ballon"), 4)
	  # act.blume = round(get.activation("blume"), 4)
	  
	}

  # UP: 01.11.2021
  # moved up, right at the beginning of the function.. that's where it should be!
	# if(verbose.func){
	#   print("In add.time", quote=FALSE)
	#   print(a.out)
	# }

	if(getActivation){	
	# if(exists("act.out")){
	  # print("In add.time", quote=FALSE)
	  # print(a.out)
	  # print(length(a.out))
	  #	  print(head(act.out))
	  # print(tail(act.out))
	  # print(dim(act.out))
	  # print(c(cSim, cStep, cTime, act.knopf, act.flasche, act.ballon, act.blume))
	  # print(length(c(cSim, cStep, cTime, act.knopf, act.flasche, act.ballon, act.blume)))
	  # print(dim(matrix(a.out, nrow = 1)))
	  #	  print(dim(rbind(act.out, a.out)))
	  # act.out <<- rbind(act.out, c(cSim, cStep, cTime, act.knopf, act.flasche, act.ballon, act.blume))
	  
	  act.out <<- rbind(act.out, a.out)
	# }else
	# {
	  # act.out <<- matrix(a.out, 1, length(a.out))
	# }
	}
	# ============


	if(verbose){
	  print("", quote=FALSE)
	  print(paste("Time: ", currTime), quote=FALSE)
	  }
}

######################################################
# conflict resolution: find the production to fire
######################################################

conflict.resolution <- function(stageNo){
	if(verbose.func){
		print("in conflict.resolution", quote=FALSE)
		}
		
	prods = array(, c(steps,2))
	
	i = currStep+1
	while(i <= steps){
		if(util.steps[i,1] == stageNo){

# The following code is commented out in order to consider all productions (even the ones with utility==0)
# in the conflict resolution process
#
#			if(util.steps[i,2] == 0){
#				stepNo <<- i
#				return(stepNo)
#				}
#			else{
				j=i
				k=1
				
				# the use of "&&" instead of just "&" is important here
				# to avoid the 'out of bound' error in the 2nd element
				while((j <= steps) && (util.steps[j,1] == stageNo)){
					prods[k,1] = j
					prods[k,2] = util.steps[j,2] + noise(0, par.egs)

					if(verbose){
						print(paste("Production: ", prods.names[j], "Utility: ", 
								"Utility+Noise: ", util.steps[j,2], prods[k,2]), quote=FALSE)
					}

					j=j+1
					k=k+1
					}
				stepNo = cbind(prods[order(prods[,2], decreasing=TRUE),1], prods[order(prods[,2], decreasing=TRUE),2])[1,1]
				return(stepNo)
				
#				}
			}
		i=i+1
		}
print("THIS SHOULD NOT BE PRINTED returning stepNo", quote=FALSE)
	
	return(stepNo)
	}



######################################################
# checks if any change in the goal buffer is requested
######################################################

check.goal <- function(){
	nm = names(goal.steps[[currStep,1]])
	
	if(!is.null(nm)){
		
		j=1
		while(j <= length(nm)){
			goal.chunk[[nm[j]]] <<- goal.steps[[currStep,1]][[nm[j]]]
			j=j+1
			}
		}
	
	}



######################################################
# prepares retrieval que according to the 
# retrieval request
######################################################

retrieval.request <- function(cues){
	if(verbose.func){
		print("in retrieval.request", quote=FALSE)
		}
		
	list.cues(cues)
	build.retQ()

	if(verbose){
	print(cues.list, quote=FALSE)

	print("",quote=FALSE)
	print("                 Activation Spreading", quote=FALSE)
	}
	
	compute.act.spreading()
	compute.base.act()

	if(verbose){
	print("",quote=FALSE)
	print("                 Partial Match", quote=FALSE)
	}

	compute.partial.match()
	sort.retQ()		#! sort the retQ on ret. time
	}



######################################################
# performs actual retrieval
######################################################

retrieve <- function(){
	if(verbose.func){
		print("in retrieve", quote=FALSE)
		}
			
	lhs = lhs.steps[[currStep,1]]

	i=1
	while(i <= length(ret.que[,1])){
		currChunk = chunks[[ret.que[i,1],1]]

# if the lhs has a '=retrieval' request with at least one slot.
# this is to ensure that match remains '0' even when there is no '=retrieval' (i.e., when length(names(lhs)==0 in the next while loop)
		if(length(names(lhs)) > 0){
			match = 1	
			}
		else{
			match = 0
			}

		
		j=1
		while(j <= length(names(lhs))){
			if(lhs[[j]] != currChunk[names(lhs)[j]]){
				match=0
				break
				}
			j=j+1
			}
			
		if(match == 1){
			if(ret.que[i,2] >= par.rt){
				add.time(ret.latency(ret.que[i,2]), txt='RetLat')

				if(verbose){
					print(paste("Retrieving", currChunk[["name"]], "at: ", currTime, " Activation:", ret.que[i,2]), quote=FALSE)
				}
				
				#! update no. of presentations of the chunk
				chunks[[ret.que[i,1],1]][["npres"]] <<- chunks[[ret.que[i,1],1]][["npres"]] + 1
				
				#! update retrieval history
				npres = chunks[[ret.que[i,1],1]][["npres"]] 
				ret.hist[ret.que[i,1], npres] <<- currTime
				
				output.ret[currSim,currStage] <<- currChunk[["name"]]
				output.time[currSim,currStage] <<- currTime
				output.latency[currSim,currStage] <<- round(ret.latency(ret.que[i,2]), 4)*1000
			}
			else{

				if(verbose){
					print("Activation below retrieval threshold!!", quote=FALSE)
				}
			}
			break
			}
		i=i+1
		}

	}


######################################################
# prepares a table of current retrieval cues with
# feature name and feature value as columns
######################################################

list.cues <- function(cues){
	if(verbose.func){
		print("in list.cues", quote=FALSE)
		}
		

	if(!is.null(cues)){
		nm = names(cues)
		
		if(!is.null(nm)){
			
			cues.list <<- array(, c(length(nm),3))

			for(j in c(1:length(nm))){
				cues.list[[j,1]] <<- nm[j]
				
				
				#! if the cue value is empty, the it has to be copied from the goal buffer
				#! slot but the 'type' cue value has to be always from the retrieval buffer
				
				if(cues[[nm[j]]] == ""){

					if(verbose){
					  print(paste("cue", j, ":", nm[j], "=", goal.chunk[[nm[j]]]), quote=FALSE)
					  }

					cues.list[[j,2]] <<- goal.chunk[[nm[j]]]
					}
				else{

					if(verbose){
					  print(paste("cue", j, ":", nm[j], "=", cues[[nm[j]]]), quote=FALSE)
					  }

					cues.list[[j,2]] <<- cues[[nm[j]]]
					}

				cues.list[[j,3]] <<- 1
				}
			}
		}
	}



######################################################
# builds a que with all retrieval target chunks
# also prepares 'fan' entry for each cue
######################################################

build.retQ <- function(){
	if(verbose.func){
		print("in build.retQ", quote=FALSE)
		}

  # UMESH 2020
  # ind=c()
	ind=NULL

	i=1
	j=1
	currChunk = chunks[[i,1]]

	while(!is.null(currChunk)){

		if(currChunk[["type"]] == cues.list[[1,2]]){
			ind = c(ind, i)
			j=j+1
			}

		# prepare 'fan' entry for each cue
		for(l in c(2:length(cues.list[,2]))){
		# 1st entry in the list of cues is the 'type'

			for(k in c(1:length(currChunk))){
				if(cues.list[[l,2]] == currChunk[k]){
					cues.list[[l,3]] <<- as.numeric(cues.list[[l,3]])+1
				}
			}
		}

		i=i+1
		currChunk = chunks[[i,1]]
	}
	ret.que <<- array(c(ind,rep(0,length(ind))), c(length(ind),2))
}


######################################################
# computes spreading of activation
######################################################

compute.act.spreading <- function(){
	if(verbose.func){
		print("in compute.act.spreading", quote=FALSE)
		}


	W = par.ga/(length(cues.list[,2]) - 1 + 1)
	#! length '- 1' to exclude 'type' feature
	#! length '+ 1' to exclude 'goal-cat' feature which is normally part of the goal buffer
	
	i=1
	while(i<=length(ret.que[,1])){
		currChunk = chunks[[ret.que[i,1],1]]
		
		j=2
		while(j <=length(cues.list[,2])){

			k=1
			while(k <=length(currChunk)){
				if(cues.list[[j,2]] == currChunk[k]){
				  
				  # UP-2020 ----
				  # modified equation for S_ji ('spread') to accommodate cue weighting
				  # 
					# spread = (par.mas - log(as.numeric(cues.list[[j,3]])))
					spread = (par.mas*cue.weight[cues.list[[j,1]],1] - log(as.numeric(cues.list[[j,3]])))
					# ------------
					
					act = W * spread

					if(verbose){
					print(paste("spreading act", act, "(W =", W, ", Sij =", spread, ") from", 
					            cues.list[[j,2]], "to chunk", currChunk[["name"]]), quote=FALSE)
					}

					ret.que[i,2] <<- ret.que[i,2] + act
					}
				k=k+1
				}
			j=j+1
			}
		i=i+1
		}
	}


######################################################
# computes base activation and adds noise for each
# chunk in the retrieval que
######################################################

compute.base.act <- function(){
	if(verbose.func){
		print("in compute.base.act", quote=FALSE)
		}

	i=1
	while(i<=length(ret.que[,1])){
		currChunk = chunks[[ret.que[i,1],1]]
		
#		ret.que[i,2] <<- ret.que[i,2] + Bi(as.numeric(currChunk["npres"]), (currTime-as.numeric(currChunk["ctime"]))) + noise(0, par.ans)
		ret.que[i,2] <<- ret.que[i,2] + Bi(ret.que[i,1]) + noise(0, par.ans)
		i=i+1
		}
	}


######################################################
# base level activation formula
######################################################

Bi <- function(chunkNo){
	if(verbose.func){
		print("in Bi", quote=FALSE)
		}

	ret = ret.hist[chunkNo,]

#! tj: duration since each retrieval
	ret = ifelse(ret==-1, 0, currTime-ret)
#! calculate: tj ^ -d
	ret = ifelse(ret==0, 0, ret^ (-1*par.bll))

	base = log(sum(ret))
	
	if(verbose){
	print(paste("Chunk:", chunks[[chunkNo,1]][["name"]]), quote=FALSE)
	print(paste("Base level: ", base), quote=FALSE)
	}

#	base=log(npres/(1-par.bll)) - (par.bll*log(lifeTime))
#	print(paste("Base level: ", base))

#	sq = c(1:npres)
#	base = log(sum((sq * lifeTime/npres) ^ (-1*par.bll)))
	
	return(base)
	}


######################################################
# logistic noise
######################################################

noise <- function(location, scale){
	if(verbose.func){
		print("in noise", quote=FALSE)
		}

	n = rlogis(1, location=location, scale=scale)
	#! location = mean of the logistic distribution
	#! scale = parameter for calculating variance of the logistic distribution
	
  if(verbose){
  print(paste("Noise: ", n), quote=FALSE)
	}

  return(n)
	}


######################################################
# retrieval time
######################################################

ret.latency <- function(act){
	return(par.lf*exp(-(act)))
	}


######################################################
# computes partial matching between cues
# and chunks
######################################################

compute.partial.match <- function(){
	if(verbose.func){
		print("in compute.partial.match", quote=FALSE)
		}

	i=1
	while(i <= length(ret.que[,1])){
		currChunk = chunks[[ret.que[i,1],1]]
		
		j=2
		while(j <= length(cues.list[,2])){
			if(!is.null(currChunk[[cues.list[[j,1]]]])){
			if(cues.list[[j,2]] == currChunk[[cues.list[[j,1]]]]){
				
				if(verbose){
				  print(paste("similarity between", cues.list[[j,2]], "and", currChunk[[cues.list[[j,1]]]], "in chunk", currChunk[["name"]], "is", par.ms), quote=FALSE)
				  }
				ret.que[i,2] <<- ret.que[i,2] + (par.mp * par.ms)
				}
			else{

				if(verbose){
				  print(paste("similarity between", cues.list[[j,2]], "and", currChunk[[cues.list[[j,1]]]], "in chunk", currChunk[["name"]], "is", par.md), quote=FALSE)
				  }
				ret.que[i,2] <<- ret.que[i,2] + (par.mp * par.md)
				}
			}
			j=j+1
			}
		i=i+1
		}

	}


######################################################
# sorts the retrieval que on the activations of 
# the chunks
######################################################

sort.retQ <- function(){
	tmp = cbind(ret.que[order(ret.que[,2], decreasing=TRUE),1], ret.que[order(ret.que[,2], decreasing=TRUE),2])
	ret.que <<- tmp
	}




######################################################
# Run the model
######################################################

run.model <- function(model, dir, run){
  output.ret <<- array(, c(sims,stages))
  output.time <<- array(, c(sims,stages))
  output.latency <<- array(, c(sims,stages))
  output.prod <<- array(, c(sims,stages))

  act.out <<- matrix(nrow = 1, ncol = 8)
  
  params = as.data.frame(rbind(c(par.ga, par.mas, par.bll, par.ans, par.lf, par.rt, par.mp, par.ms, par.md, par.dat, par.egs)))
  colnames(params)=c("goal.act", "mas", "decay", "act.noise", "latency", "ret.thr", "match.sc", "max.sim", "max.diff", "prod.tm", "prod.noise")
  
  	if(verbose){
  print(params, quote=FALSE)
  }
  
  for(s in c(1:sims)){
  source(model)

	currSim <<- s

  source("../global-var.R")

	# print the simulation number after every 10% of the simulations 
	if(s%%(sims/10) == 0){
		cat(paste(" ", s))
		}

	if(verbose){
	print("",quote=FALSE)
	print("",quote=FALSE)
	print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-", quote=FALSE)
	print(paste("                    Simulation", s, "                    "), quote=FALSE)
	print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-", quote=FALSE)
      }

for(i in c(1:stages)){

  # UP: 01.11.2021
  # moved here from below since this is where it should be
  currStage <<- i

    
  if(i==picCreStage){
 		add.time(par.dat, txt='PC')

		if(verbose){
			print(paste("------ Adding picture chunks -------"), quote=FALSE)
		}
 	  
 	  p.knopf[["ctime"]] = currTime
		add.chunk(p.knopf)

		p.flasche[["ctime"]] = currTime
		add.chunk(p.flasche)
		
		if(EXPT1){
		  p.ballon[["ctime"]] = currTime
		  add.chunk(p.ballon)
		  
		  p.blume[["ctime"]] = currTime
		  add.chunk(p.blume)
		}
		
		martin[["ctime"]] = currTime
		add.chunk(martin)

		sarah[["ctime"]] = currTime
		add.chunk(sarah)
		
 	}

  
	if(verbose){
	print("",quote=FALSE)
	print(paste("===============  ", "Stage ", i, ":", input.stages[i], "  ==============="), quote=FALSE)
	}

  # UP: 18.10.2021
  # The following 4 steps are carried out only when there is an input word
if(lex.ret[i]){
  #! time for: 'Find-Location-Of-Next-Word'
  add.time(par.dat, txt='FndL')
  if(verbose){
    print(paste("Production fired:", "Find-Location-Of-Next-Word"), quote=FALSE)
  }
  
  #! time for: 'Attend-To-Next-Word'
  add.time(par.dat, txt='ATNW')
  if(verbose){
    print(paste("Production fired:", "Attend-To-Next-Word"), quote=FALSE)
  }
  
  #! time for visual encoding of the word
  add.time(0.085, txt='VisEn')
  if(verbose){
    print("Visual encoding done", quote=FALSE)
  }
  
  #! time for: lexical-retrieval-request
  add.time(par.dat, txt='LexRt')
  if(verbose){
    print(paste("Production fired:", " Lexical-Retrieval-Request-", input.stages[i], sep=""), quote=FALSE)
  }
}

  # UP: 01.11.2021
  # moved up.. at the begining of the loop
  # currStage <<- i
  
	currStep <<- conflict.resolution(i)
	
	check.goal()
	
	ret = ret.steps[[currStep,1]]
	
	if(verbose){
		print(paste("Production selected:", prods.names[currStep]), quote=FALSE)
	}

	output.prod[currSim,currStage] <<- prods.names[currStep]
	
#! time for: Set-Retrieval-Cues
	add.time(par.dat, txt='SetRC')
	if(verbose){
		print(paste("Production fired:", " Set-Retrieval-Cues-", input.stages[i], sep=""), quote=FALSE)
	}

	if(length(names(ret))>0){
		if(verbose){ print("------- retrieval --------", quote=FALSE)}

		retrieval.request(ret)
		retrieve()
	}


#! check if there is any new chunk creation
	if((length(names(vp.steps[[currStep,1]])) > 0)||
		(length(names(np.steps[[currStep,1]])) > 0)||
		(length(names(dp.steps[[currStep,1]])) > 0)||
		(length(names(ip.steps[[currStep,1]])) > 0)||
		(length(names(cp.steps[[currStep,1]])) > 0)||
		(length(names(adjp.steps[[currStep,1]])) > 0)||
		(length(names(pp.steps[[currStep,1]])) > 0))
	{
		newChunkCreation = TRUE
		}
	else{
		newChunkCreation = FALSE
		}

	
	if(length(names(lhs.steps[[currStep,1]])) > 0 || newChunkCreation){
	#! if there is a productions that has a '=retrieval' or that creates new chunks then add time
		add.time(par.dat, txt='Att')
		if(verbose){
			print(paste("Production fired:", " Attach-", input.stages[i], sep=""), quote=FALSE)
			}
		}

	if(newChunkCreation){
		if(verbose){
			print("------- creation --------", quote=FALSE)
			}

		#! create new chunks in various buffers (VPb, NPb etc.)
		cre = vp.steps[[currStep,1]]
		if(length(names(cre)) > 0){
			cre[["ctime"]] = currTime
			cre[["npres"]] = 1
			add.chunk(cre)
			}
		
		cre = np.steps[[currStep,1]]
		if(length(names(cre)) > 0){
			cre[["ctime"]] = currTime
			cre[["npres"]] = 1
			add.chunk(cre)
			}
		
		cre = dp.steps[[currStep,1]]
		if(length(names(cre)) > 0){
			cre[["ctime"]] = currTime
			cre[["npres"]] = 1
			add.chunk(cre)
			}
		
		cre = ip.steps[[currStep,1]]
		if(length(names(cre)) > 0){
			cre[["ctime"]] = currTime
			cre[["npres"]] = 1
			add.chunk(cre)
			}
		
		cre = cp.steps[[currStep,1]]
		if(length(names(cre)) > 0){
			cre[["ctime"]] = currTime
			cre[["npres"]] = 1
			add.chunk(cre)
			}
		
		cre = adjp.steps[[currStep,1]]
		if(length(names(cre)) > 0){
			cre[["ctime"]] = currTime
			cre[["npres"]] = 1
			add.chunk(cre)
			}
		
		cre = pp.steps[[currStep,1]]
		if(length(names(cre)) > 0){
			cre[["ctime"]] = currTime
			cre[["npres"]] = 1
			add.chunk(cre)
			}
		
	}
	# UP 2020
	# at this point the list 'cues.list' should be emptied
	# since it contains the retrieval cues (which spread activation)
	cues.list <<- NULL
	}

	chunks <<- array(list(NULL), c(maxChunks,1))

	}
	dt.ret <<- as.data.frame(output.ret)
	dt.time <<- as.data.frame(output.time)
#	dt.latency <<- as.data.frame(output.latency)
	dt.prod <<- as.data.frame(output.prod)
	
	# UP 2020
	dt.out <<- as.data.frame(act.out)
	# colnames(dt.out) <<- c("simNo", "stepNo", "time", "knopf.act", "flasche.act")
	colnames(dt.out) <<- c("simNo", "stepNo", 'step', "time", "knopf.act", "flasche.act", "ballon.act", "blume.act")
	
	colnames(dt.ret) <<- input.stages
	colnames(dt.time) <<- input.stages
#	colnames(dt.latency) <<- input.stages
	colnames(dt.prod) <<- input.stages


	write.table(params, paste(dir,"/params-", run, ".txt", sep=""), quote=FALSE, row.names=FALSE)
	write.table(dt.ret, paste(dir, "/retrievals-", run, ".txt", sep=""), quote=FALSE, row.names=FALSE)
#	write.table(dt.latency, paste(dir, "/ret-latency-", run, ".txt", sep=""), quote=FALSE, row.names=FALSE)

	write.table(dt.time, paste(dir, "/ret-times-", run, ".txt", sep=""), quote=FALSE, row.names=FALSE)
	write.table(dt.out, paste(dir, "/act-out-", run, ".txt", sep=""), quote=FALSE, row.names=FALSE)
	# write.table(dt.prod, paste(dir,"/productions-", run, ".txt", sep=""), quote=FALSE, row.names=FALSE)

	write.table(cue.weight, paste(dir,"/weights-", run, ".txt", sep=""), quote=FALSE, col.names = FALSE)
	}

