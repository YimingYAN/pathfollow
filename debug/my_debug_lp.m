clc;
clear all;

%% Check class LP
% Right input without Name
A = [1 2 3];
b = 1;
c = [1 2 3]';

lp = LP(A,b,c)

% Right input with Name
A = randn(2,3);
b = rand(2,1);
c = rand(3,1);
Name = 'lp_debug';
lp = LP(A,b,c,Name)

% Wrong dimension (b)
fprintf('Check: b gets wrong dimension - ')
A = randn(2,1);
b = 1;
c = 1;
try
    lp = LP(A,b,c);
    fprintf('Fail\n');
catch err1
    if strcmp(err1.message, 'LP: data dimensions does not match.')
        fprintf('Pass\n');
    else
        fprintf('Fail\n');
    end
end

% Wrong dimension (c)
fprintf('Check: c gets wrong dimension - ')
A = randn(2,1);
b = [1 2]';
c = [1 2];
try
    lp = LP(A,b,c);
    fprintf('Fail\n');
catch err2
    if strcmp(err1.message, 'LP: data dimensions does not match.')
        fprintf('Pass\n');
    else
        fprintf('Fail\n');
    end
end

% check set methods
% correct x
fprintf('Check: set x - right input - ');
A = randn(2,3);
b = rand(2,1);
c = rand(3,1);

lp = LP(A,b,c);
x = [1 2 3]';
try
    lp.update_x(x);
    if all(lp.x == x)
        fprintf('Pass\n');
    else
        fprintf('Fail\n');
    end
catch
    fprintf('Fail\n');
end

% wrong x
fprintf('Check: set x - wrong input - ');
x = [1 2]';
try
    lp.update_x(x);
    fprintf('Fail\n');
catch err3
    if strcmp(err3.message, 'LP: cannot set x - check the dimension.')
        fprintf('Pass\n');
    else
        fprintf('Fail\n');
    end
end

% correct s
fprintf('Check: set s - right input - ');
s = [1 2 3]';
try
    lp.update_s(s);
    if all(lp.s == s)
        fprintf('Pass\n');
    else
        fprintf('Fail\n');
    end
catch
    fprintf('Fail\n');
end

% wrong s
fprintf('Check: set s - wrong input - ');
s = [1 2]';
try
    lp.update_s(s);
    fprintf('Fail\n');
catch err4
    if strcmp(err4.message, 'LP: cannot set s - check the dimension.')
        fprintf('Pass\n');
    else
        fprintf('Fail\n');
    end
end

% correct y
fprintf('Check: set y - right input - ');
y = [1 3]';
try
    lp.update_y(y);
    if all(lp.y == y)
        fprintf('Pass\n');
    else
        fprintf('Fail\n');
    end
catch
    fprintf('Fail\n');
end

% wrong y
fprintf('Check: set y - wrong input - ');
y = [1 2 3]';
try
    lp.update_y(y);
    fprintf('Fail\n');
catch err4
    if strcmp(err4.message, 'LP: cannot set y - check the dimension.')
        fprintf('Pass\n');
    else
        fprintf('Fail\n');
    end
end
