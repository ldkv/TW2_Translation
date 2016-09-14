% Use REGEXP function for faster execution time!!!
clear all
close all
feature('DefaultCharacterSet','UTF8');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file_ori = '..\en0 original - for reference.xml';
filetrans = '..\en0_2912 - FOR GATHER.xml';      % MODIFY FILENAME
xlsfile = 'RemainText.xlsx';
fid_trans = fopen(filetrans, 'r', 'n', 'UTF-8');
fid_ori = fopen(file_ori, 'r', 'n', 'UTF-8');

line_ori = fgets(fid_ori);
line_trans = fgets(fid_trans);
i = 1;
MAX_LINE = 77153;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
searchtext = strfind(line_ori,'text id');
while (length(searchtext)<=0)
    line_ori = fgets(fid_ori);
    line_trans = fgets(fid_trans);
    i = i+1;
    searchtext = strfind(line_ori,'text id');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text_remain = char;
while ischar(line_ori)
    line_end = strfind(line_ori,'</text>');
    if (i < MAX_LINE)
        while (length(line_end) == 0)
            line_ori = [line_ori fgets(fid_ori)];
            line_trans = fgets(fid_trans);
            i = i+1;
            line_end = strfind(line_ori,'</text>');
        end
    end
%     empty_present = strfind(line_ori,'></text>');
%     empty_present = length(empty_present); 
    PL_present = strfind(line_ori,'[PL]');
    PL_present = length(PL_present);
    if ((PL_present == 0))
        text_remain = [text_remain line_ori];
    end
    line_ori = fgets(fid_ori);
    line_trans = fgets(fid_trans);
    i = i+1;
end

fclose(fid_ori);
fclose(fid_trans);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IDprefix = strfind(text_remain,'text id="') + 9;
IDsuffix = strfind(text_remain,'">')-1;
line_end = strfind(text_remain,'</text>');

number_of_ID = length(IDprefix);

xls_cell = cell(number_of_ID,2);
xls_cell{1,1} = 'text ID';
xls_cell{1,2} = 'Text';
for i=1:number_of_ID
    text_string = text_remain(IDsuffix(i)+3:line_end(i)-1);
    stringID = text_remain(IDprefix(i):IDsuffix(i));
    ID = str2num(stringID);
    xls_cell{i+1,1} = ID;
    xls_cell{i+1,2} = text_string;
end

sheet = 1;
xlswrite(xlsfile,xls_cell,sheet);

