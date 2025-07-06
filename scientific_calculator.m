function scientific_calculator()
    % Global memory variable
    global memory_value;
    memory_value = 0;

    % Create main figure window
    fig = figure('Name', 'Scientific Calculator', ...
                 'NumberTitle', 'off', ...
                 'Position', [400, 100, 700, 900], ...
                 'Color', [0.95 0.95 0.95], ...
                 'MenuBar', 'none', ...
                 'Resize', 'off');

    % Dark Mode Color Scheme
    dark_mode = struct(...
      'bg', [0.12 0.12 0.12],           % Very dark background
      'btn_numeric', [0.2 0.2 0.2],      % Dark gray for numeric buttons
      'btn_scientific', [0.15 0.15 0.2], % Dark blue-gray for scientific buttons
      'btn_operator', [0.1 0.1 0.15],    % Very dark blue-gray for operator buttons
      'btn_statistical', [0.2 0.2 0.3], % Dark blue-gray for statistical functions
      'btn_matrix', [0.1 0.2 0.1],      % Dark green for matrix operations
      'btn_complex', [0.2 0.1 0.3],     % Dark purple for complex operations
      'text', [1 1 1],                   % Very light text for contrast
      'display_bg', [0.10 0.10 0.10]     % Almost black display background
    );

    % Light Mode Color Scheme
    light_mode = struct(...
        'bg', [0.95 0.95 0.95],            % Light gray background
        'btn_numeric', [1 1 1],             % Pure white numeric buttons
        'btn_scientific', [0.90 0.92 0.98], % Soft blue-gray scientific buttons
        'btn_operator', [0.88 0.90 0.96],   % Soft blue-gray operator buttons
        'btn_statistical', [0.9 0.92 1],   % Soft blue-gray for statistical functions
        'btn_matrix', [0.9 1 0.9],         % Light green for matrix operations
        'btn_complex', [0.9 0.8 1],
        'text', [0.1 0.1 0.1],              % Very dark text
        'display_bg', 'white'               % White display background
    );


    % Store mode settings in figure's application data
    setappdata(fig, 'light_mode', light_mode);
    setappdata(fig, 'dark_mode', dark_mode);
    setappdata(fig, 'current_mode', light_mode);

    % Display Screen
    display = uicontrol('Parent', fig, ...
                        'Style', 'edit', ...
                        'Units', 'normalized', ...
                        'Position', [0.05 0.85 0.9 0.1], ...
                        'FontSize', 22, ...
                        'FontWeight', 'bold', ...
                        'HorizontalAlignment', 'right', ...
                        'BackgroundColor', 'white', ...
                        'String', '0');

    % Result Display
    result_display = uicontrol('Parent', fig, ...
                               'Style', 'text', ...
                               'Units', 'normalized', ...
                               'Position', [0.05 0.77 0.9 0.07], ...
                               'FontSize', 16, ...
                               'HorizontalAlignment', 'right', ...
                               'BackgroundColor', [0.95 0.95 0.95]);

    % Mode Toggle Button
    mode_toggle = uicontrol('Parent', fig, ...
                             'Style', 'togglebutton', ...
                             'Units', 'normalized', ...
                             'Position', [0.75 0.95 0.2 0.04], ...
                             'String', 'Dark Mode', ...
                             'Callback', @toggle_mode);

    % Angle Mode Segmented Control
    angle_panel = uipanel('Parent', fig, ...
                          'Units', 'normalized', ...
                          'Position', [0.05 0.70 0.9 0.06], ...
                          'Title', 'Angle Mode', ...
                          'FontSize', 10);

    % Create deg_mode and rad_mode
    deg_mode = uicontrol(angle_panel, 'Style', 'radiobutton', ...
                         'Units', 'normalized', ...
                         'Position', [0.5 0.2 0.4 0.6], ...
                         'String', 'Degrees', ...
                         'Value', 0);

    rad_mode = uicontrol(angle_panel, 'Style', 'radiobutton', ...
                         'Units', 'normalized', ...
                         'Position', [0.1 0.2 0.4 0.6], ...
                         'String', 'Radians', ...
                         'Callback', {@angle_mode_callback, fig, deg_mode}, ...
                         'Value', 1);

    % callback to reference rad_mode
    set(deg_mode, 'Callback', {@angle_mode_callback, fig, rad_mode});



   button_layout = {
      'M+', 'M-', 'MR', 'MC', '', '←', 'AC';               % Memory & Control Functions
      'Mean', 'Median', 'Mode', 'Std Dev', 'Variance', 'Range', 'Quartile'; % Statistical Functions
      '','Matrix+', 'Matrix-', 'Matrix*', 'Matrix^T', 'Matrix^-1', '';   % Matrix Operations
      '','Complex+', 'Complex-', 'Complex*', 'Complex/', 'Complex Conj', ''; % Complex Number Operations
      'x!','nthRoot', '(', ')', '%', '÷', '';                    % General Functions (Factorial, Parentheses, etc.)
      'Inv', 'sin', 'ln', '7', '8', '9', '×';             % Scientific Functions & Numbers
      'π', 'cos', 'log', '4', '5', '6', '-';              % Constants & Numbers
      'e', 'tan', '√', '1', '2', '3', '+';                % Scientific Functions & Numbers
      'Ans', 'EXP', '^', '0', '00', '.', '='              % Result & Finalization
   };


    % Button Creation
    [rows, cols] = size(button_layout);
    btn_spacing = 0.01;
    btn_width = (0.9 / cols) - btn_spacing;
    btn_height = (0.5 / rows) - btn_spacing;

    % Get current mode for initial button colors
    current_mode = getappdata(fig, 'current_mode');

    for row = 1:rows
        for col = 1:cols
            btn_text = button_layout{row, col};

            % Determine button color and style based on current mode
            if any(strcmp(btn_text, {'7','8','9','4','5','6','1','2','3','0','00','.'}))
                btn_color = current_mode.btn_numeric;
                font_weight = 'bold';
            elseif any(strcmp(btn_text, {'sin','cos','tan','ln','log','√','x!','nthRoot','Inv','e','EXP','π'}))
                btn_color = current_mode.btn_scientific;
                font_weight = 'normal';
            elseif any(strcmp(btn_text, {'+','-','×','÷','=','(',')','^','%','AC','←','M+', 'M-', 'MR', 'MC','Ans'}))
                btn_color = current_mode.btn_operator;
                font_weight = 'bold';
            % Matrix Functions
            elseif any(strcmp(btn_text, {'Matrix+', 'Matrix-', 'Matrix*', 'Matrix^T', 'Matrix^-1', 'Matrix/'}))
                btn_color = current_mode.btn_matrix;
                font_weight = 'normal';

            % Complex Functions
            elseif any(strcmp(btn_text, {'Complex+', 'Complex-', 'Complex*', 'Complex/', 'Complex Conj', 'Complex Abs', 'Complex^'}))
                btn_color = current_mode.btn_complex;
                font_weight = 'normal';

            % Statistical Functions
            elseif any(strcmp(btn_text, {'Mean', 'Median', 'Mode', 'Std Dev', 'Variance', 'Range', 'Quartile'}))
                btn_color = current_mode.btn_statistical;
                font_weight = 'normal';
            else
                btn_color = [0.9 0.9 0.9];
                font_weight = 'normal';
            end

            % Calculate button position
            x = 0.05 + (col-1) * (btn_width + btn_spacing);
            y = 0.15 + (rows - row) * (btn_height + btn_spacing);

            % Create button with styling
            btn = uicontrol('Parent', fig, ...
                            'Style', 'pushbutton', ...
                            'Units', 'normalized', ...
                            'Position', [x, y, btn_width, btn_height], ...
                            'String', btn_text, ...
                            'FontSize', 14, ...
                            'FontWeight', font_weight, ...
                            'BackgroundColor', btn_color, ...
                            'Callback', {@button_press, display, result_display});
        end
    end

    % UI Configurations
    set(fig, 'KeyPressFcn', {@keyboard_input, display});
