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


## -- ACT-R parameters --

# W_goal: goal activation
par.ga = 1

# S: the max. ass. strength
# par.mas = 1.5

# UP-2020
par.mas = 3


# d: decay parameter
par.bll = 0.5

# activation noise
#par.ans = 0.15
# par.ans=0.35

# UP-2020
par.ans=0.25
# par.ans=0.1
# par.ans=0.35


# F: latency factor
#par.lf = 0.14
par.lf = 0.04

# τ: retrieval threshold
par.rt = -1.5

# P: match scale
# par.mp = 1.0
# UP-2020
par.mp = 0.25

# maximum similarity
par.ms = 0

# maximum difference (penalty)
#par.md = -0.6
par.md = -1
# UP-2020
# par.md = 0


# default action time (production firing time)
par.dat = 0.05

# s: noise in the production utility
#par.egs = 0.05
par.egs = 0
#par.egs = 0.1


