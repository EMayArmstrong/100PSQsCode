% analysis of 100 plant science questions long list
clear all
%% set up file paths
% update this paths so Matlab can find the required files on your computer
LocalPath = '/Users/vg21639/Documents/MATLAB/';

WhereIsMyRawData = [LocalPath,'PSQs'];
WhereIsMyMatlabCode = [LocalPath,'PSQs/matlabcode'];
addpath(WhereIsMyRawData)
addpath(WhereIsMyMatlabCode)

% change working directory to location of code
cd(WhereIsMyMatlabCode)
% path to ficlele exchange functions createCONetwork.m, createCOTable.m in
% directory TextAnalysisGraph
addpath([LocalPath,'/MatlabFileExchange/TextAnalysisGraph'])

%% Import raw data 
% import category, question and frequency as a table
% each question is contained in a single string
DataOptionsDS = {'Final List 2022','Africa','Americas','Asia','Europe','Final List 2011','All Questions 2022'};
[DataSetID,tf] = listdlg('PromptString','Which dataset do you want to plot?', 'SelectionMode','single','ListString',DataOptionsDS);
switch DataSetID
    case 1
        PSQFinalList2022 = AllSubQs("finalNoHeadings.xlsx", "Sheet2", [1, 100]);
        PSQAll = PSQFinalList2022.Ques;
        disp(['Analysing ','DataOptionsDS{DataSetID}'])
    case 2
        PSQRegionalListAfrica = AllSubQs("RegionalTop100.xlsx", "Africa", [1, 100]);
        PSQAll = PSQRegionalListAfrica.Ques;
        disp(['Analysing Final 100 questions ',DataOptionsDS{DataSetID},' Panel 2022 list'])
    case 3
        PSQRegionalListAmerica = AllSubQs("RegionalTop100.xlsx", "Americas", [1, 100]);
        PSQAll = PSQRegionalListAmerica.Ques;
          disp(['Analysing Final 100 questions ',DataOptionsDS{DataSetID},' Panel 2022 list'])
    case 4
        PSQRegionalListAsia = AllSubQs("RegionalTop100.xlsx", "Asia", [1, 100]);
        PSQAll = PSQRegionalListAsia.Ques;
         disp(['Analysing Final 100 questions ',DataOptionsDS{DataSetID},' Panel 2022 list'])
    case 5
        PSQRegionalListEurope = AllSubQs("RegionalTop100.xlsx", "Europe", [1, 104]);
        PSQAll = PSQRegionalListEurope.Ques;
          disp(['Analysing Final 100 questions ',DataOptionsDS{DataSetID},' Panel 2022 list'])
    case 6
        PSQFinalList2011 = AllSubQs("PSQs2011","Sheet1",[1,97]);
        PSQAll = PSQFinalList2011.Ques;
        disp(['Analysing ',DataOptionsDS{DataSetID}])
    case 7
        PSQAllQs2022 = AllSubQs("AllQsLongList","Sheet1",[1,569]);
        PSQAll = PSQAllQs2022.Ques;
        disp(['Analysing ',DataOptionsDS{DataSetID}])
end
%% Pre-process data
% split into words removing 2 letter words and any
% words longer than 15 letters
% function "preprocessTextData" also processes data to extract separate words and removes "stop" words 
% to see list of stop words type following into command window: words = stopWords; reshape(words,[25 9])

% set minimum and maximum word length
MinWordLength = 3; % minimum word length to keep
MaxWordLength = 15; % maximum word length to keep

documentsRemoveLTE2GTE15 = preprocessTextData(PSQAll,MinWordLength,MaxWordLength);

DataOptionsCC = {'Yes','No'};
[IncludeClimateChange,tf] = listdlg('PromptString',{'Do you want to', 'include the words','climate and change?',''}, 'SelectionMode','single','ListString',DataOptionsCC);

% create list of words that don't want to be included on word cloud
if IncludeClimateChange == 1
words = ["aka" "address" "result" "own" "plant" "result" "impact" "perception" "thus" "way" ...
    "big" "issue" "face" "key" "scientist" "question" "work" "next" "good" "science" ...
    "make" "sure" "view" "nuanced" "around" "research" "raise" "ensure" "vary" "goal" "role" ...
    "become" "easy" "small" "new" "things" "well" "why" "off" "due" "per" "part" ...
    "amount" "day" "leave" "try" "two" "accept" "five" "top" "upon" "ever" "easily" "know" "yes" "say" ...
    "anyway" "3000000" "300000" "50100" "down" "datum" "confidentially" "own" "next" "year" "give" "solve" "affect" "smallerscale" "nonmonoculture"];
