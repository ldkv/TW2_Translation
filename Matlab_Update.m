% Use REGEXP function for faster execution time!!!
% Use cell array for faster execution time!
% Expression of NEWLINE (\n) is char(10) => strfind(text,char(10))
clear all
close all
feature('DefaultCharacterSet','UTF8');

%%%% DEFINITION OF FILENAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileref_E = '..\..\4. E - Edit\ETG_J7G_Francesca Findabair.xml';  % MODIFY FILENAME
filerep = '..\en0_2912 - FOR GATHER.xml';       % MODIFY FILENAME
newfilegather = ['..\en0_' datestr(date,'ddmm') ' - FOR GATHER.xml'];
newfilePack = '..\..\5. Pack Viet hoa cho vao game\Gibbed Red Tools\1. Encode - xml to w2strings\en0.xml';
newfileBackup = ['..\..\..\..\Copy\The Witcher 2\1. en0.xml\' newfilegather(4:end)];

%%%% READING FILE WITH NEW TRANSLATION & DO TRUNCATION %%%%%%%%%%%%%%%%%%%%
fid = fopen(fileref_E, 'r', 'n', 'UTF-8');
textref = fscanf(fid,'%c');
fclose(fid);
IDtext_begin = strfind(textref,'<text id=');
IDtext_end = strfind(textref,'</text>');
textref = textref(IDtext_begin(1):IDtext_end(end)+6);

%%%%% SCAN ORIGINAL FILE FOR REPLACEMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(filerep, 'r', 'n', 'UTF-8');
textrep = fscanf(fid,'%c');
fclose(fid);
index_key = strfind(textrep,'<texts>');
textrep_key = textrep(1:index_key-1);
textrep = textrep(index_key:end);

%%%%% SEARCH FOR TEXT_ID POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IDprefix = strfind(textref,'<text id="');
IDsuffix = strfind(textref,'">')+1;
index_end = strfind(textref,'</text>');
number_of_ID = length(IDprefix);

%%%%% SEARCH FOR TEXT_ID & DO REPLACEMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
for i=1:number_of_ID
    string2replace = textref(IDprefix(i):index_end(i)-1);
    stringID = textref(IDprefix(i):IDsuffix(i));
    indexIDfind = strfind(textrep,stringID);
    j = indexIDfind;
    search_end = textrep(j:j+6);
    while (~strcmp(search_end,'</text>'))
        j = j + 1;
        search_end = textrep(j:j+6);
    end
    oldstringfound = textrep(indexIDfind:j-1);
    textrep = strrep(textrep,oldstringfound,string2replace);
%     pause; 
end

%%%%% GENERATE NEW FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rename_filerep = ['..\OLD - ' filerep(4:11) '.xml'];
movefile(filerep,rename_filerep);	% Rename old en0 file
textrep = [textrep_key textrep];
fid = fopen(newfilegather, 'w', 'n', 'UTF-8');
fprintf(fid,'%c',textrep);
fclose(fid);
fid = fopen(newfilePack, 'w', 'n', 'UTF-8');
fprintf(fid,'%c',textrep);
fclose(fid);
fid = fopen(newfileBackup, 'w', 'n', 'UTF-8');
fprintf(fid,'%c',textrep);
fclose(fid);

%%%% MOVE FINISHED FILES TO ARCHIVE %%%%%%
%%%% DEFINITION OF NEW NAME AND NEW LOCATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileref_T = ['..\..\3. T - Translate\' fileref_E(20:end)];
fileref_G = ['..\..\2. G - Gather\' fileref_E(21:end)];
movefile_G = '..\..\OTHER\Archive\1. G';
movefile_T = '..\..\OTHER\Archive\2. T';
movefile_E = ['..\..\OTHER\Archive\3. CE\C' fileref_E(19:end)];

%%%%% RENAME AND MOVE OLD FILES TO ARCHIVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
movefile(fileref_G,movefile_G);
movefile(fileref_T,movefile_T);
movefile(fileref_E,movefile_E);