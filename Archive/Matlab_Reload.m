% Use REGEXP function for faster execution time!!!
clear all
close all
feature('DefaultCharacterSet','UTF8');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file_ori = '..\en0 original - NOT FOR GATHERING.xml';
% file_ori = 'test.xml';
filetrans = '..\en0_0607_OLDFORMAT.xml';
newfile = 'Reload.xml';

fid_trans = fopen(filetrans, 'r', 'n', 'UTF-8');
fid_ori = fopen(file_ori, 'r', 'n', 'UTF-8');
MAX_LINE = 77153;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text_trans = fscanf(fid_trans,'%c');
% newline = strfind(text_trans,char(10));
text_begin = strfind(text_trans,'<text id=');
text_end = strfind(text_trans,'</text>');
text_trans = text_trans(text_begin(1):text_end(end)+6);
fclose(fid_trans);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text_reload = char;
line_ori = fgets(fid_ori);
i = 1;
searchtext = strfind(line_ori,'text id');
while (length(searchtext) <= 0)
    text_reload = [text_reload line_ori];
    line_ori = fgets(fid_ori);
    i = i+1;
    searchtext = strfind(line_ori,'text id');   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rep_number = 0;

while (ischar(line_ori))
    line_end = strfind(line_ori,'</text>');
    if (i < MAX_LINE)
        while (length(line_end) == 0)
            line_ori = [line_ori fgets(fid_ori)];
            i = i+1;
            line_end = strfind(line_ori,'</text>');
        end
    end
    IDprefix = strfind(line_ori,'text id="')-1;
    IDsuffix = strfind(line_ori,'">')+1;
    
    stringID = line_ori(IDprefix:IDsuffix);
   
    indexIDfind = strfind(text_trans,stringID);
    if (length(indexIDfind)~=0)
        j = indexIDfind;
        search_end = text_trans(j:j+6);
        while (~strcmp(search_end,'</text>'))
            j = j + 1;
            search_end = text_trans(j:j+6);
        end
        string_ori = line_ori(IDprefix:line_end-1);
        string_trans = text_trans(indexIDfind:j-1);
        if (~strcmp(string_ori,string_trans))
            rep_number = rep_number + 1;
            line_ori = strrep(line_ori,string_ori,string_trans);
        end
    end
    text_reload = [text_reload line_ori];   
    line_ori = fgets(fid_ori);
    i = i+1;
end

fclose(fid_ori);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(newfile, 'w', 'n', 'UTF-8');
fprintf(fid,'%c',text_reload);
fclose(fid);

