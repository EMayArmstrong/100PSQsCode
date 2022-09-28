function [COTable KeyWordList] = createDirectedCOTable(doc, nKeywords, nCO)
%              
% createCOTable     
% created by:  Cerian Webb based on Matlab code createCOTable
% Create a directed co-occurence table for given keywords.  This function finds top N
% most frequently occurring words (co-occurrence words) and their frequency
% within given span for given keywords. [Note: Text Analytics Toolbox is required.]
%  
% Syntax: COTable = createDirectedCOTable(doc, span, nKeyWords, nCO)
%
% Input:
%   doc       [tokenizedDocument] 
%   nKeyWords [double|string array] 
%     (double) Number of keywords for which co-occurence words are sought.
%              Tne top nKeyWords words in the doc are set as keywords.
% 
%     (string array) An array of keywords
%
%   nCO [double] Number of co-occurence words 
% Output: 
%   COTable [ nKeyWords*nCO x 10 table] Co-occurence table.
% 
%   COTable.Word        Keyword
%   COTable.Count       Number of occurence of the Keyword in the document
%   COTable.COWordBefore      Co-occurenece word occuring before keyword
%   COTable.COCountBefore     Number of occurrence of the co-occurence word
%   before the keyword
%   COTable.COWordAfter      Co-occurenece word occuring after keyword
%   COTable.COCountafter     Number of occurrence of the co-occurence word
%   after the keyword

%   COTable.COCountAll  Number of occurrence of the co-occurence word in the
%                        document
%

%% Check of the arguments and selection of the keywords



% Determine keywords
% create a list of all words and find the most frequently nKeywords across
% when all documents combined
bows = bagOfWords(doc);
wordsTable = topkwords(bows, nKeywords);
KeyWordList = wordsTable.Word;

%% Prepare COTable 

collVarNames = ["Word","Counts", "COWordBefore","COBeforeCount","COWordAfter","COAfterCount","COCountAllBefore","COCountAllAfter"];
collVarTypes = ["string","double", "string","double","string","double","double","double"];

COTable = table('size',[nKeywords*nCO numel(collVarNames)],...
    'VariableTypes',collVarTypes,...
    'VariableNames',collVarNames);

%% Prepare a list of words 
% find all documents that in include the keyword and the location of each keyword in each document
for kk = 1:nKeywords
    bag_of_AllBeforeWords = [];
    bag_of_AllAfterWords = [];
    AllWordsBeforeKeyWord = [];
    AllWordsAfterKeyWord = [];
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
    end
    
    bag_of_AllBeforeWords = bagOfWords(AllWordsBeforeKeyWord);
    bag_of_AllAfterWords = bagOfWords(AllWordsAfterKeyWord);
    % Choose nCO-most-frequently-occured co-occurence words, put the words and
    % their occurrence into the co-occurence table
    coWordsBefore = topkwords(bag_of_AllBeforeWords,nCO);
    coWordsAfter = topkwords(bag_of_AllAfterWords,nCO);
  
    rowRange = (kk-1)*nCO+(1:nCO);
    COTable{rowRange, 1} = wordsTable.Word(kk);
    COTable{rowRange, 2} = wordsTable.Count(kk);
    COTable{rowRange, 3} = coWordsBefore.Word;
    COTable{rowRange, 4} = coWordsBefore.Count;
    COTable{rowRange, 5} = coWordsAfter.Word;
    COTable{rowRange, 6} = coWordsAfter.Count;
end
    
[~, tmp_i] = ismember(COTable.COWordBefore, bows.Vocabulary); % count the number of occurences summed over all documents of each word occuring after key word
COCountAll = sum(bows.Counts(:,tmp_i));
COTable{:,7} = COCountAll(:);    

[~, tmp_i] = ismember(COTable.COWordAfter, bows.Vocabulary); % count the number of occurences summed over all documents of each word occuring before key word
COCountAll = sum(bows.Counts(:,tmp_i));
COTable{:,8} = COCountAll(:);    
end


