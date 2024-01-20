
#-------------------------------------------------
#
# Model of Stone_et_al (2021) Experiment-2 MISMATCH condition
# Sentence ['mismatch' condition]: Klicke auf ihren blauen Knopf
#
# Processing steps: 
# "Klicke_auf" "ihren" <ANTECEDENT RETRIEVAL> <PICTURE RETRIEVAL_1> "blauen" <PICTURE RETRIEVAL_2> "Knopf" <PICTURE RETRIEVAL_3>
# 
# Author: Umesh Patil (umesh.patil@gmail.com)
#
#-------------------------------------------------



## -- Goal chunk --
goal.chunk <- list(type="comprehend-sentence", name="")


## -- Picture chunks --
p.knopf   = list(type="syn-obj", 
                 ctime=0, 
                 npres=1, 
                 name="knopf", 
                 cat="DP", 
                 gend="masc", 
                 col="blau", 
                 animacy="inani", 
                 ref="pic"
                 )

p.flasche = list(type="syn-obj", 
                 ctime=0, 
                 npres=1, 
                 name="flasche", 
                 cat="DP", 
                 gend="fem", 
                 col="blau", 
                 animacy="inani", 
                 ref="pic"
                 )

# The chunk for the question mark "Fragezeichen"
# 
# Sol Lago: [20.01.2024]
# 1. The question mark chunk in memory should not have a gender feature 
# (e.g., “neuter”). This is because participants are told that 
# the question mark stands for “owner of the object unknown”. 
# Therefore, the question mark symbol is not part of the linguistic input. 
# It’s not mapped to a specific linguistic element, it’s just a place holder 
# for “unknown” or “undefined”.
# 2. The question mark is shown in black
p.fragezeichen = list(type="NA-obj", 
                      ctime=0, 
                      npres=1, 
                      name="fragezeichen", 
                      col="schwarz", 
                      ref="pic"
                      )

martin    = list(type="syn-obj", ctime=0, npres=1, name="martin", cat="DP", gend="masc", animacy="ani")
sarah     = list(type="syn-obj", ctime=0, npres=1, name="sarah", cat="DP", gend="fem", animacy="ani")


## -- Goal buffer modification steps --

goal.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
possPro          = list(NULL)
possPro.antc     = list(NULL)
p.match.possPro  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

goal.steps[[1,1]] = empty
goal.steps[[2,1]] = klicke_auf
goal.steps[[3,1]] = possPro
goal.steps[[4,1]] = possPro.antc
goal.steps[[5,1]] = p.match.possPro
goal.steps[[6,1]] = blauen
goal.steps[[7,1]] = p.match.blauen
goal.steps[[8,1]] = knopf
goal.steps[[9,1]] = p.match.knopf


## -- Retrieval steps --
ret.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(type="syn-obj", cat="IP")
possPro          = list(type="syn-obj", cat="VP")
possPro.antc     = list(type="syn-obj", cat="DP", gend="fem", animacy="ani")
p.match.possPro  = list(type="syn-obj", cat="DP", gend="masc", animacy="inani", ref="pic")
blauen          = list(type="syn-obj", cat="NP-empty", gend="masc.PRED", case="acc.PRED")
p.match.blauen  = list(type="syn-obj", cat="DP", gend="masc", animacy="inani", ref="pic", col="blau")
knopf           = list(type="syn-obj", cat="DP", gend="masc", animacy="inani", name="knopf", col="blau")
p.match.knopf   = list(type="syn-obj", cat="DP", gend="masc", animacy="inani", ref="pic", col="blau", name="knopf")

ret.steps[[1,1]] = empty
ret.steps[[2,1]] = klicke_auf
ret.steps[[3,1]] = possPro
ret.steps[[4,1]] = possPro.antc
ret.steps[[5,1]] = p.match.possPro
ret.steps[[6,1]] = blauen
ret.steps[[7,1]] = p.match.blauen
ret.steps[[8,1]] = knopf
ret.steps[[9,1]] = p.match.knopf


## -- LHS steps --
# The LHS of the production rule that has to be satisfied
# mainly the constraints on the retrieval buffer contents ("harvesting").
# It's the condition that has to be satisfied before carrying
# out the creation step.

lhs.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(type="syn-obj", cat="IP")
possPro          = list(type="syn-obj", cat="VP")
possPro.antc     = list(type="syn-obj", cat="DP")
p.match.possPro  = list(type="syn-obj", cat="DP", ref="pic")
blauen          = list(type="syn-obj", cat="NP-empty")
p.match.blauen  = list(type="syn-obj", cat="DP", ref="pic")
knopf           = list(type="syn-obj", cat="DP")
p.match.knopf   = list(type="syn-obj", cat="DP", ref="pic")

lhs.steps[[1,1]] = empty
lhs.steps[[2,1]] = klicke_auf
lhs.steps[[3,1]] = possPro
lhs.steps[[4,1]] = possPro.antc
lhs.steps[[5,1]] = p.match.possPro
lhs.steps[[6,1]] = blauen
lhs.steps[[7,1]] = p.match.blauen
lhs.steps[[8,1]] = knopf
lhs.steps[[9,1]] = p.match.knopf



## -- Creation steps --
# 1. VP
vp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(type="syn-obj", cat="VP", name="klicke_auf", spec="t_s")
possPro          = list(NULL)
possPro.antc     = list(NULL)
p.match.possPro  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

