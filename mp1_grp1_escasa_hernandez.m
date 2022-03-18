%{
    Expression:
    1.) / (5x^3 - 3x^2 + 2)dx from -5 to 5
%}
%{
    Start of program flow
%}

curve = 'y = 5x^3 - 3x^2 + 2'; % expression
method_name = ["Trapzoidal Rule","Simpson's Rule"];

% --> Loop starts here

while true
    fprintf("This script computes the area under the curve %s, given the limits ranging between -5.0 and 5.0.\n",curve);
    fprintf("Method Choices:\n[1] %s\n[2] %s\n",method_name(1),method_name(2));
    
    % Get method input from user
    [method_choice,stop_program] = get_choice();
    
    % Stop the program if user wants to stop
    if stop_program == 1 % Stop program? true
        break;
    end

    % Notify user which method was chosen
    fprintf("You have selected %s\nInside %s\n", ...
            method_name(method_choice),method_name(method_choice));
    
    % Get upper and lower limits
    low_limit = get_num_input('Enter the lower limit: ');
    up_limit = get_num_input('Enter the upper limit: ');
    
    % Get number of intervals 
    num_intervals = get_num_intervals(method_choice);
    
    % Get the interval width
    int_width = get_interval_width(low_limit,up_limit,num_intervals);
    
    % Generate the x values
    x = generate_xvalues(low_limit,up_limit,int_width) % no semicolon to be able to print the values
    
    % Get the results of y for each x values
    y = f_x(x) % no semicolon to be able to print the values
    
    % Get area according to chosen method
    if method_choice == 1
        area = trap_rule(y, int_width);
    else
        area = simp_rule(y, int_width);
    end
    
    % Display area result
    fprintf("The area under the curve for f(x) is %.6f\n\n",area);
    
    % Display plot
    plot(x,y,".-b")
    title("Plot of f(x)")
    grid minor
    shg % places current figure at the front or top of other opened figures
end

% --> Loop ends here

%{
    End of program flow
%}




% ============ FUNCTIONS ============


function [user_choice,stop_bool] = get_choice()
%{
    Returns the choice of the user either one of the 2 methods 
    or end the program.
%}
    stop_bool = 0; % false
    user_choice = 0;

    while true
    tmp_choice = strtrim(input('What is your choice? ','s'));

        if strcmpi(tmp_choice,'stop')
            stop_bool = 1; % true
            break;
        elseif strcmp(tmp_choice,'1') || strcmp(tmp_choice,'2')
            user_choice = str2double(tmp_choice);
            break;
        end
    end
end


function [user_input] = get_num_input(strPrompt)
% Returns the numerical input of the user.
    tmp = '';

    % Continue asking user if input is empty
    % or is not a number(double) input
    while isempty(tmp) || isnan(str2double(tmp))
        tmp = input(strPrompt,'s');
    end

    user_input = str2double(tmp);
end


function [num_intervals] = get_num_intervals(method_chosen)
% Returns number of intervals the user desired to use.
    
    % continuously ask user for number input until entered input is valid
    % for the chosen method/rule of numerical integration
    while true
        num_intervals = get_num_input('Enter the number of intervals desired: ');

        % checks if no. of intervals for simpson's is a positive even
        % number
        if num_intervals > 0 && method_chosen == 2 && mod(num_intervals,2) == 0
            break;
        % checks if no. of intervals for trapezoidal is a positive number
        elseif num_intervals > 0 && method_chosen == 1
            break;
        end
    end
end


function [interval_width] = get_interval_width(lowerlimit,upperlimit,num_intervals)
%{ 
    Returns the width of each interval (interval_width)
    given the number of intervals (num_intervals) by the user.
%}
    interval_width = (upperlimit - lowerlimit) / num_intervals;
end


function [x_values] = generate_xvalues(lowerlimit,upperlimit,intervalwidth)
% Generate the x values.

    lowlim = lowerlimit;
    uplim = upperlimit;
    intwidth = intervalwidth;
    
    if(intwidth < 0) % interval width is a negative number
        % this means that entered upperlimit < lowerlimit
        intwidth = intwidth * -1;
        [lowlim,uplim] = swap(lowlim,uplim); % swap values of up- and lowlim
    elseif(intwidth == 0)
        % lowlim == uplim (one point only)
        x_values = uplim;
        return; % exit this function
    end

    x_values = lowlim:intwidth:uplim;
end


function [num2,num1] = swap(num1,num2)
% Swaps the value of two numerical variables.
% Similar to the overloaded assignment operation (k,j = j,k)
% that is present in Python and Ruby.
end


function [y_results] = f_x(x_vals)
% Results for function (5x^3 - 3x^2 + 2) for each x values.
    y_results = 5.*x_vals.^3 - 3.*x_vals.^2 + 2;
end


function [trap_rslt] = trap_rule(y_results,interval_width)
% Returns the result of the Definite Integral using the Trapezoidal Rule.
    trap_rslt = 0; % default result

    % if 1 interval then y_results has 2 elements
    if(numel(y_results) == 2) % min no. of interval = 1
        trap_rslt = interval_width * ((1/2)*(y_results(1)+y_results(2)));
    elseif(numel(y_results) > 2) % for greater than 1 intervals
        trap_rslt = (interval_width) * ((1/2)*(y_results(1)+y_results(end))+ ...
                sum(y_results(2:end-1)));
    end
end


function [simp_rslt] = simp_rule(y_results,interval_width)
% Returns the result of the Definite Integral using the Simpson's Rule.
    simp_rslt = 0; % default result

    % if 2 intervals then y_results has 3 elements
    if(numel(y_results) == 3) % min no. of interval = 2
        simp_rslt = (1/3)*interval_width * ((y_results(1)+y_results(3)) + ...
            4*y_results(2));
    elseif(numel(y_results) > 3) % more than 2 intervals
        simp_rslt = (1/3)*interval_width * ((y_results(1)+y_results(end)) + ...
            4*sum(y_results(2:2:end-1)) + 2*sum(y_results(3:2:end-2)));
    end
end
