#load test dataset and create variables for subject and activity
test_set = read.table("har_dataset/test/X_test.txt")
test_activity = read.table("har_dataset/test/y_test.txt")
test_subject = read.table("har_dataset/test/subject_test.txt",colClasses="factor")
test_activity = as.data.frame(factor(test_activity[,], 
                                     levels = c(1,2,3,4,5,6), 
                                     labels=c("WALKING",
                                              "WALKING_UPSTAIRS",
                                              "WALKING_DOWNSTAIRS",
                                              "SITTING",
                                              "STANDING",
                                              "LAYING")))
colnames(test_activity) = "activity"
colnames(test_subject) = "subject"
test_set = cbind(test_subject,test_activity,test_set)

#load training dataset and create variables for subject and activity
train_set = read.table("har_dataset/train/X_train.txt")
train_activity = read.table("har_dataset/train/y_train.txt")
train_subject = read.table("har_dataset/train/subject_train.txt", colClasses="factor")
train_activity = as.data.frame(factor(train_activity[,], 
                                      levels = c(1,2,3,4,5,6), 
                                      labels=c("WALKING",
                                               "WALKING_UPSTAIRS",
                                               "WALKING_DOWNSTAIRS",
                                               "SITTING",
                                               "STANDING",
                                               "LAYING")))
colnames(train_activity) = "activity"
colnames(train_subject) = "subject"
train_set = cbind(train_subject,train_activity,train_set)

#merge training and test datasets
full_set = rbind(test_set,train_set)

#remove temporary variables
rm(test_activity,test_subject,train_activity,train_subject,test_set,train_set)

#read in feature list and create logical vector to select means and standard deviations
features = read.table("har_dataset/features.txt",col.names=c("col","var"),colClasses=c("integer","character"))
split_features = do.call(rbind,strsplit(features$var,"-"))
selected_cols = split_features[,2] == "mean()" | split_features[,2]=="std()"
selected_cols = c(T,T,selected_cols)

#assign descriptive variable names
colnames(full_set) = c("subject","activity",features$var)

#remove unwanted variables from full dataset
full_set = full_set[,selected_cols]

#remove temporary variables
rm(features,split_features,selected_cols)

#create independent dataset of values averaged by subject and activity
factors = interaction(full_set$subject,full_set$activity)
split_set = split(full_set,factors)
split_avg = as.data.frame(aperm(sapply(split_set,function(x) colMeans(x[,3:68])),c(2,1)))
factor_levels = levels(factors)
factor_levels = lapply(factor_levels,strsplit,'.',T)
subject = sapply(factor_levels,function(x) x[[1]][1])
activity = sapply(factor_levels,function(x) x[[1]][2])
split_avg = cbind(subject,activity,split_avg)
var_names = colnames(split_avg)[3:68]
var_names = sapply(var_names,paste," (averaged)")
colnames(split_avg) = c("subject","activity",var_names)
rownames(split_avg) = 1:180