end



% Mode Toggle Function
function toggle_mode(src, ~)
    fig = gcf;
    light_mode = getappdata(fig, 'light_mode');
    dark_mode = getappdata(fig, 'dark_mode');

    if get(src, 'Value')
        % Switch to Dark Mode
        setappdata(fig, 'current_mode', dark_mode);
        set(src, 'String', 'Light Mode');
        update_ui_colors(fig, dark_mode);
    else
        % Switch to Light Mode
        setappdata(fig, 'current_mode', light_mode);
        set(src, 'String', 'Dark Mode');
        update_ui_colors(fig, light_mode);
    end
end

% UI Colors Function
function update_ui_colors(fig, mode)
    % Update figure and child component colors
    set(fig, 'Color', mode.bg);

    % Get all uicontrols
    controls = findall(fig, 'Type', 'uicontrol');

    for i = 1:length(controls)
        switch get(controls(i), 'Style')
            case 'edit'
                set(controls(i), 'BackgroundColor', mode.display_bg, 'ForegroundColor', mode.text);
            case 'text'
                set(controls(i), 'BackgroundColor', mode.bg, 'ForegroundColor', mode.text);
            case 'pushbutton'
                % button background color based on its text
                btn_text = get(controls(i), 'String');
                if any(strcmp(btn_text, {'7','8','9','4','5','6','1','2','3','0','00','.',''}))
                    set(controls(i), 'BackgroundColor', mode.btn_numeric, 'ForegroundColor', mode.text);
                elseif any(strcmp(btn_text, {'sin','cos','tan','ln','log','√','x!','nthRoot','Inv','e','EXP','π','^'}))
                    set(controls(i), 'BackgroundColor', mode.btn_scientific, 'ForegroundColor', mode.text);
                elseif any(strcmp(btn_text, {'Matrix+', 'Matrix-', 'Matrix*', 'Matrix^T', 'Matrix^-1', 'Matrix/', 'Matrix√'}))
                    set(controls(i), 'BackgroundColor', mode.btn_matrix, 'ForegroundColor', mode.text);
                elseif any(strcmp(btn_text, {'Complex+', 'Complex-', 'Complex*', 'Complex/', 'Complex Conj', 'Complex Abs', 'Complex^'}))
                    set(controls(i), 'BackgroundColor', mode.btn_complex, 'ForegroundColor', mode.text);
                elseif any(strcmp(btn_text, {'Mean', 'Median', 'Mode', 'Std Dev', 'Variance', 'Range', 'Quartile'}))
                    set(controls(i), 'BackgroundColor', mode.btn_statistical, 'ForegroundColor', mode.text);
                elseif any(strcmp(btn_text, {'+','-','×','÷','=','(',')','%','AC','←','M+', 'M-', 'MR', 'MC','Ans'}))
                    set(controls(i), 'BackgroundColor', mode.btn_operator, 'ForegroundColor', mode.text);
                end
            case {'radiobutton', 'togglebutton'}
                set(controls(i), 'ForegroundColor', mode.text, 'BackgroundColor', mode.bg);
        end
    end
end

% the angle mode callback
function angle_mode_callback(src, ~, fig, other_btn)
    % Uncheck the other radio button
    set(other_btn, 'Value', 0);

    if strcmp(get(src, 'String'), 'Radians')
        setappdata(fig, 'angle_mode', 'radians');
    else
        setappdata(fig, 'angle_mode', 'degrees');
    end
end

