function [GAll] = createCODirectedNetworkVE(COTable)
%
% createCONetwork                           
%
% Create co-occurence network from co-occurence table
%
% Syntax: G = createCODirectedNetwork(collTable [, weightMode])
%
% Input; 
%   COTable [table] Co-occurence table (output of createCODirectedTable.m)
%   COTable Co-occurence table.
% 
%   COTable.Word        Keyword
%   COTable.Counts       Number of occurence of the Keyword in the document
%   COTable.COWordSameSentence      Co-occurenece word occuring in same
%   sentence as keyword
%   COTable.COWordNumTimesCount     Number of sentences in which keyword
%   and co-occurrence word occur
%   COTable.COWordUniqueOccurences  Number of occurrence of the
%   co-occurence word in the document as a whole

%  weightMode [string] The weight to be added to each edge.  Default is 'none'
%
%    'none'  -> Equal weight
%    'count' -> Frequency of the co-occurence


%% Create Graph object

% Extract the co-occurrence words and their frequencies wihtout duplication. 
allWords = [COTable.Word; COTable.COWordSameSentence];

allCounts = [COTable.Counts; COTable.COWordUniqueOccurences];

[uniqueWords, iUniqueWords] = unique(allWords);

countUniqueWords = allCounts(iUniqueWords);

% Create the node table
nodeTable = table(uniqueWords,countUniqueWords,'VariableNames',{'Name','Counts'});
% remove duplicate edges
DuplicateRowList = [];
kk = 0;
for i = 1:numel(COTable.Word)
    StrA = COTable.Word(i);
    StrB = COTable.COWordSameSentence(i);
    ListAll = find(1:numel(COTable.Word)~=i);
    for j =  ListAll
         StrX = COTable.Word(j);
         StrY = COTable.COWordSameSentence(j);
         if strcmp(StrA,StrY) & strcmp(StrB,StrX)
             kk = kk+1;
             DuplicateRowList(kk,:) = [min(i,j) max(i,j)];
         end
    end
end
DuplicatePairs = unique(DuplicateRowList,'rows');    
KeepRows = setdiff(1:numel(COTable.Word),DuplicatePairs(:,1))';

% Create the directed graph object with given edge weight.
GAll = graph(COTable.COWordSameSentence(KeepRows),COTable.Word(KeepRows),COTable.COWordNumTimesCount(KeepRows),nodeTable);

end