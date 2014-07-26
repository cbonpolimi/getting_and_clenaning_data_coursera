
#read all the files from my Github directory
setwd("C:\\Users\\Carlo\\Documents\\GitHub\\getting_and_clenaning_data_coursera\\UCI HAR Dataset")
features<-read.table("features.txt")
activity_labels<-read.table("activity_labels.txt")

#test files
setwd("C:\\Users\\Carlo\\Documents\\GitHub\\getting_and_clenaning_data_coursera\\UCI HAR Dataset\\test")
rawtest<-read.table("X_test.txt")
ytest<-read.table("y_test.txt")
subjecttest<-read.table("subject_test.txt")

#train files

setwd("C:\\Users\\Carlo\\Documents\\GitHub\\getting_and_clenaning_data_coursera\\UCI HAR Dataset\\train")
rawtrain<-read.table("X_train.txt")
ytrain<-read.table("y_train.txt")
subjecttrain<-read.table("subject_train.txt")

#after reading all files we give columns the corrects labels from the file "features.txt"

names(rawtest)<-features[,2]
names(rawtrain)<-features[,2]


#after labeling the two datasets we merge them 

merged<-rbind(rawtest,rawtrain)


#then we only take those column that have mean in the name

mean<-merged[grep("mean()",names(merged))]

#it takes also meanFreq() so we have to filter the data by subsetting the dataframe

Freq<-mean[grep("Freq()",names(mean))]

# and make a subset of the values that are  different from the Freq dataframe

meanfinal <- mean[names(mean)[!names(mean) %in% names(Freq)]]

#another dataframe only for standard deviation

std<-merged[grep("std()",names(merged))]

#Finally we bind the two dataframe by column

merged_final<-cbind(meanfinal,std)

#then we label the dataset
#First we merge the subjects datasets
merged_subject<-rbind(subjecttest,subjecttrain)

# and give a name to the subject column

names(merged_subject)<-"subject"

#In the end, we bind the column to the dataframe we create earlier containing all the observations

merged_final$subject <- merged_subject[,1]

#Second, we merge the activity labels

merged_y<-rbind(ytest,ytrain)

#and give a name to the y column

names(merged_y)<-"activity"

#In the end we merged this dataframe with the activity labels description so that we know for 
#each row what type of activity the subject made

activities<-merge(merged_y,activity_labels,by.x="activity",by.y="V1") 

#In final dataframe we bind the column relative to the activities at the end of the dataframe 

merged_final$activity<-activities[,2]

#at the very end of the script I simply write on ".txt" file format the dataframe 

setwd("C:\\Users\\Carlo\\Documents\\GitHub\\getting_and_clenaning_data_coursera\\UCI HAR Dataset")

write.table(merged_final,"tidy_data_sets.txt",row.names=F)



#In the second part of the project we are going to create another dataset with the mean 
#of each variable for each activity and each subject 

## To accomplish this, we first need to bind the raw data set (with both test and train data)
#with the subject data that earlier in the project we made 

merged<-rbind(rawtest,rawtrain)

merged$subject <- merged_subject[,1]

#Then we use the split function to divide the dataframe by subject 

subject_split<- split(merged,merged["subject"])

#and apply the function colMeans so that we have the mean for each variable

list_mean_by_subject<-lapply(subject_split,function(x) colMeans(x,na.rm=FALSE))

mean_by_subject<-do.call(rbind.data.frame,list_mean_by_subject)

#Then we bind the features dataframe to the mean_by_subject  dataframe so that names of the variable are correct again
#but first I create a new dataframe to add to the features dataframe the row that indicates that observation in the last column are subject

newrow<-data.frame(c("562"),"subject")

names(newrow)<-names(features)

features1<-rbind(features,newrow)

names(mean_by_subject)<-features1[,2]

#Finally we write the table to your convenience into a text format

setwd("C:\\Users\\Carlo\\Documents\\GitHub\\getting_and_clenaning_data_coursera\\UCI HAR Dataset")

write.table(mean_by_subject,"mean_by_subject.txt",row.names=FALSE)


## everything I've done with the subject data I'll do exactly with the split for activities dataset. 

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

setwd("C:\\Users\\Carlo\\Documents\\GitHub\\getting_and_clenaning_data_coursera\\UCI HAR Dataset")

write.table(mean_by_activity_final,"mean_by_activity.txt",row.names=FALSE)
