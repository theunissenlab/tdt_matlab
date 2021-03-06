function s = display(d)

%% SQL_STR(d) Print a date object for SQL injection
%
% MySQL 5.0 requires that DATE values be entered in the form
% 'YY-MM-DD HH:MM:SS' or 'YYYY-MM-DD HH:MM:SS'. Except for the year
% value, the number of digits is not at all flexible, making zero-padding
% necessary. INSERT and UPDATE commands entered with a single-digit year,
% month, or day will cause a value of 0 ('0000-00-00') to be stored in the
% database. The same is true for out-of-range values.
%
% For more details, see
% http://dev.mysql.com/doc/refman/5.0/en/datetime.html

if d == 0
    % Treat datetime values of 0 as null
    s = 'NULL';
else
    % Zero-pad and trim numbers if needed
    dv = datevec(d);
    ds = cell(size(dv));
    for jj = 1:length(dv)
        if dv(jj) < 10
            ds{jj} = ['0',num2str(floor(dv(jj)))];
        else
            ds{jj} = num2str(floor(dv(jj)));
        end
    end
    
    % Print string with single quote marks around it
    s = sprintf('''%s-%s-%s''',ds{1:3});
end