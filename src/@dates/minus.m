function q = minus(o,p) % --*-- Unitary tests --*--

% Overloads the minus operator (-). If o and p are dates objects, the method . If 
% one of the inputs is an integer or a vector of integers, the method shifts the dates object by X (the interger input) periods backward.

% Overloads the minus (-) binary operator.
%
% INPUTS 
% - o [dates]
% - p [dates or integer]
%
% OUTPUTS 
% - q [dates]
%
% REMARKS 
% 1. If o and p are dates objects the method returns the number of periods between o and p (so that q+o=p).
% 2. If o is a dates object and p is an integer (scalar or vector), the method shifts the dates object by
%    p periods backward.
% 3. If o is not a dates object, an error is returned.

% Copyright (C) 2013-2014 Dynare Team
%
% This code is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare dates submodule is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

if isa(o,'dates') && isa(p,'dates')
    if ~isequal(o.freq, p.freq)
        error('dates:minus:ArgCheck','Input arguments must have common frequencies!')
    end
    if isempty(o) || isempty(p)
        error('dates:minus:ArgCheck','Input arguments must not be empty!')
    end
    u = copy(o);
    v = copy(p);
    if ~isequal(u.length(),v.length())
        if isequal(u.length(),1)
            u.time = repmat(u.time,v.ndat,1);
            u.ndat = v.ndat;
        elseif isequal(v.length(),1)
            v.time = repmat(v.time,u.ndat,1);
            v.ndat = u.ndat;
        else
            error('dates:minus:ArgCheck','Input arguments lengths are not consistent!')
        end
    end
    q = zeros(u.length(),1);
    id = find(~(u==v));
    if ~isempty(id)
        q(id) = u.time(id,2)-v.time(id,2) + (u.time(id,1)-v.time(id,1))*v.freq;
    end
elseif isa(o,'dates') && ~isa(p,'dates')
    if (isvector(p) && isequal(length(p),o.ndat) && all(isint(p))) || (isscalar(p) && isint(p)) || (isequal(o.length(),1) && isvector(p) && all(isint(p)))
        q = dates();
        q.freq = o.freq;
        q.time = add_periods_to_array_of_dates(o.time, o.freq, -p(:));
        q.ndat = rows(q.time);
    else
        error('dates:minus:ArgCheck','Second argument has to be a vector of integers or scalar integer. You should read the manual.')
    end
else
    error('dates:minus:ArgCheck','You should read the manual.')
end

%@test:1
%$ % Define some dates objects
%$ d1 = dates('1950Q1','1950Q2','1960Q1');
%$ d2 = dates('1950Q3','1950Q4','1960Q1');
%$ d3 = dates('2000Q1');
%$ d4 = dates('2002Q2');
%$ % Call the tested routine.
%$ try
%$   e1 = d2-d1;
%$   e2 = d4-d3;
%$   t(1) = 1;
%$ catch
%$   t(1) = 0;
%$ end
%$
%$ if t(1)
%$   t(2) = dassert(e1,[2; 2; 0]);
%$   t(3) = dassert(e2,9);
%$ end
%$ T = all(t);
%@eof:1

%@test:2
%$ % Define some dates objects
%$ d1 = dates('1950Y','1951Y','1953Y');
%$ d2 = dates('1951Y','1952Y','1953Y');
%$ d3 = dates('2000Y');
%$ d4 = dates('1999Y');
%$ % Call the tested routine.
%$ try
%$   e1 = d2-d1;
%$   e2 = d4-d3;
%$   t(1) = 1;
%$ catch
%$   t(1) = 0;
%$ end
%$
%$ if t(1)
%$   t(2) = dassert(e1,[1; 1; 0]);
%$   t(3) = dassert(e2,-1);
%$ end
%$ T = all(t);
%@eof:2

%@test:3
%$ % Define some dates objects
%$ d1 = dates('2000Y');
%$ d2 = dates('1999Y');
%$ % Call the tested routine.
%$ try
%$   e1 = d1-1;
%$   e2 = d2-(-1);
%$   t(1) = 1;
%$ catch
%$   t(1) = 0;
%$ end
%$
%$ if t(1)
%$   t(2) = dassert(e1,d2);
%$   t(3) = dassert(e2,d1);
%$ end
%$ T = all(t);
%@eof:3

%@test:4
%$ % Define some dates objects
%$ d1 = dates('2000Q1');
%$ e1 = dates('1999Q4','1999Q3','1999Q2','1999Q1','1998Q4');
%$ % Call the tested routine.
%$ try
%$   f1 = d1-transpose(1:5);
%$   t(1) = 1;
%$ catch
%$   t(1) = 0;
%$ end
%$
%$ if t(1)
%$   t(2) = dassert(e1,f1);
%$ end
%$ T = all(t);
%@eof:4

%@test:5
%$ % Define some dates objects
%$ d1 = dates('1999Q4','1999Q3','1999Q2','1999Q1','1998Q4');
%$ e1 = dates('2000Q1')*5;
%$ % Call the tested routine.
%$ try
%$   f1 = d1-(-transpose(1:5));
%$   t(1) = 1;
%$ catch
%$   t(1) = 0;
%$ end
%$
%$ if t(1)
%$   t(2) = dassert(e1,f1);
%$ end
%$ T = all(t);
%@eof:5