% Factorial Function
function result = factorial(n)
    if n < 0
        error('Factorial is not defined for negative numbers');
    end
    if floor(n) ~= n
        error('Factorial is only defined for non-negative integers');
    end

    result = 1;
    for i = 2:n
        result = result * i;
    end
end

% Statistical Functions
function result = calculate_mean(data)
    % Calculate mean (average)
    result = mean(data);
end

function result = calculate_median(data)
    % Calculate median
    result = median(data);
end

function result = calculate_mode(data)
    % Calculate mode. In case of multiple modes, return the first one
    [freq, values] = hist(data, unique(data));
    [max_freq, idx] = max(freq);
    result = values(idx(1));
end

function result = calculate_std_dev(data)
    % Calculate standard deviation
    result = std(data);
end

function result = calculate_variance(data)
    % Calculate variance
    result = var(data);
end

function result = calculate_range(data)
    % Calculate range
    result = max(data) - min(data);
end

function result = calculate_quartile(data, q)
    % Calculate specific quartile
    switch q
        case 1  % First quartile (Q1)
            result = prctile(data, 25);
        case 2  % Median (Q2)
            result = prctile(data, 50);
        case 3  % Third quartile (Q3)
            result = prctile(data, 75);
        otherwise
            error('Invalid quartile. Choose 1, 2, or 3.');
    end
end

% Helper function to parse input string into numeric array
function data = parse_input_data(input_str)
    % Replace commas with spaces and split
    input_str = strrep(input_str, ',', ' ');

    % Split the string and convert to numeric array
    data_cell = strsplit(input_str);
    data = [];

    for i = 1:length(data_cell)
        % Convert each cell to numeric, skip empty cells
        if ~isempty(strtrim(data_cell{i}))
            num = str2double(data_cell{i});
            if ~isnan(num)
                data(end+1) = num;
            end
        end
    end

    % Check if data is empty
    if isempty(data)
        error('No valid numeric data found');
    end
end