else
    words = ["aka" "climate" "change" "address" "result" "own" "plant" "result" "impact" "perception" "thus" "way" ...
    "big" "issue" "face" "key" "scientist" "question" "work" "next" "good" "science" ...
    "make" "sure" "view" "nuanced" "around" "research" "raise" "ensure" "vary" "goal" "role" ...
    "become" "easy" "small" "new" "things" "well" "why" "off" "due" "per" "part" ...
    "amount" "day" "leave" "try" "two" "accept" "five" "top" "upon" "ever" "easily" "know" "yes" "say" ...
    "anyway" "3000000" "300000" "50100" "down" "datum" "confidentially" "own" "next" "year" "give" "solve" "affect" "smallerscale" "nonmonoculture"];

end

% use inbuilt function removeWords to remove all the words we don't want from each
% question
documents = removeWords(documentsRemoveLTE2GTE15,words);

% for some reason it has decided to misspell species so correct this
documents = replaceWords(documents,'specie','species');
documents = replaceWords(documents,'fungus','fungi');
documents = replaceWords(documents,'pplant','plant');
%%
% create a special type of data store called bagOfWords which contains
% bag.Vocabulary - list of all words to be included in analysis
% bag.NumWords - total number of distinct words extracted
% bag.NumDocuments - number of questions
% bag.Counts - Frequency counts of words corresponding to uniqueWords, specified as a matrix of nonnegative integers. The value counts(i,j) corresponds to the number of times the word uniqueWords(j) appears in the ith document.
bag = bagOfWords(documents);
UniqueWords = sort(bag.Vocabulary'); % alphabetical list of words in bag

% find most frequent individual words
NumTopWords = 50; % set number of words you would like included in the table
tblmostFrequentWords = topkwords(bag,NumTopWords) 
TopWordsWithFreqGTE5 = find(tblmostFrequentWords.Count >= 5);
NumWorFreq5 = numel(TopWordsWithFreqGTE5);
disp(['Number of top words with at least 5 occurences = ',num2str(numel(TopWordsWithFreqGTE5)) ])
WordListGTE5 = tblmostFrequentWords(TopWordsWithFreqGTE5,:)

TopWordsWithFreqGTE6 = find(tblmostFrequentWords.Count >= 6);
NumWordFreq6 = numel(TopWordsWithFreqGTE6);
disp(['Number of top words with at least 6 occurences = ',num2str(numel(TopWordsWithFreqGTE6)) ])
WordListGTE6 = tblmostFrequentWords(TopWordsWithFreqGTE6,:)

TopWordsWithFreqGTE7 = find(tblmostFrequentWords.Count >= 7);
NumWordFreq7 = numel(TopWordsWithFreqGTE7);
disp(['Number of top words with at least 7 occurences = ',num2str(numel(TopWordsWithFreqGTE7)) ])
WordListGTE7 = tblmostFrequentWords(TopWordsWithFreqGTE7,:)

TopWordsWithFreqGTE25 = find(tblmostFrequentWords.Count >= 25);
NumWordFreq25 = numel(TopWordsWithFreqGTE25);
disp(['Number of top words with at least 25 occurences = ',num2str(numel(TopWordsWithFreqGTE25)) ])
WordListGTE25 = tblmostFrequentWords(TopWordsWithFreqGTE25,:);
%%
% find words that occur next to one another either in pairs or triples
% (remembering we have removed stop words and our own set of words)
bagWordPairs = bagOfNgrams(documents,'NgramLengths',[2 3]); % sequence of two or three words
% table of top ten word pairs
TopTenPairs = topkngrams(bagWordPairs,10,'NGramLengths',2)
% table of top ten word triples
TopTenTriples = topkngrams(bagWordPairs,10,'NGramLengths',3)


counts = bag.Counts;

%% word cloud
DataOptionsWC = {'Yes','No'};
[PlotWordCloud,tf] = listdlg('PromptString',{'Do you want to', 'plot word cloud?',''}, 'SelectionMode','single','ListString',DataOptionsWC);

if PlotWordCloud == 1
    numTopics = 4;
    mdl = fitlda(bag,numTopics,'Verbose',0);



    figure
    tiledlayout(2,2,'TileSpacing','Compact')


    for topicIdx = 1:4
        nexttile(topicIdx)
        wordcloud(mdl,topicIdx);
        title('Word cloud using lda model')
    end

    topicIdx = 1;
    figure
    wordcloud(mdl,topicIdx,'HighlightColor',[0.4660 0.6740 0.1880],'Color','#000000','shape','oval', 'MaxDisplayWords', 30);
    title('Word cloud using lda model top 30')

    figure
    % word cloud with no model just sized according to frequency of
    % occurence
    NumWordsIncluded = 30;
    tblmostFrequentWordToPlot = topkwords(bag,NumWordsIncluded);
    mywc = wordcloud(tblmostFrequentWordToPlot.Word,tblmostFrequentWordToPlot.Count,'HighlightColor',[0.4660 0.6740 0.1880],'Color','#000000','shape','oval')
end

%% network graph: looking for pairs of words in questions
% nkeywords: the number of keywords, for which the co-occuring words are sought.  
% Here, we selected top 10 most occurring words in the data as keywords.  
% (The function also allows users to define the keywords as a cell array of words.)
% span: length of window in which co-occuring words are sought within each
% question
% nCooc: number of coocuring word for each keyword to find
% mode: where is the key word in the span: forward, backward or center (I
% think center best
if strcmp(DataOptionsDS{DataSetID},'All Questions 2022') % as so many questions keywords occur more frequently
nKeywords = NumWordFreq25;
else
nKeywords = NumWordFreq6;
end
nCooc = 2;
NumWordPairs = {'2','3','4', '5', '6'};
[IdxNumWordPairs,tf] = listdlg('PromptString',{'How many sentences', 'should include each','pair of words',''}, 'SelectionMode','single','ListString',NumWordPairs,'InitialValue',1);
nCooc = IdxNumWordPairs+1;
[COTable, KeyWordsSelected] = createDirectedCOTableEdgeStrength(documents,nKeywords,nCooc);
[CONetworkVariableLinks] = createCODirectedNetworkVE(COTable);

%%
% find location keywords in node list for highlighting in graph
clear idxKeyNode
j = 0;
     for kk = 1:nKeywords
    
    AllNodes = strcmp(KeyWordsSelected(kk),CONetworkVariableLinks.Nodes.Name);
     if sum(AllNodes) > 0
        j = j+1;
     idxKeyNode(j) = find(AllNodes);
    end
    
end

%% plot output with NO edge weight values and but edge width according to number of times pair of words occur anywhere in
% a submitted question


figure
gAllNoEdgeVal = plot(CONetworkVariableLinks,'MarkerSize',40,'EdgeColor',[0.7 0.7 0.7],...
    'LineWidth',CONetworkVariableLinks.Edges.Weight,'NodeColor',[0.4039    0.7255    0.6078], ...
    'Layout','force','UseGravity',true,'WeightEffect','direct','Iterations',100)
% Since the position of the node label cannot be in the center of the circle,
% we need to erase the existing label and overlay the text so that each label is
% on the center of each circle.
text(gAllNoEdgeVal.XData, gAllNoEdgeVal.YData, gAllNoEdgeVal.NodeLabel,'HorizontalAlignment','center',...
  'VerticalAlignment','middle','FontSize',16,...
  'Color',[0     0     0]);
gAllNoEdgeVal.NodeLabel = [];
title(['Words both occur in a sentence. Dataset: ',DataOptionsDS{DataSetID}])
highlight(gAllNoEdgeVal,idxKeyNode,'NodeColor',[0.8784    0.5529    0.4275])
%% Little bit of code to see which sentences a particular key word appears in if missing from graph
StartingWords = topkwords(bag,nKeywords);
PickStartingWordIdx = 5;
disp(['Starting word is: ',StartingWords.Word(PickStartingWordIdx)])
for i = 1:numel(documents)
    Sentencei = bagOfWords(documents(i));
    j = strcmp(StartingWords.Word(PickStartingWordIdx),Sentencei.Vocabulary);
    if sum(j) >0
        Sentencei.Vocabulary
    end
end

%% plot output with edge weight values and edge width according to number of times pair of words occur anywhere in
% a submitted question
% you can edit this value
IWantThisFigure = 0; % set to 1 if you want to display figure with edge weight values, 0 otherwise

% don't edit this
if IWantThisFigure == 1
figure
gAll = plot(CONetworkVariableLinks,'MarkerSize',30,'EdgeColor',[0.7 0.7 0.7],...
    'EdgeLabel',CONetworkVariableLinks.Edges.Weight,'LineWidth',CONetworkVariableLinks.Edges.Weight,...
    'Layout','force','UseGravity',true,'Iterations',100)
text(gAll.XData, gAll.YData, gAll.NodeLabel,'HorizontalAlignment','center',...
  'VerticalAlignment','middle','FontSize',10,...
  'Color',[0     0     0]);
gAll.NodeLabel = [];
title('Words both occur in a sentence')
highlight(gAll,idxKeyNode,'NodeColor',[0.5 0.5 0.5])


end





%% Network analysis: which are the most important words?
% Centrality measures: can only be performed on connected graphs so will
% focus on largest weakly connected component of main graph
% Two nodes belong to the same weakly connected component if there is a path connecting them (ignoring edge direction). 
% There are no edges between two weakly connected components.
% The concepts of strong and weak components apply only to directed graphs, as they are equivalent for undirected graphs.

% Step 1: Separate data into weakly connected components

SubgraphID = conncomp(CONetworkVariableLinks,'Type','Weak'); % ignores direction of edges in creating set of subgraphs
SubgraphList = tabulate(SubgraphID); % first column: subgraph id; second column number of nodes with that id; third column % of all nodes in subgraph
SizeLargestSubgraph = max(SubgraphList(:,2));
disp(['The total number of nodes in the graph is ',num2str(size(CONetworkVariableLinks.Nodes,1))])
disp(['The largest subgraph has ',num2str(SizeLargestSubgraph),' nodes'])
BiggestSubgraphIdx = find(SubgraphList(:,2) == max(SubgraphList(:,2))); 

% Extract largest Weakly connected component (subgraph) of the original network Subgraph 
figure
LargestSubgraph = subgraph(CONetworkVariableLinks, SubgraphID == BiggestSubgraphIdx);

% find location keywords in node list for largest subgraph
j = 0;
for kk = 1:nKeywords
   
    SubgraphNodes = strcmp(KeyWordsSelected(kk),LargestSubgraph.Nodes.Name);
    if sum(SubgraphNodes) > 0
        j = j+1;
    idxKeyNodeSubgraph(j) = find(SubgraphNodes);
    end
end

gSubgraph = plot(LargestSubgraph,'MarkerSize',30,'EdgeColor',[0.7 0.7 0.7],...
    'LineWidth',LargestSubgraph.Edges.Weight,'NodeColor',[0.9290 0.6940 0.1250], ...
    'Layout','force','UseGravity',true,'WeightEffect','direct','Iterations',100);
% Since the position of the node label cannot be in the center of the circle,
% we need to erase the existing label and overlay the text so that each label is
% on the center of each circle.
text(gSubgraph.XData, gSubgraph.YData, gSubgraph.NodeLabel,'HorizontalAlignment','center',...
  'VerticalAlignment','middle','FontSize',10,...
  'Color',[0     0     0]);
gSubgraph.NodeLabel = [];
title('Words both occur in a sentence')
highlight(gSubgraph,idxKeyNodeSubgraph,'NodeColor',[0.5 0.5 0.5])

title('Largest weakly connected component')

% LS = Largest subgraph
% Indegree and outdegree
ListNodes_LS = LargestSubgraph.Nodes;
Degree_LS = degree(LargestSubgraph);

% create a table to store output
colVarNames = ["Word","Degree"];
colVarTypes = ["string","double"];

DegreeTable = table('size',[numel(Degree_LS) numel(colVarNames)],...
    'VariableTypes',colVarTypes,...
    'VariableNames',colVarNames);

DegreeTable{:,1} = ListNodes_LS{:,1};
DegreeTable{:,2} = Degree_LS;
SortDegreeTable = sortrows(DegreeTable,"Degree","descend");
head(SortDegreeTable)