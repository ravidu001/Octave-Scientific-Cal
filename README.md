# Octave-Scientific-Cal

Scientific Calculator
==============================

Overview:
---------
This Octave-based scientific calculator provides a comprehensive range of 
mathematical operations with an intuitive graphical user interface.

System Requirements:
-------------------
- GNU Octave 5.2 or later
- Octave GUI
- Additional Octave Packages:
  - Control Package
  - Signal Package (recommended)

Compatibility:
--------------
- Tested on Octave GUI
- Works best with latest Octave versions
- Compatible with most Linux, Windows, and macOS distributions

Features:
---------
1. Basic Arithmetic Operations
   - Addition, Subtraction, Multiplication, Division
   - Parentheses and Percentage calculations
   - Exponentiation and Root calculations

2. Memory Functions
   - M+ (Memory Add)
   - M- (Memory Subtract)
   - MR (Memory Recall)
   - MC (Memory Clear)

3. Scientific Functions
   - Trigonometric functions (sin, cos, tan)
   - Inverse trigonometric functions
   - Logarithmic functions (log, ln)
   - Exponential functions
   - Factorial
   - Square and Nth Root calculations

4. Constants
   - π (Pi)
   - e (Euler's number)

5. Matrix Operations
   - Matrix Addition
   - Matrix Subtraction
   - Matrix Multiplication
   - Matrix Transpose
   - Matrix Inversion

6. Complex Number Operations
   - Complex Addition
   - Complex Subtraction
   - Complex Multiplication
   - Complex Division
   - Complex Conjugate

7. Statistical Functions
   - Mean
   - Median
   - Mode
   - Standard Deviation
   - Variance
   - Range
   - Quartile Calculations

8. User Interface
   - Dark and Light Mode
   - Angle Mode (Degrees/Radians)
   - Keyboard Input Support
   - Error Handling

Installation Instructions:
-------------------------
1. Ensure Octave is installed on your system
2. Install required Octave packages:
   pkg install -forge control
   pkg install -forge signal

How to Run:
-----------
1. Open Octave GUI
2. Navigate to the directory containing the calculator script
3. Run the script by typing 'scientific_calculator' in the command window
4. Use mouse clicks or keyboard input to perform calculations

Keyboard Shortcuts:
------------------
- Numeric Keys (0-9): Input numbers
- Operators (+, -, *, /): Perform calculations
- Return/Enter: Evaluate expression
- Backspace: Delete last character
- Escape/Delete: Clear display

Troubleshooting:
----------------
- Ensure all Octave packages are installed
- Update to the latest Octave version
- Restart Octave GUI if unexpected errors occur

Common Package Installation Issues:
-----------------------------------
If package installation fails:
1. Ensure you have internet connection
2. Check Octave package repository settings
3. Use 'pkg rebuild' command if needed
4. Verify package compatibility with your Octave version

Performance Tips:
-----------------
- Close unnecessary applications
- Use latest Octave version
- Ensure sufficient system memory

Known Limitations:
-----------------
- Precision may vary from MATLAB
- Some advanced mathematical operations might have constraints
- Performance depends on system specifications

Developed for Octave Users
Version: 1.0
Compatibility: Octave 5.2+

Enjoy calculating!