vp.steps[[1,1]] = empty
vp.steps[[2,1]] = klicke_auf
vp.steps[[3,1]] = possPro
vp.steps[[4,1]] = possPro.antc
vp.steps[[5,1]] = p.match.possPro
vp.steps[[6,1]] = blauen
vp.steps[[7,1]] = p.match.blauen
vp.steps[[8,1]] = knopf
vp.steps[[9,1]] = p.match.knopf


# 2. NP
np.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
possPro          = list(type="syn-obj", name="empty-np", cat="NP-empty", gend="masc.PRED", case="acc.PRED")
possPro.antc     = list(NULL)
p.match.possPro  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

np.steps[[1,1]] = empty
np.steps[[2,1]] = klicke_auf
np.steps[[3,1]] = possPro
np.steps[[4,1]] = possPro.antc
np.steps[[5,1]] = p.match.possPro
np.steps[[6,1]] = blauen
np.steps[[7,1]] = p.match.blauen
np.steps[[8,1]] = knopf
np.steps[[9,1]] = p.match.knopf


# 3. DP
dp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
possPro          = list(type="syn-obj", name="empty-dp", cat="DP-empty", head="seinen", gend="masc.PRED", case="acc.PRED")
possPro.antc     = list(NULL)
p.match.possPro  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

dp.steps[[1,1]] = empty
dp.steps[[2,1]] = klicke_auf
dp.steps[[3,1]] = possPro
dp.steps[[4,1]] = possPro.antc
dp.steps[[5,1]] = p.match.possPro
dp.steps[[6,1]] = blauen
dp.steps[[7,1]] = p.match.blauen
dp.steps[[8,1]] = knopf
dp.steps[[9,1]] = p.match.knopf


# 4. IP
ip.steps = array(list(NULL), c(steps,1))

empty           = list(type="syn-obj", cat="IP", name="ip")
klicke_auf      = list(NULL)
possPro          = list(NULL)
possPro.antc     = list(NULL)
p.match.possPro  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

ip.steps[[1,1]] = empty
ip.steps[[2,1]] = klicke_auf
ip.steps[[3,1]] = possPro
ip.steps[[4,1]] = possPro.antc
ip.steps[[5,1]] = p.match.possPro
ip.steps[[6,1]] = blauen
ip.steps[[7,1]] = p.match.blauen
ip.steps[[8,1]] = knopf
ip.steps[[9,1]] = p.match.knopf


# 5. CP
cp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
possPro          = list(NULL)
possPro.antc     = list(NULL)
p.match.possPro  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

cp.steps[[1,1]] = empty
cp.steps[[2,1]] = klicke_auf
cp.steps[[3,1]] = possPro
cp.steps[[4,1]] = possPro.antc
cp.steps[[5,1]] = p.match.possPro
cp.steps[[6,1]] = blauen
cp.steps[[7,1]] = p.match.blauen
cp.steps[[8,1]] = knopf
cp.steps[[9,1]] = p.match.knopf


# 6. PP
pp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
possPro          = list(NULL)
possPro.antc     = list(NULL)
p.match.possPro  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

pp.steps[[1,1]] = empty
pp.steps[[2,1]] = klicke_auf
pp.steps[[3,1]] = possPro
pp.steps[[4,1]] = possPro.antc
pp.steps[[5,1]] = p.match.possPro
pp.steps[[6,1]] = blauen
pp.steps[[7,1]] = p.match.blauen
pp.steps[[8,1]] = knopf
pp.steps[[9,1]] = p.match.knopf


# 7. AdjP
adjp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
possPro          = list(NULL)
possPro.antc     = list(NULL)
p.match.possPro  = list(NULL)
blauen          = list(type="syn-obj", cat="AdjP", name="blauen", gend="masc", case="acc")
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

adjp.steps[[1,1]] = empty
adjp.steps[[2,1]] = klicke_auf
adjp.steps[[3,1]] = possPro
adjp.steps[[4,1]] = possPro.antc
adjp.steps[[5,1]] = p.match.possPro
adjp.steps[[6,1]] = blauen
adjp.steps[[7,1]] = p.match.blauen
adjp.steps[[8,1]] = knopf
adjp.steps[[9,1]] = p.match.knopf


## -- Utility values for steps --
# util.steps[*,1] = stage no.
# util.steps[*,2] = utility value of the step

util.steps = array(, c(steps,2))

empty           = c(1,0)
klicke_auf      = c(2,0)
possPro          = c(3,0)
possPro.antc     = c(4,0)
p.match.possPro  = c(5,0)
blauen          = c(6,0)
p.match.blauen  = c(7,0)
knopf           = c(8,0)
p.match.knopf   = c(9,0)

util.steps[1,] = empty
util.steps[2,] = klicke_auf
util.steps[3,] = possPro
util.steps[4,] = possPro.antc
util.steps[5,] = p.match.possPro
util.steps[6,] = blauen
util.steps[7,] = p.match.blauen
util.steps[8,] = knopf
util.steps[9,] = p.match.knopf


## -- input stages
input.stages = c("empty", "klicke_auf", "possPro", "possPro.antc", "p.match.possPro", "blauen", "p.match.blauen", "knopf", "p.match.knopf")
prods.names = c("empty", "klicke_auf", "possPro", "possPro.antc", "p.match.possPro", "blauen", "p.match.blauen", "knopf", "p.match.knopf")
lex.ret = c(0, 1, 1, 0, 0, 1, 0, 1, 0) # denotes of there is lexical input at that stage



