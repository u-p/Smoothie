. The three CSVs in this folder contain predictions for the three conditions:
	1. predictions-cond-BASELINE.csv
	2. predictions-cond-MATCH.csv
	3. predictions-cond-MISMATCH.csv


. The CSVs have the following columns:
	simNo: 			the number of the simulation
	
	stepNo:			the step number within each simulation; 
					MATCH and MISMATCH conditions have 9 steps whereas DET condition has 8

	subStep:		acronymized name for substeps
					NOTE: 
					. The substep names are not unique (even within a simulation); this is 
					because each substep is an ACT-R event and the same ACT-R event can
					(and does) occur multiple times for a single simulation, e.g. firing
					of a production for encoding a word or a retrieval request. 
					. 'subStepsNo' captures the unique substep no. within each simulation.

	time:			time stamp for the begining of each step
	
	knopf.act: 		activation value for 'Knopf'
	
	flasche.act: 	activation value for 'Flasche'
	
	subStepsNo:		the subStep number within each step

	step:			step name

	flasche.fix: 	fixation on 'Flasche' (1 or 0)
	
	knopf.fix:		fixation on 'Knopf' (1 or 0)