function button_press(src, event, display, result_display)
    global memory_value;
    current_val = get(display, 'string');
    btn_text = get(src, 'string');

    % Memory Operation Handling
    switch btn_text
        case 'M+'
            try
                % Add current display value to memory
                current_num = str2double(current_val);
                if ~isnan(current_num)
                    memory_value = memory_value + current_num;
                    set(result_display, 'string', ['Memory: ' num2str(memory_value)]);
                end
            catch
                set(display, 'string', 'Error');
            end
            return;

        case 'M-'
            try
                % Subtract current display value from memory
                current_num = str2double(current_val);
                if ~isnan(current_num)
                    memory_value = memory_value - current_num;
                    set(result_display, 'string', ['Memory: ' num2str(memory_value)]);
                end
            catch
                set(display, 'string', 'Error');
            end
            return;

        case 'MR'
            % Recall memory value
            set(display, 'string', [current_val, num2str(memory_value)]);
            return;

        case 'MC'
            % Clear memory
            memory_value = 0;
            set(result_display, 'string', 'Memory cleared');
            return;
    end

    % Get current angle mode
    angle_mode = getappdata(gcf, 'angle_mode');

    % Flag to track if inverse function is active
    persistent inv_active
    if isempty(inv_active)
        inv_active = false;
    end

    switch btn_text
        case {'0','1','2','3','4','5','6','7','8','9','00','.','(',')'}
            set(display, 'string', [current_val, btn_text]);

        case 'Inv'
            % Toggle inverse mode
            inv_active = ~inv_active;

        case {'sin', 'cos', 'tan'}
            if inv_active
                % Inverse trigonometric functions
                switch btn_text
                    case 'sin'
                        btn_text = 'asin';
                    case 'cos'
                        btn_text = 'acos';
                    case 'tan'
                        btn_text = 'atan';
                end
                inv_active = false;  % Reset inverse mode
            end

            % Handle angle conversion
            if strcmp(angle_mode, 'degrees')
                set(display, 'string', [current_val, btn_text, 'deg(']);
            else
                set(display, 'string', [current_val, btn_text, '(']);
            end

        case 'x!'
            try
                n = str2double(current_val);
                result = factorial(n);
                set(display, 'string', num2str(result));
            catch ME
                set(display, 'string', 'Error');
                warning(ME.message);
            end

        case 'AC'
            set(display, 'string', '');
            set(result_display, 'string', '');

        case '←'
            if ~isempty(current_val)
                set(display, 'string', current_val(1:end-1));
            end

        case {'+', '-'}
          switch btn_text
              case '+'
                  operator = '+';
              case '-'
                  operator = '-';
          end

          % Safely concatenate current_val and operator for display
          if ischar(current_val) || isstring(current_val)
              display_value = [char(current_val), operator]; % Ensure both are strings
          elseif isnumeric(current_val)
              display_value = [num2str(current_val), operator];
          else
              error('Invalid input: current_val must be numeric or a string.');
          end

          set(display, 'string', display_value);

        case '÷'
            set(display, 'string', [current_val, '/']);

        case '×'
            set(display, 'string', [current_val, '*']);

        case '^'
            set(display, 'string', [current_val, '^']);

        case '%'
            set(display, 'string', [current_val, 'mod(', current_val, ',']);

        case '√'
          try

              % Get current value from display
              current_val = get(display, 'string');

              % Convert to numeric value
              num = str2double(current_val);

              % Check if conversion was successful
              if ~isnan(num)
                  % Calculate square root
                  result = sqrt(num);

                  % Display result
                  set(display, 'string', num2str(result));
                  set(result_display, 'string', 'Square Root Result');
              else
                  % Handle invalid input
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', 'Error: Not a valid number');
              end
          catch ME
              % Handle any unexpected errors
              set(display, 'string', 'Error');
              set(result_display, 'string', ME.message);
          end

        case 'nthRoot'
          % Input for root degree and value
          root_degree_input = inputdlg({'Enter Root Degree (n):', 'Enter Value'}, 'Nth Root Calculator');

          if ~isempty(root_degree_input) && length(root_degree_input) == 2
              try
                  % Convert inputs to numeric values
                  n = str2double(root_degree_input{1});
                  x = str2double(root_degree_input{2});

                  % Validate inputs
                  if isnan(n) || isnan(x)
                      error('Invalid numeric input');
                  end

                  % Handle different root scenarios
                  if n == 0
                      set(display, 'string', 'Error: Root degree cannot be zero');
                      set(result_display, 'string', 'Invalid Input');
                      return;
                  end

                  % Even root of negative number handling
                  if mod(n, 2) == 0 && x < 0
                      set(display, 'string', 'Error: Even root of negative number');
                      set(result_display, 'string', 'Complex Result Not Supported');
                      return;
                  end

                  % Calculate nth root
                  if n > 0
                      % Positive root degree
                      result = x^(1/n);
                  else
                      % Negative root degree (reciprocal)
                      result = x^(-1/abs(n));
                  end

                  % Display result
                  set(display, 'string', num2str(result));
                  set(result_display, 'string', [num2str(n), 'th Root Result']);

              catch ME
                  % Error handling
                  set(display, 'string', 'Error');
                  set(result_display, 'string', ME.message);
                  warning(ME.message);
              end
          end

      case '³√'  % Cube Root - Quick Access Variant
          try
              % Get current value from display
              current_val = get(display, 'string');

              % Convert to numeric value
              num = str2double(current_val);

              % Check if conversion was successful
              if ~isnan(num)
                  % Calculate cube root
                  result = nthroot(num, 3);

                  % Display result
                  set(display, 'string', num2str(result));
                  set(result_display, 'string', 'Cube Root Result');
              else
                  % Handle invalid input
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', 'Error: Not a valid number');
              end
          catch ME
              % Handle any unexpected errors
              set(display, 'string', 'Error');
              set(result_display, 'string', ME.message);
          end

      case '⁴√'  % Fourth Root - Quick Access Variant
          try
              % Get current value from display
              current_val = get(display, 'string');

              % Convert to numeric value
              num = str2double(current_val);

              % Check if conversion was successful
              if ~isnan(num)
                  % Calculate fourth root
                  result = num^(1/4);

                  % Display result
                  set(display, 'string', num2str(result));
                  set(result_display, 'string', 'Fourth Root Result');
              else
                  % Handle invalid input
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', 'Error: Not a valid number');
              end
          catch ME
              % Handle any unexpected errors
              set(display, 'string', 'Error');
              set(result_display, 'string', ME.message);
          end

        case 'log'
            % inout for base of logarithm
            log_input = inputdlg({
                'Enter number to calculate log of:',
                'Enter log base (optional, default = 10):'
            }, 'Logarithm Calculator');

            if ~isempty(log_input)
                try
                    % Parse input values
                    number = str2double(log_input{1});

                    % Default to base 10 if not specified
                    if isempty(log_input{2}) || strcmp(log_input{2}, '')
                        base = 10;
                    else
                        base = str2double(log_input{2});
                    end

                    % Validate inputs
                    if isnan(number) || isnan(base)
                        set(display, 'string', 'Invalid Input');
                        set(result_display, 'string', 'Error: Not a valid number');
                        return;
                    end

                    % Check for valid logarithm conditions
                    if number <= 0
                        set(display, 'string', 'Invalid Input');
                        set(result_display, 'string', 'Error: Log undefined for non-positive numbers');
                        return;
                    end

                    if base <= 0 || base == 1
                        set(display, 'string', 'Invalid Input');
                        set(result_display, 'string', 'Error: Invalid log base');
                        return;
                    end

                    % Calculate logarithm
                    if base == 10
                        % Use built-in log10 for base 10
                        result = log10(number);
                    elseif base == exp(1)
                        % Use natural log for base e
                        result = log(number);
                    else
                        % Use change of base formula
                        result = log(number) / log(base);
                    end

                    % Display result
                    set(display, 'string', num2str(result));
                    set(result_display, 'string', ['Log base ' num2str(base) ' of ' num2str(number)]);

                catch ME
                    % Handle any unexpected errors
                    set(display, 'string', 'Error');
                    set(result_display, 'string', ME.message);
                    warning(ME.message);
                end
            end

        case 'ln'
            % Natural logarithm (base e)
            try
                % Convert current value to numeric
                number = str2double(current_val);

                % Validate input
                if isnan(number)
                    set(display, 'string', 'Invalid Input');
                    set(result_display, 'string', 'Error: Not a valid number');
                    return;
                end

                % Check for valid logarithm conditions
                if number <= 0
                    set(display, 'string', 'Invalid Input');
                    set(result_display, 'string', 'Error: Ln undefined for non-positive numbers');
                    return;
                end

                % Calculate natural logarithm
                result = log(number);

                % Display result
                set(display, 'string', num2str(result));
                set(result_display, 'string', ['Natural Log of ' num2str(number)]);

            catch ME
                % Handle any unexpected errors
                set(display, 'string', 'Error');
                set(result_display, 'string', ME.message);
                warning(ME.message);
            end

        case 'EXP'
            set(display, 'string', [current_val, 'e']);

        case 'π'
            set(display, 'string', [current_val, num2str(pi)]);

        case 'e'
            set(display, 'string', [current_val, num2str(exp(1))]);

        case '='
            try
                % Manual replacement for contains
                deg_check = strfind(current_val, 'deg(');
                if ~isempty(deg_check)
                    % Replace deg() with conversion
                    current_val = regexprep(current_val, '(\w+)deg\(', '$1(deg2rad(');
                    current_val = strrep(current_val, ')', '))');
                end

                result = eval(current_val);
                set(display, 'string', num2str(result));
                set(result_display, 'string', ['Ans = ', num2str(result)]);
            catch ME
                set(display, 'string', 'Error');
                warning(ME.message);
            end

        case 'Ans'
            last_result = get(result_display, 'string');
            if ~isempty(last_result)
                ans_val = strsplit(last_result, ' = ');
                set(display, 'string', [current_val, ans_val{2}]);
            end

        case 'Matrix+'
            % Create an input dialog for matrix dimensions
            prompt = {'Enter number of rows:', 'Enter number of columns:'};
            dlg_title = 'Matrix Dimensions';
            num_lines = 1;
            default_ans = {'3', '3'};

            % Use inputdlg for dimension input
            dims = inputdlg(prompt, dlg_title, num_lines, default_ans);

            if ~isempty(dims)
                rows = str2double(dims{1});
                cols = str2double(dims{2});

                % Create matrix input dialog
                matrix_prompt = cell(rows, 1);
                for r = 1:rows
                    matrix_prompt{r} = sprintf('Enter row %d (separate values by space):', r);
                end

                matrix_title = 'Enter Matrix A';
                matrix_lines = 1;
                matrix_default = repmat({'0 0 0'}, rows, 1);

                % Get matrix A input
                matrix_A = inputdlg(matrix_prompt, matrix_title, matrix_lines, matrix_default);

                % Repeat for matrix B
                matrix_title = 'Enter Matrix B';
                matrix_B = inputdlg(matrix_prompt, matrix_title, matrix_lines, matrix_default);

                % Convert string inputs to numeric matrix
                try
                    % Parse each row
                    A = zeros(rows, cols);
                    B = zeros(rows, cols);

                    for r = 1:rows
                        A(r, :) = str2num(matrix_A{r});
                        B(r, :) = str2num(matrix_B{r});
                    end

                    % Perform matrix addition
                    result = A + B;

                    % Display result on calculator screen
                    result_str = mat2str(result);
                    set(display, 'string', result_str);
                    set(result_display, 'string', 'Matrix Addition Result');

                catch ME
                    % Handle input conversion errors
                    set(display, 'string', 'Invalid Matrix Input');
                    set(result_display, 'string', 'Error: Check your input');
                    warning(ME.message);
                end
            end

        case 'Matrix-'
          % Create an input dialog for matrix dimensions
          prompt = {'Enter number of rows:', 'Enter number of columns:'};
          dlg_title = 'Matrix Dimensions';
          num_lines = 1;
          default_ans = {'3', '3'};

          % Use inputdlg for dimension input
          dims = inputdlg(prompt, dlg_title, num_lines, default_ans);

          if ~isempty(dims)
              rows = str2double(dims{1});
              cols = str2double(dims{2});

              % Create matrix input dialog
              matrix_prompt = cell(rows, 1);
              for r = 1:rows
                  matrix_prompt{r} = sprintf('Enter row %d (separate values by space):', r);
              end

              matrix_title = 'Enter Matrix A';
              matrix_lines = 1;
              matrix_default = repmat({'0 0 0'}, rows, 1);

              % Get matrix A input
              matrix_A = inputdlg(matrix_prompt, matrix_title, matrix_lines, matrix_default);

              % Repeat for matrix B
              matrix_title = 'Enter Matrix B';
              matrix_B = inputdlg(matrix_prompt, matrix_title, matrix_lines, matrix_default);

              % Convert string inputs to numeric matrix
              try
                  % Parse each row
                  A = zeros(rows, cols);
                  B = zeros(rows, cols);

                  for r = 1:rows
                      A(r, :) = str2num(matrix_A{r});
                      B(r, :) = str2num(matrix_B{r});
                  end

                  % Perform matrix subtraction
                  result = A - B;

                  % Display result on calculator screen
                  result_str = mat2str(result);
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Matrix Subtraction Result');

        catch ME
            % Handle input conversion errors
            set(display, 'string', 'Invalid Matrix Input');
            set(result_display, 'string', 'Error: Check your input');
            warning(ME.message);
        end
     end

      case 'Matrix*'
          % Create an input dialog for matrix dimensions
          prompt = {'Enter rows for Matrix A:', 'Enter columns for Matrix A:', ...
                    'Enter rows for Matrix B:', 'Enter columns for Matrix B:'};
          dlg_title = 'Matrix Multiplication Dimensions';
          num_lines = 1;
          default_ans = {'3', '3', '3', '3'};

          % Use inputdlg for dimension input
          dims = inputdlg(prompt, dlg_title, num_lines, default_ans);

          if ~isempty(dims)
              rows_A = str2double(dims{1});
              cols_A = str2double(dims{2});
              rows_B = str2double(dims{3});
              cols_B = str2double(dims{4});

              % Check matrix multiplication compatibility
              if cols_A ~= rows_B
                  set(display, 'string', 'Invalid Matrix Dimensions');
                  set(result_display, 'string', 'Error: Columns of A must equal rows of B');
                  return;
              end

              % Create matrix input dialog for A
              matrix_prompt_A = cell(rows_A, 1);
              for r = 1:rows_A
                  matrix_prompt_A{r} = sprintf('Enter row %d of Matrix A (separate values by space):', r);
              end

              matrix_title_A = 'Enter Matrix A';
              matrix_lines = 1;
              matrix_default_A = repmat({'0 0 0'}, rows_A, 1);

              % Get matrix A input
              matrix_A = inputdlg(matrix_prompt_A, matrix_title_A, matrix_lines, matrix_default_A);

              % Create matrix input dialog for B
              matrix_prompt_B = cell(rows_B, 1);
              for r = 1:rows_B
                  matrix_prompt_B{r} = sprintf('Enter row %d of Matrix B (separate values by space):', r);
              end

              matrix_title_B = 'Enter Matrix B';
              matrix_default_B = repmat({'0 0 0'}, rows_B, 1);

              % Get matrix B input
              matrix_B = inputdlg(matrix_prompt_B, matrix_title_B, matrix_lines, matrix_default_B);

              % Convert string inputs to numeric matrix
              try
                  % Parse each row
                  A = zeros(rows_A, cols_A);
                  B = zeros(rows_B, cols_B);

                  for r = 1:rows_A
                      A(r, :) = str2num(matrix_A{r});
                  end

                  for r = 1:rows_B
                      B(r, :) = str2num(matrix_B{r});
                  end

                  % Perform matrix multiplication
                  result = A * B;

                  % Display result on calculator screen
                  result_str = mat2str(result);
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Matrix Multiplication Result');

          catch ME
              % Handle input conversion errors
              set(display, 'string', 'Invalid Matrix Input');
              set(result_display, 'string', 'Error: Check your input');
              warning(ME.message);
          end
      end

      case 'Matrix^T'
          % Create an input dialog for matrix dimensions
          prompt = {'Enter number of rows:', 'Enter number of columns:'};
          dlg_title = 'Matrix Transpose Dimensions';
          num_lines = 1;
          default_ans = {'3', '3'};

          % Use inputdlg for dimension input
          dims = inputdlg(prompt, dlg_title, num_lines, default_ans);

          if ~isempty(dims)
              rows = str2double(dims{1});
              cols = str2double(dims{2});

              % Create matrix input dialog
              matrix_prompt = cell(rows, 1);
              for r = 1:rows
                  matrix_prompt{r} = sprintf('Enter row %d (separate values by space):', r);
              end

              matrix_title = 'Enter Matrix for Transpose';
              matrix_lines = 1;
              matrix_default = repmat({'0 0 0'}, rows, 1);

              % Get matrix input
              matrix_input = inputdlg(matrix_prompt, matrix_title, matrix_lines, matrix_default);

              % Convert string inputs to numeric matrix
              try
                  % Parse each row
                  A = zeros(rows, cols);

                  for r = 1:rows
                      A(r, :) = str2num(matrix_input{r});
                  end

                  % Perform matrix transpose
                  result = A';

                  % Display result on calculator screen
                  result_str = mat2str(result);
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Matrix Transpose Result');

              catch ME
                  % Handle input conversion errors
                  set(display, 'string', 'Invalid Matrix Input');
                  set(result_display, 'string', 'Error: Check your input');
                  warning(ME.message);
              end
          end

      case 'Matrix^-1'
          % Create an input dialog for matrix dimensions
          prompt = {'Enter number of rows (square matrix):', 'Enter number of columns (square matrix):'};
          dlg_title = 'Matrix Inverse Dimensions';
          num_lines = 1;
          default_ans = {'3', '3'};

          % Use inputdlg for dimension input
          dims = inputdlg(prompt, dlg_title, num_lines, default_ans);

          if ~isempty(dims)
              rows = str2double(dims{1});
              cols = str2double(dims{2});

              % Check if the matrix is square
              if rows ~= cols
                  set(display, 'string', 'Invalid Matrix Dimensions');
                  set(result_display, 'string', 'Error: Matrix must be square for inversion');
                  return;
              end

              % Create matrix input dialog
              matrix_prompt = cell(rows, 1);
              for r = 1:rows
                  matrix_prompt{r} = sprintf('Enter row %d (separate values by space):', r);
              end

              matrix_title = 'Enter Matrix for Inversion';
              matrix_lines = 1;
              matrix_default = repmat({'0 0 0'}, rows, 1);

              % Get matrix input
              matrix_input = inputdlg(matrix_prompt, matrix_title, matrix_lines, matrix_default);

              % Convert string inputs to numeric matrix
              try
                  % Parse each row
                  A = zeros(rows, cols);

                  for r = 1:rows
                      A(r, :) = str2num(matrix_input{r});
                  end

                  % Perform matrix inversion
                  result = inv(A);

                  % Display result on calculator screen
                  result_str = mat2str(result);
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Matrix Inversion Result');

              catch ME
                  % Handle input conversion errors
                  set(display, 'string', 'Invalid Matrix Input');
                  set(result_display, 'string', 'Error: Check your input');
                  warning(ME.message);
              end
         end

        case 'Complex+'
          % Input for first complex number
          prompt1 = {'Enter real part of first complex number:', 'Enter imaginary part of first complex number:'};
          dlg_title1 = 'First Complex Number';
          num_lines = 1;
          default_ans1 = {'0', '0'};

          complex_A = inputdlg(prompt1, dlg_title1, num_lines, default_ans1);

          % Input for second complex number
          prompt2 = {'Enter real part of second complex number:', 'Enter imaginary part of second complex number:'};
          dlg_title2 = 'Second Complex Number';

          complex_B = inputdlg(prompt2, dlg_title2, num_lines, default_ans1);

          % Validate and process inputs
          if ~isempty(complex_A) && ~isempty(complex_B)
              try
                  % Convert inputs to numeric values
                  real_A = str2double(complex_A{1});
                  imag_A = str2double(complex_A{2});
                  real_B = str2double(complex_B{1});
                  imag_B = str2double(complex_B{2});

                  % Create complex numbers
                  A = complex(real_A, imag_A);
                  B = complex(real_B, imag_B);

                  % Perform addition
                  result = A + B;

                  % Display result
                  result_str = sprintf('%.2f + %.4fi', real(result), imag(result));
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Complex Addition Result');

              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', 'Error in Complex Addition');
                  warning(ME.message);
              end
          end

      case 'Complex-'
          % Input for first complex number
          prompt1 = {'Enter real part of first complex number:', 'Enter imaginary part of first complex number:'};
          dlg_title1 = 'First Complex Number';
          num_lines = 1;
          default_ans1 = {'0', '0'};

          complex_A = inputdlg(prompt1, dlg_title1, num_lines, default_ans1);

          % Input for second complex number
          prompt2 = {'Enter real part of second complex number:', 'Enter imaginary part of second complex number:'};
          dlg_title2 = 'Second Complex Number';

          complex_B = inputdlg(prompt2, dlg_title2, num_lines, default_ans1);

          % Validate and process inputs
          if ~isempty(complex_A) && ~isempty(complex_B)
              try
                  % Convert inputs to numeric values
                  real_A = str2double(complex_A{1});
                  imag_A = str2double(complex_A{2});
                  real_B = str2double(complex_B{1});
                  imag_B = str2double(complex_B{2});

                  % Create complex numbers
                  A = complex(real_A, imag_A);
                  B = complex(real_B, imag_B);

                  % Perform subtraction
                  result = A - B;

                  % Display result
                  result_str = sprintf('%.4f + %.4fi', real(result), imag(result));
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Complex Subtraction Result');

              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', 'Error in Complex Subtraction');
                  warning(ME.message);
              end
          end

      case 'Complex*'
          % Input for first complex number
          prompt1 = {'Enter real part of first complex number:', 'Enter imaginary part of first complex number:'};
          dlg_title1 = 'First Complex Number';
          num_lines = 1;
          default_ans1 = {'0', '0'};

          complex_A = inputdlg(prompt1, dlg_title1, num_lines, default_ans1);

          % Input for second complex number
          prompt2 = {'Enter real part of second complex number:', 'Enter imaginary part of second complex number:'};
          dlg_title2 = 'Second Complex Number';

          complex_B = inputdlg(prompt2, dlg_title2, num_lines, default_ans1);

          % Validate and process inputs
          if ~isempty(complex_A) && ~isempty(complex_B)
              try
                  % Convert inputs to numeric values
                  real_A = str2double(complex_A{1});
                  imag_A = str2double(complex_A{2});
                  real_B = str2double(complex_B{1});
                  imag_B = str2double(complex_B{2});

                  % Create complex numbers
                  A = complex(real_A, imag_A);
                  B = complex(real_B, imag_B);

                  % Perform multiplication
                  result = A * B;

                  % Display result
                  result_str = sprintf('%.4f + %.4fi', real(result), imag(result));
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Complex Multiplication Result');

              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', 'Error in Complex Multiplication');
                  warning(ME.message);
              end
          end

      case 'Complex/'
          % Input for first complex number
          prompt1 = {'Enter real part of first complex number:', 'Enter imaginary part of first complex number:'};
          dlg_title1 = 'First Complex Number (Dividend)';
          num_lines = 1;
          default_ans1 = {'0', '0'};

          complex_A = inputdlg(prompt1, dlg_title1, num_lines, default_ans1);

          % Input for second complex number
          prompt2 = {'Enter real part of second complex number:', 'Enter imaginary part of second complex number:'};
          dlg_title2 = 'Second Complex Number (Divisor)';

          complex_B = inputdlg(prompt2, dlg_title2, num_lines, default_ans1);

          % Validate and process inputs
          if ~isempty(complex_A) && ~isempty(complex_B)
              try
                  % Convert inputs to numeric values
                  real_A = str2double(complex_A{1});
                  imag_A = str2double(complex_A{2});
                  real_B = str2double(complex_B{1});
                  imag_B = str2double(complex_B{2});

                  % Create complex numbers
                  A = complex(real_A, imag_A);
                  B = complex(real_B, imag_B);

                  % Check for division by zero
                  if B == 0
                      set(display, 'string', 'Division by Zero');
                      set(result_display, 'string', 'Error: Cannot divide by zero');
                      return;
                  end

                  % Perform division
                  result = A / B;

                  % Display result
                  result_str = sprintf('%.4f + %.4fi', real(result), imag(result));
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Complex Division Result');

              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', 'Error in Complex Division');
                  warning(ME.message);
              end
          end

      case 'Complex Conj'
          % Input for complex number
          prompt = {'Enter real part of complex number:', 'Enter imaginary part of complex number:'};
          dlg_title = 'Complex Number'; num_lines = 1;
          default_ans = {'0', '0'};

          complex_num = inputdlg(prompt, dlg_title, num_lines, default_ans);

          % Validate and process input
          if ~isempty(complex_num)
              try
                  % Convert inputs to numeric values
                  real_part = str2double(complex_num{1});
                  imag_part = str2double(complex_num{2});

                  % Create complex number
                  A = complex(real_part, imag_part);

                  % Calculate complex conjugate
                  result = conj(A);

                  % Display result
                  result_str = sprintf('%.4f + %.4fi', real(result), imag(result));
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Complex Conjugate Result');

              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', 'Error in Complex Conjugate');
                  warning(ME.message);
              end
          end

      case 'Complex Abs'
          % Input for complex number
          prompt = {'Enter real part of complex number:', 'Enter imaginary part of complex number:'};
          dlg_title = 'Complex Number';
          num_lines = 1;
          default_ans = {'0', '0'};

          complex_num = inputdlg(prompt, dlg_title, num_lines, default_ans);

          % Validate and process input
          if ~isempty(complex_num)
              try
                  % Convert inputs to numeric values
                  real_part = str2double(complex_num{1});
                  imag_part = str2double(complex_num{2});

                  % Create complex number
                  A = complex(real_part, imag_part);

                  % Calculate absolute value
                  result = abs(A);

                  % Display result
                  result_str = sprintf('%.4f', result);
                  set(display, 'string', result_str);
                  set(result_display, 'string', 'Complex Absolute Value Result');

              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', 'Error in Complex Absolute Value');
                  warning(ME.message);
              end
          end

        case 'Mean'
          % Prompt user for input
          input_str = inputdlg('Enter numbers (space or comma-separated):', 'Mean Calculation');

          if ~isempty(input_str)
              try
                  % Parse input and calculate mean
                  data = parse_input_data(input_str{1});
                  result = calculate_mean(data);

                  % Display result
                  set(display, 'string', num2str(result));
                  set(result_display, 'string', 'Mean Result');
              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', ME.message);
              end
          end

        case 'Median'
            % Prompt user for input
            input_str = inputdlg('Enter numbers (space or comma-separated):', 'Median Calculation');

            if ~isempty(input_str)
                try
                    % Parse input and calculate median
                    data = parse_input_data(input_str{1});
                    result = calculate_median(data);

                    % Display result
                    set(display, 'string', num2str(result));
                    set(result_display, 'string', 'Median Result');
                catch ME
                    set(display, 'string', 'Invalid Input');
                    set(result_display, 'string', ME.message);
                end
            end

      case 'Mode'
          % Prompt user for input
          input_str = inputdlg('Enter numbers (space or comma-separated):', 'Mode Calculation');

          if ~isempty(input_str)
              try
                  % Parse input and calculate mode
                  data = parse_input_data(input_str{1});
                  result = calculate_mode(data);

                  % Display result
                  set(display, 'string', num2str(result));
                  set(result_display, 'string', 'Mode Result');
              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', ME.message);
              end
          end

      case 'Std Dev'
          % Prompt user for input
          input_str = inputdlg('Enter numbers (space or comma-separated):', 'Standard Deviation Calculation');

          if ~isempty(input_str)
              try
                  % Parse input and calculate standard deviation
                  data = parse_input_data(input_str{1});
                  result = calculate_std_dev(data);

                  % Display result
                  set(display, 'string', num2str(result));
                  set(result_display, 'string', 'Standard Deviation Result');
              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', ME.message);
              end
          end

      case 'Variance'
          % Prompt user for input
          input_str = inputdlg('Enter numbers (space or comma-separated):', 'Variance Calculation');

          if ~isempty(input_str)
              try
                  % Parse input and calculate variance
                  data = parse_input_data(input_str{1});
                  result = calculate_variance(data);

                  % Display result
                  set(display, 'string', num2str(result));
                  set(result_display, 'string', 'Variance Result');
              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', ME.message);
              end
          end

      case 'Range'
          % Prompt user for input
          input_str = inputdlg('Enter numbers (space or comma-separated):', 'Range Calculation');

          if ~isempty(input_str)
              try
                  % Parse input and calculate range
                  data = parse_input_data(input_str{1});
                  result = calculate_range(data);

                  % Display result
                  set(display, 'string', num2str(result));
                  set(result_display, 'string', 'Range Result');
              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', ME.message);
              end
          end

      case 'Quartiles'
          % Prompt user for input
          input_str = inputdlg('Enter numbers (space or comma-separated):', 'Quartile Calculation');

          if ~isempty(input_str)
              try
                  % Prompt for which quartile
                  quartile_str = inputdlg('Enter quartile number (1, 2, or 3):', 'Quartile Selection');

                  if ~isempty(quartile_str)
                      % Convert quartile to numeric
                      q = str2double(quartile_str{1});

                      % Parse input and calculate quartile
                      data = parse_input_data(input_str{1});
                      result = calculate_quartile(data, q);

                      % Display result
                      set(display, 'string', num2str(result));
                      set(result_display, 'string', ['Q', num2str(q), ' Result']);
                  end
              catch ME
                  set(display, 'string', 'Invalid Input');
                  set(result_display, 'string', ME.message);
              end
          end

        otherwise
            % Handle other cases or do nothing
            disp(['Unhandled button: ', btn_text]);
    end
