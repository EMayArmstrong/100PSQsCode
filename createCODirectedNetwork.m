function [GBefore, GAfter, GBefore_and_After] = createCODirectedNetwork(COTable)
%
% createCONetwork                           
%
% Create co-occurence network from co-occurence table
%
% Syntax: G = createCODirectedNetwork(collTable [, weightMode])
%
% Input; 
%   COTable [table] Co-occurence table (output of createCODirectedTable.m)
%     .Word           Keyword
%　   .Counts         Occurence of the keyword
%     .COWordBefore         Co-occurence word occurs before keyword
%     .COBeforeCount        Number of times co-occurence word occurs before keyword
%     .COCountAllBefore     Number of occurrence of the co-occurrence word in the document
%     .COWordAfter        Co-occurence word occurs after keyword
%     .COAfterCount        Number of times co-occurence word occurs after keyword
%     .COCountAllAfter     Number of occurrence of the co-occurrence word in the document

%  weightMode [string] The weight to be added to each edge.  Default is 'none'
%
%    'none'  -> Equal weight
%    'count' -> Frequency of the co-occurence


%% Create Graph object

% Extract the co-occurrence words and their frequencies wihtout duplication. 
allWordsBefore  = [COTable.Word;   COTable.COWordBefore];
allWordsAfter  = [COTable.Word;   COTable.COWordAfter];
allWordsBefore_and_After = [COTable.Word;   COTable.COWordBefore; COTable.COWordAfter];

allCountsBefore = [COTable.Counts; COTable.COCountAllBefore];
allCountsAfter = [COTable.Counts; COTable.COCountAllAfter];
allCountsBefore_and_After = [COTable.Counts; COTable.COCountAllBefore; COTable.COCountAllAfter];

[uniqueWordsBefore, iUniqueWordsBefore] = unique(allWordsBefore);
[uniqueWordsAfter, iUniqueWordsAfter] = unique(allWordsAfter);
[uniqueWordsBefore_and_After, iUniqueWordsBefore_and_After] = unique(allWordsBefore_and_After);

countUniqueWordsBefore = allCountsBefore(iUniqueWordsBefore);
countUniqueWordsAfter = allCountsAfter(iUniqueWordsAfter);
countUniqueWordsBefore_and_After = allCountsBefore_and_After(iUniqueWordsBefore_and_After);

% Create the node table
nodeTableBefore = table(uniqueWordsBefore,countUniqueWordsBefore,'VariableNames',{'Name','Counts'});
nodeTableAfter = table(uniqueWordsAfter,countUniqueWordsAfter,'VariableNames',{'Name','Counts'});
nodeTableBefore_and_After = table(uniqueWordsBefore_and_After,countUniqueWordsBefore_and_After,'VariableNames',{'Name','Counts'});

% Create the directed graph object with given edge weight.
GBefore = digraph(COTable.COWordBefore,COTable.Word,COTable.COBeforeCount,nodeTableBefore);
GAfter = digraph(COTable.Word,COTable.COWordAfter,COTable.COAfterCount,nodeTableAfter);

GBefore_and_After = digraph([COTable.Word; COTable.COWordBefore],[COTable.COWordAfter; COTable.Word],[COTable.COAfterCount; COTable.COBeforeCount],nodeTableBefore_and_After);
end