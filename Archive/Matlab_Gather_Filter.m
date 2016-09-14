% Use REGEXP function for faster execution time!!!
% Use cell array for faster execution time!
% Expression of NEWLINE (\n) is char(10) => strfind(text,char(10))
clear all
close all
feature('DefaultCharacterSet','UTF8');

%%%% DEFINITION OF FILENAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileref = 'G_DR_44.xml';                    % MODIFY FILENAME
filerep = '..\en0_0707 - FOR GATHER.xml';   % MODIFY FILENAME
newfile = fileref(1:end-4);
newfile = [newfile 'filtered.xml'];

%%%%% SCAN ORIGINAL FILE FOR VERIFICATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(filerep, 'r', 'n', 'UTF-8');
textrep = fscanf(fid,'%c');
fclose(fid);
index_key = strfind(textrep,'<texts>');
textrep_key = textrep(1:index_key-1);
textrep = textrep(index_key:end);

%%%% READING FILE WITH FALSE GATHER & DO TRUNCATION %%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(fileref, 'r', 'n', 'UTF-8');
line_check = fgets(fid);

gather_remain = char;
while ischar(line_check)
    line_end = strfind(line_check,'</text>');
    while (length(line_end) == 0)
        line_check = [line_check fgets(fid)];
        line_end = strfind(line_ori,'</text>');
    end
    IDprefix = strfind(line_check,'text id="')-1;
    IDsuffix = strfind(line_check,'">')+1;
    stringID = line_check(IDprefix:IDsuffix);
    
    indexIDfind = strfind(textrep,stringID);
    j = indexIDfind;
    search_end = textrep(j:j+6);
    while (~strcmp(search_end,'</text>'))
        j = j + 1;
        search_end = textrep(j:j+6);
    end
    text2check = line_check(IDprefix:line_end-1);
    ori_text = textrep(indexIDfind:j-1);
    if (strcmp(text2check,ori_text))
        gather_remain = [gather_remain line_check];
    end
    line_check = fgets(fid);
end
fclose(fid);

%%%%% GENERATE NEW FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(newfile, 'w', 'n', 'UTF-8');
fprintf(fid,'%c',gather_remain);
fclose(fid);