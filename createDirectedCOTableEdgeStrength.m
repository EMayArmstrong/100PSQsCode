function [COTable, KeyWordList] = createDirectedCOTableEdgeStrength(doc, nKeywords,NumberPairs)
%              
% createCOTable     
% created by:  Cerian Webb based on Matlab code createCOTable
% Create a directed co-occurence table for given keywords.  This function finds top N
% most frequently occurring words (co-occurrence words) and their frequency
% within given span for given keywords. [Note: Text Analytics Toolbox is required.]
%  
% Syntax: [COTable, KeyWordList] = createDirectedCOTableEdgeStrength(doc, nKeyWords, NumberPairs)
%
% Input:
%   doc       [tokenizedDocument] 
%   nKeyWords [double|string array] 
%     (double) Number of keywords for which co-occurence words are sought.
%              Tne top nKeyWords words in the doc are set as keywords.
% 
%     (string array) An array of keywords
%
%   NumberPairs [double] Number of questions in which the word occurs
% Output: 
%   COTable Co-occurence table.
% 
%   COTable.Word        Keyword
%   COTable.Count       Number of occurence of the Keyword in the document
%   COTable.COWordSameSentence      Co-occurence word occuring in same
%   sentence as keyword
%   COTable.COWordNumTimesCount     Number of sentences in which keyword
%   and co-occurrence word occur
%   COTable.COWordUniqueOccurences  Number of occurrence of the
%   co-occurence word in the document as a whole
%

%% Selection of the keywords
% Determine keywords
% create a list of all words and find the most frequently nKeywords across
% when all documents combined
bows = bagOfWords(doc);
wordsTable = topkwords(bows, nKeywords);
KeyWordList = wordsTable.Word;

%% Prepare COTable to store output in

collVarNames = ["Word","Counts", "COWordSameSentence","COWordNumTimesCount","COWordUniqueOccurences"];
collVarTypes = ["string","double", "string","double","double"];

COTable = table('size',[nKeywords numel(collVarNames)],...
    'VariableTypes',collVarTypes,...
    'VariableNames',collVarNames);

%% Prepare a list of words 
% find all documents that in include the keyword and the location of each keyword in each document
WordRow = 1;
for kk = 1:nKeywords
    AllWordsBeforeKeyWord = [];
    AllWordsAfterKeyWord = [];
    AllWordsWithKeyWord = [];
    for dd = 1:numel(doc)
        WordsBeforeKeyWord = [];
        WordsAfterKeyWord = [];
        OrderedWordList = bagOfWords(doc(dd));
        WordListVocab = OrderedWordList.Vocabulary;
        idxKeyWord = strcmp(WordListVocab,wordsTable.Word(kk));
        if numel(WordListVocab) > 1 % has to be at least one other word in document
        if sum(idxKeyWord) >=1 % key word occurs in the document
            % find first occurence of KeyWord
             LocKeyWord = find(idxKeyWord,1,'first');
             if LocKeyWord == numel(idxKeyWord) % then it is at end of word list
                 WordsBeforeKeyWord = WordListVocab(1:LocKeyWord-1);
             elseif LocKeyWord == 1 % then it is at the start of the word list
                 WordsAfterKeyWord = WordListVocab(2:end);
             else
                 WordsBeforeKeyWord = WordListVocab(1:LocKeyWord-1);
                 WordsAfterKeyWord = WordListVocab(LocKeyWord+1:end);
             end
        end
        end
        AllWordsBeforeKeyWord = [WordsBeforeKeyWord AllWordsBeforeKeyWord];
        AllWordsAfterKeyWord = [WordsAfterKeyWord AllWordsAfterKeyWord];
        if numel([WordsBeforeKeyWord WordsAfterKeyWord]) > 0
            unique([WordsAfterKeyWord WordsBeforeKeyWord]);
        AllWordsWithKeyWord = [unique([WordsAfterKeyWord WordsBeforeKeyWord]) AllWordsWithKeyWord ];
        end
    end
    
    bag_of_AllWords = bagOfWords(AllWordsWithKeyWord);
        % Choose nCO-most-frequently-occured co-occurence words, put the words and
    % their occurrence into the co-occurence table
    CoOccurGTCutOff = find(bag_of_AllWords.Counts >=NumberPairs); % find all words which occur in at least "NumberPairs" sentences

    coWords = bag_of_AllWords.Vocabulary(CoOccurGTCutOff);
    coWordsCount = bag_of_AllWords.Counts(CoOccurGTCutOff);
    NumcoWords = numel(coWords);
    rowRange = WordRow:(WordRow+NumcoWords-1);
    warning('off','MATLAB:table:RowsAddedExistingVars')
    COTable{rowRange, 1} = wordsTable.Word(kk);
    COTable{rowRange, 2} = wordsTable.Count(kk);
    COTable{rowRange, 3} = coWords';
    COTable{rowRange, 4} = coWordsCount';
  
    WordRow = WordRow + NumcoWords;
end
    
[~, tmp_i] = ismember(COTable.COWordSameSentence, bows.Vocabulary); % count the number of occurences summed over all documents of each word occuring after key word
COCountAll = sum(bows.Counts(:,tmp_i));
COTable{:,5} = COCountAll(:);    


end


