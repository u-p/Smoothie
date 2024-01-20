
#-------------------------------------------------
#
# Model predictions for INDEF_DET condition
# Sentence ['match' condition]: Klicke auf einen blauen Knopf
#
# Processing steps: 
# "Klicke_auf" "einen" <PICTURE RETRIEVAL_1> "blauen" <PICTURE RETRIEVAL_2> "Knopf" <PICTURE RETRIEVAL_3>
# 
# ToDo's:
#   . remove extra productions from <PICTURE RETRIEVA> steps such as 'Lexical-Retrieval-Request' etc.
#   . change the variable 'stages' to 'input_words' or something similarly informative
# 
# 
# Author: Umesh Patil (umesh.patil@gmail.com)
#
#-------------------------------------------------



## -- Goal chunk --
goal.chunk <- list(type="comprehend-sentence", name="")


## -- Picture chunks --
p.knopf   = list(type="syn-obj", ctime=0, npres=1, name="knopf", cat="DP", gend="masc", col="blau", animacy="inani", ref="pic")
p.flasche = list(type="syn-obj", ctime=0, npres=1, name="flasche", cat="DP", gend="fem", col="blau", animacy="inani", ref="pic")

martin    = list(type="syn-obj", ctime=0, npres=1, name="martin", cat="DP", gend="masc", animacy="ani")
sarah     = list(type="syn-obj", ctime=0, npres=1, name="sarah", cat="DP", gend="fem", animacy="ani")



## -- Goal buffer modification steps --

goal.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
det          = list(NULL)
#det.antc     = list(NULL)
p.match.det  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

goal.steps[[1,1]] = empty
goal.steps[[2,1]] = klicke_auf
goal.steps[[3,1]] = det
#goal.steps[[4,1]] = det.antc
goal.steps[[4,1]] = p.match.det
goal.steps[[5,1]] = blauen
goal.steps[[6,1]] = p.match.blauen
goal.steps[[7,1]] = knopf
goal.steps[[8,1]] = p.match.knopf


## -- Retrieval steps --
ret.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(type="syn-obj", cat="IP")
det          = list(type="syn-obj", cat="VP")
#det.antc     = list(type="syn-obj", cat="DP", gend="masc", animacy="ani")
p.match.det  = list(type="syn-obj", cat="DP", gend="masc", animacy="inani", ref="pic")
blauen          = list(type="syn-obj", cat="NP-empty", gend="masc.PRED", case="acc.PRED")
p.match.blauen  = list(type="syn-obj", cat="DP", gend="masc", animacy="inani", ref="pic", col="blau")
knopf           = list(type="syn-obj", cat="DP", gend="masc", animacy="inani", name="knopf", col="blau")
p.match.knopf   = list(type="syn-obj", cat="DP", gend="masc", animacy="inani", ref="pic", col="blau", name="knopf")

ret.steps[[1,1]] = empty
ret.steps[[2,1]] = klicke_auf
ret.steps[[3,1]] = det
#ret.steps[[4,1]] = det.antc
ret.steps[[4,1]] = p.match.det
ret.steps[[5,1]] = blauen
ret.steps[[6,1]] = p.match.blauen
ret.steps[[7,1]] = knopf
ret.steps[[8,1]] = p.match.knopf


## -- LHS steps --
# The LHS of the production rule that has to be satisfied
# mainly the constraints on the retrieval buffer contents ("harvesting").
# It's the condition that has to be satisfied before carrying
# out the creation step.

lhs.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(type="syn-obj", cat="IP")
det          = list(type="syn-obj", cat="VP")
#det.antc     = list(type="syn-obj", cat="DP")
p.match.det  = list(type="syn-obj", cat="DP", ref="pic")
blauen          = list(type="syn-obj", cat="NP-empty")
p.match.blauen  = list(type="syn-obj", cat="DP", ref="pic")
knopf           = list(type="syn-obj", cat="DP")
p.match.knopf   = list(type="syn-obj", cat="DP", ref="pic")

lhs.steps[[1,1]] = empty
lhs.steps[[2,1]] = klicke_auf
lhs.steps[[3,1]] = det
#lhs.steps[[4,1]] = det.antc
lhs.steps[[4,1]] = p.match.det
lhs.steps[[5,1]] = blauen
lhs.steps[[6,1]] = p.match.blauen
lhs.steps[[7,1]] = knopf
lhs.steps[[8,1]] = p.match.knopf



## -- Creation steps --
# 1. VP
vp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(type="syn-obj", cat="VP", name="klicke_auf", spec="t_s")
det          = list(NULL)
#det.antc     = list(NULL)
p.match.det  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

vp.steps[[1,1]] = empty
vp.steps[[2,1]] = klicke_auf
vp.steps[[3,1]] = det
#vp.steps[[4,1]] = det.antc
vp.steps[[4,1]] = p.match.det
vp.steps[[5,1]] = blauen
vp.steps[[6,1]] = p.match.blauen
vp.steps[[7,1]] = knopf
vp.steps[[8,1]] = p.match.knopf


