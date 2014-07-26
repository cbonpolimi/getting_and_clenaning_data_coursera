CodeBook
===================================


This repo explains how all of the scripts work and how they are connected. 

In this file I will explain each variable I create and use to perform the analysis:

1.read all the files from my Github local directory

 features: contains the file features into the main directory
 activity_labels: labels of the activity like WALKING etc..

2.read all files in the \test directory

 rawtest: correspond to the "X_test.txt" file 
 ytest: correspond to the "y_test.txt"
 subjecttest: correspond to the "subject_test.txt"

3. same with \train directory

 rawtrain: "X_train.txt"
 ytrain: correspond to the "y_train.txt"
 subjecttrain: correspond to the "subject_train.txt"

4. after reading all files we give columns the corrects labels from the file "features.txt"

 names(rawtest)<-features[,2]
 names(rawtrain)<-features[,2]

5. after labeling the two datasets we merge them 

 merged: correspond to the function rbind of the two rw datasets


6. then we only take those column that have mean in the name

 mean: made using grep("mean") on the merged dataframe

7. Because it takes also column containing "meanFreq()", we have to filter the data by subsetting the dataframe

 Freq:is the variable that takes only value containingFreq

8. After that, we make a subset of the values that are  different from the Freq dataframe

 meanfinal:is the final result, obtained by subsetting the mean by difference from Freq

9.same as for standard deviation

 std: dataframe only for standard deviation

10.Finally we bind the two dataframe by column

merged_final: result of the binding by column of the two dataframe mean_final and std 

11.We label the dataset:

		a. First we merge the subjects datasets
		merged_subject<-rbind(subjecttest,subjecttrain)

		b. Give a name to the subject column
		names(merged_subject)<-"subject"

		c.In the end, we bind the column to the dataframe we create earlier containing all the observations

		merged_final$subject <- merged_subject[,1]

		d. Second, we merge the activity labels

		merged_y: the result of binding "ytest" and "ytrain"

		e.and give a name to the y column

		names(merged_y)<-"activity"

12. In the end we merged this dataframe with the activity labels description so that we know for 
each row what type of activity the subject made

activities<-merge(merged_y,activity_labels,by.x="activity",by.y="V1") 

13. In final dataframe we bind the column relative to the activities at the end of the dataframe 

merged_final$activity<-activities[,2]


===================================
SECOND PART

In the second part of the project we are going to create another dataset with the mean 
of each variable for each activity and each subject 

1. To accomplish this, we first need to bind the raw data set (with both test and train data)
   with the subject data that earlier in the project we made 

	merged<-rbind(rawtest,rawtrain)

	merged$subject <- merged_subject[,1]

2.Then we use the split function to divide the dataframe by subject 

	subject_split<- split(merged,merged["subject"])

3. Apply the function colMeans so that we have the mean for each variable and transform it into a dataframe with do.call

	list_mean_by_subject<-lapply(subject_split,function(x) colMeans(x,na.rm=FALSE))

	mean_by_subject<-do.call(rbind.data.frame,list_mean_by_subject)

4. Then we bind the features dataframe to the mean_by_subject  dataframe so that names of the variable are correct again
    but first I create a new dataframe to add to the features dataframe the row that indicates that observation in the last column are subject

	newrow<-data.frame(c("562"),"subject")

	names(newrow)<-names(features)

	features1<-rbind(features,newrow)

	names(mean_by_subject)<-features1[,2]



1. Everything I've done with the subject data I'll do exactly with the split for activities dataset. 

	merged<-rbind(rawtest,rawtrain)

	merged$activity<-activities[,1]

	activity_split<-split(merged,merged["activity"])

	list_mean_by_activity<-lapply(activity_split,function(x) colMeans(x,na.rm=FALSE))

	mean_by_activity<-do.call(rbind.data.frame,list_mean_by_activity)
  
	newrow_activity<-data.frame(c("562"),"activity")

	names(newrow_activity)<-names(features)

	features_activity<-rbind(features,newrow_activity)

	names(mean_by_activity)<-features_activity[,2]

	mean_by_activity_final$activity<-activity_labels[,2]


