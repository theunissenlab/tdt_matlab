function varargout = subsref(e,index)
%SUBSREF Define field name indexing for spike objects

goodfields = {'block','name','value','starttime','endtime'};

switch index(1).type
case '()'
    switch length(index)
        case 1
            b = e.block;
            n = e.name;
            values = e.value;
            starttimes = e.starttime;
            endtimes = e.endtime;
            varargout{1} = epoc(b,n,values(index(1).subs{:}),...
                starttimes(index(1).subs{:}),endtimes(index(1).subs{:}));
        case 2
            switch index(2).type
                case '()'
                    error('Array indexing not supported for spike references')
                case '.'
                    switch index(2).subs
                        case {'block','name'}
                            varargout = {e.(index(2).subs)};
                        case {'value','starttime','endtime'}
                            val = e.(index(2).subs);
                            varargout = {val(index(1).subs{:})};
                        case 'length'
                            t1 = e.starttime(index(1).subs{:});
                            t2 = e.endtime(index(1).subs{:});
                            varargout = {t1-t2};
                        otherwise
                            error('Invalid field name')
                    end
                case '{}'
                    error('Cell array indexing not supported for spike references')
            end
        otherwise
            error('Reference too deep')
    end
case '.'
    switch index.subs
        case goodfields
            varargout = {e.(index.subs)};
        case 'number'
            varargout = {number(e)};
        case 'code'
            varargout = {code(e)};
        otherwise
            error('Invalid field name')
    end
case '{}'
    error('Cell array indexing not supported by spike objects')
end