# 2. NP
np.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
det          = list(type="syn-obj", name="empty-np", cat="NP-empty", gend="masc.PRED", case="acc.PRED")
#det.antc     = list(NULL)
p.match.det  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

np.steps[[1,1]] = empty
np.steps[[2,1]] = klicke_auf
np.steps[[3,1]] = det
#np.steps[[4,1]] = det.antc
np.steps[[4,1]] = p.match.det
np.steps[[5,1]] = blauen
np.steps[[6,1]] = p.match.blauen
np.steps[[7,1]] = knopf
np.steps[[8,1]] = p.match.knopf


# 3. DP
dp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
det          = list(type="syn-obj", name="empty-dp", cat="DP-empty", head="seinen", gend="masc.PRED", case="acc.PRED")
#det.antc     = list(NULL)
p.match.det  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

dp.steps[[1,1]] = empty
dp.steps[[2,1]] = klicke_auf
dp.steps[[3,1]] = det
#dp.steps[[4,1]] = det.antc
dp.steps[[4,1]] = p.match.det
dp.steps[[5,1]] = blauen
dp.steps[[6,1]] = p.match.blauen
dp.steps[[7,1]] = knopf
dp.steps[[8,1]] = p.match.knopf


# 4. IP
ip.steps = array(list(NULL), c(steps,1))

empty           = list(type="syn-obj", cat="IP", name="ip")
klicke_auf      = list(NULL)
det          = list(NULL)
#det.antc     = list(NULL)
p.match.det  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

ip.steps[[1,1]] = empty
ip.steps[[2,1]] = klicke_auf
ip.steps[[3,1]] = det
#ip.steps[[4,1]] = det.antc
ip.steps[[4,1]] = p.match.det
ip.steps[[5,1]] = blauen
ip.steps[[6,1]] = p.match.blauen
ip.steps[[7,1]] = knopf
ip.steps[[8,1]] = p.match.knopf


# 5. CP
cp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
det          = list(NULL)
#det.antc     = list(NULL)
p.match.det  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

cp.steps[[1,1]] = empty
cp.steps[[2,1]] = klicke_auf
cp.steps[[3,1]] = det
#cp.steps[[4,1]] = det.antc
cp.steps[[4,1]] = p.match.det
cp.steps[[5,1]] = blauen
cp.steps[[6,1]] = p.match.blauen
cp.steps[[7,1]] = knopf
cp.steps[[8,1]] = p.match.knopf


# 6. PP
pp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
det          = list(NULL)
#det.antc     = list(NULL)
p.match.det  = list(NULL)
blauen          = list(NULL)
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

pp.steps[[1,1]] = empty
pp.steps[[2,1]] = klicke_auf
pp.steps[[3,1]] = det
#pp.steps[[4,1]] = det.antc
pp.steps[[4,1]] = p.match.det
pp.steps[[5,1]] = blauen
pp.steps[[6,1]] = p.match.blauen
pp.steps[[7,1]] = knopf
pp.steps[[8,1]] = p.match.knopf


# 7. AdjP
adjp.steps = array(list(NULL), c(steps,1))

empty           = list(NULL)
klicke_auf      = list(NULL)
det          = list(NULL)
#det.antc     = list(NULL)
p.match.det  = list(NULL)
blauen          = list(type="syn-obj", cat="AdjP", name="blauen", gend="masc", case="acc")
p.match.blauen  = list(NULL)
knopf           = list(NULL)
p.match.knopf   = list(NULL)

adjp.steps[[1,1]] = empty
adjp.steps[[2,1]] = klicke_auf
adjp.steps[[3,1]] = det
#adjp.steps[[4,1]] = det.antc
adjp.steps[[4,1]] = p.match.det
adjp.steps[[5,1]] = blauen
adjp.steps[[6,1]] = p.match.blauen
adjp.steps[[7,1]] = knopf
adjp.steps[[8,1]] = p.match.knopf


## -- Utility values for steps --
# util.steps[*,1] = stage no.
# util.steps[*,2] = utility value of the step

util.steps = array(, c(steps,2))

empty           = c(1,0)
klicke_auf      = c(2,0)
det          = c(3,0)
#det.antc     = c(4,0)
p.match.det  = c(4,0)
blauen          = c(5,0)
p.match.blauen  = c(6,0)
knopf           = c(7,0)
p.match.knopf   = c(8,0)

util.steps[1,] = empty
util.steps[2,] = klicke_auf
util.steps[3,] = det
#util.steps[4,] = det.antc
util.steps[4,] = p.match.det
util.steps[5,] = blauen
util.steps[6,] = p.match.blauen
util.steps[7,] = knopf
util.steps[8,] = p.match.knopf


## -- input stages
input.stages = c("empty", "klicke_auf", "det", "p.match.det", "blauen", "p.match.blauen", "knopf", "p.match.knopf")
prods.names = c("empty", "klicke_auf", "det", "p.match.det", "blauen", "p.match.blauen", "knopf", "p.match.knopf")
lex.ret = c(0, 1, 1, 0, 1, 0, 1, 0) # denotes if there is lexical input at that stage


