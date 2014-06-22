CODEBOOK - Human Activity Recognition Using Smartphones Dataset

subject		1
	Study subjet (person)
		1..30 .Unique identifier assigned to each person in the study

activity	6..18
	Activities that each person performed while wearing a smartphone (Samsung Galaxy S II) on the waist.
		WALKING
		WALKING_UPSTAIRS
		WALKING_DOWNSTAIRS
		SITTING
		STANDING
		LAYING

The following 66 variables (columns) in the data set contain in a numeric value the average of each variable
for each activity and each subject. The variable (column) names are formed using the following codification:

At the beginnig of the variable name, if starts with:
	Time:	Variable calculated from the time domain.
	Freq:	Variable calculated from the frequency domain.

After Time or Freq it follows:
	Body:	 Body acceleration signal.
	Gravity: Gravity acceleration signal.

After Body or Gravity it follows:
	Acc:	Signal coming from Accelerometer sensor signal.
	Gyro:	Signal coming from Gyroscope sensor signal.

After Acc or Gyro it could follow:
	Mag:	Magnitude of these three-dimensional signals were calculated using the Euclidean norm.
	Jerk:	Jerk signals obtained from deriving the body linear acceleration and angular velocity.

After Mag or Jerk it follows:
	Mean:	Mean of all the set of values obtained for each subject person.
	Std:	Standard deviation of all the set of values obtained for each subject person.

After Mean or Std it follows:
	Xaxis:	Axial signal in the X direction.
	Yaxis:	Axial signal in the Y direction.
	Zaxis:	Axial signal in the Z direction.