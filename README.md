# 100PSQsCode
Code walkthrough – Emily May Armstrong
To access the code, please go to https://github.com/EMayArmstrong/100PSQs.git
This MATLAB code is broken up into discreet sections to allow easier navigation. Run one section at a time. 
Important note: this code was written on a Mac, meaning ‘/’ are used. Ensure you change ‘/’ to ‘\’ to set file paths. ‘%%’ are instructional comments. 
USE FILE “UpdatedCodePSQsmVarEdgeALL.m” & load all associated files into your code folder
1.	Set up file paths – assign raw data to folder, assign code to separate folder
2.	Import raw data – prompt will ask you which data set you want to use
3.	Pre-process data – remove stop words. Prompt: do you want to include ‘climate change’?
4.	Create a Bag of Words datastore – find most frequent individual words. 
5.	Find co-occurring words – either two or three words 
6.	Create word cloud. You can alter the number of word clouds to create (topics), the number of words to include, and the tile-spacing 
7.	Create a network graph - Prompt: in how many individual sentences do you want these words to occur? The larger the number of sentences, the larger the value
8.	Find location keywords – act as ‘key nodes’ in network graph
9.	MULTIPLE OPTIONS: 
a.	create network graph with no edge weight values, instead edge width corresponds to number of times word pairs occur
b.	create a network graph with edge weight values and width according to number of times word pairs occur
10.	OPTIONAL: Identify the ‘most important’ words

Summary of question analysis – Cerian R Webb 
All text analysis was conducted in MATLAB2022a. Seven sets of questions were analysed: the original 2011 published one hundred questions; the final 2022 one hundred questions; the shortlists of questions for each regional panel: Africa (n=100), North and South America (n = 100), Asia (n=100) and Europe (n=104) and the original set of all submitted questions (n = 569).
The questions were pre-processed using inbuilt functions from the MATLAB Text Analytics toolbox to correct spelling errors, improve lemmatization, remove words like “a”, “the” and “to” (known as stop words), remove punctuation, remove short words (1-2 characters), remove long words (>15 characters). An additional list of 71 words which were not considered to be useful in the context of analysis, such as “try”, “questions” and “things”, were also removed (see Supplementary Information for a full list of excluded words). Each processed question is refereed to as a ‘document’.
Word clouds
Word clouds were generated for each of the seven sets of documents using a latent Dirichlet allocation (LDA) topic model to find clusters of related words within the set of questions. The number of words in each word cloud was fixed at 30 to improve readability. Word clouds were also generated with the words “climate” and “change” removed from the word list …because??
Co-occurrence network
Selection of keywords: Co-occurrence networks were built around the most frequently occurring words (which we define as ‘keywords’), found in the documents extracted from each set of questions. Keywords were defined as any word occurring six or more times across all the documents in the question set. Using a cut-off word frequency rather than fixing the number of key words leads to variation in the number of key words between question sets, however it avoids arbitrary decisions on which words to include if there is a tie in word count. The original set of submitted questions is nearly six times larger than the other sets and 166 words met the cut-off of six thus a bigger cut-off was set for keywords any word that occurs at least 25 times. 
Edges and linked nodes: For each keyword, the set of all documents containing that keyword was identified. An edge exists between a keyword and another word if they occur in the same document. The more edges that exist between a pair of words the stronger the association between those words in the set of questions. Plots are shown for a minimum edge strength of two for the lists of one hundred questions and for a minimum edge strength of four for the original list of questions submitted in 2022.

