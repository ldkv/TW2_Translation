clear all
close all
feature('DefaultCharacterSet','UTF8');

%%%% DEFINITION OF FILENAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileref = 'FCR2_v1.1.xlsx';
filerep = '..\..\..\en0_2912 - FOR GATHER.xml';      % MODIFY FILENAME!!
newfile = ['..\..\..\FCR2_en0_' datestr(date,'ddmm') 'NEW.xml'];

%%%% READING FILE EXCEL WITH NEW MODIFICATION IN FCR2 MOD %%%%%%%%%%%%%%%%%
[IDFCR,textFCR] = xlsread(fileref);
fid = fopen(filerep, 'r', 'n', 'UTF-8');
textrep = fscanf(fid,'%c');
fclose(fid);
index_key = strfind(textrep,'<texts>');
textrep_key = textrep(1:index_key-1);
textrep = textrep(index_key:end);

%%%%% SCAN ORIGINAL FILE FOR REPLACEMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stringID = char;
number_of_ID = length(IDFCR);
% i=1;
for i=1:number_of_ID
    stringID = ['<text id="',int2str(IDFCR(i)),'">'];
    string2replace = [stringID char(textFCR(i))];
    lenID = length(stringID);
    indexIDfind = strfind(textrep,stringID);
    indexEndPhrase = indexIDfind;
    search_end = textrep(indexEndPhrase:indexEndPhrase+6);
    while (~strcmp(search_end,'</text>'))
        indexEndPhrase = indexEndPhrase + 1;
        search_end = textrep(indexEndPhrase:indexEndPhrase+6);
    end
    oldstringfound = textrep(indexIDfind:indexEndPhrase-1);
    if (~strcmp(oldstringfound,string2replace))        
        textrep = strrep(textrep,oldstringfound,string2replace);
    end
end

%%%%% GENERATE NEW FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textrep = [textrep_key textrep];
fid = fopen(newfile, 'w', 'n', 'UTF-8');
fprintf(fid,'%c',textrep);
fclose(fid);