end

% Keyboard Input Handler
function keyboard_input(src, event, display)
    global memory_value;
    key = event.Key;
    current_val = get(display, 'string');

    % memory operation key handlers
    switch key
        case 'm+'  % Memory Add
            try
                current_num = str2double(current_val);
                if ~isnan(current_num)
                    memory_value = memory_value + current_num;
                    set(display, 'string', ['Memory: ' num2str(memory_value)]);
                end
            catch
                set(display, 'string', 'Error');
            end
            return;

        case 'm-'  % Memory Subtract
            try
                current_num = str2double(current_val);
                if ~isnan(current_num)
                    memory_value = memory_value - current_num;
                    set(display, 'string', ['Memory: ' num2str(memory_value)]);
                end
            catch
                set(display, 'string', 'Error');
            end
            return;

        case 'mr'  % Memory Recall
            set(display, 'string', [current_val, num2str(memory_value)]);
            return;

        case 'mc'  % Memory Clear
            memory_value = 0;
            set(display, 'string', 'Memory cleared');
            return;
    end

    numeric_keys = {'0','1','2','3','4','5','6','7','8','9','.','+','-','*','/','^','(',')'};

    if any(strcmp(key, numeric_keys))
        % Replace special keys
        switch key
            case '*'
                key = '×';
            case '/'
                key = '÷';
        end
        set(display, 'string', [current_val, key]);
    elseif strcmp(key, 'return')
        try
            result = eval(current_val);
            set(display, 'string', num2str(result));
        catch
            set(display, 'string', 'Error');
        end
    elseif strcmp(key, 'backspace')
        % Handle backspace
        if ~isempty(current_val)
            set(display, 'string', current_val(1:end-1));
        end
    elseif strcmp(key, 'escape')
        % Clear the display for 'Escape' key
        set(display, 'string', '');
    elseif strcmp(key, 'delete')
        % Clear all for 'Delete' key
        set(display, 'string', '');
    else
        % Log unhandled keys for debugging
        disp(['Unhandled key: ', key]);
    end
end

% Run the Calculator
scientific_calculator()
