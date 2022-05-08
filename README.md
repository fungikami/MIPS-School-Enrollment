# CI3815 Project I: School Enrollment in MIPS Assembly

Design and implementation of a registration system for subjects taught by an educational institution.

## How to get it to work

+ Download MARS MIPS SImulator and open it (it Linux this can be done opening the terminal in the folder containing the .jar file and typing
```
> java -jar Mars4_4.jar
```

+ Go to Settings/Exception Handler, mark "Include this exception handler file in all assemble operation", then click "Browse" and select `myexception.s`.
+ Modify the test cases in .data of `myexception.s`
+ Go to File/Open and click `Main.s`. Assemble and run.
+ See the results in the new .txt files :).

## File format 

The files containing the enrollment information for each student have the following format:

+ ***Student File***:
  - Student ID: 8 characters. Fixed size.
  - Name: Maximum 20 characters. It will be in double quotes.
  - Grade: 6 Characters. Rounded to 4 decimal places. Fixed size.
  - Approved credits: 3 characters. Fixed size.
  
+ ***Subject File***:
  - Code: 7 characters. Fixed size.
  - Name: Maximum 30 characters. It will be in double quotes.
  - Number of credits: 1 character. Fixed size.
  - Quota: 3 characters. Fixed size.
  - Minimum number of approved credits: 3 characters. Fixed size.

+ ***Enrollment File***:
  - Student ID: 8 characters. Fixed size.
  - Subject Code: 7 characters. Fixed size.

+ ***Enrollment Correction File***:
  - Student ID: 8 characters. Fixed size.
  - Subject Code: 7 characters. Fixed size.
  - Operation: 1 character. Possible values: I (Inclusion) or E (Elimination).

The program overwrites the following files:

+ ***Tentative and definitive enrollments***:
  - First line of each subject:
    Subject Code: 7 characters.
    Name: Maximum 30 characters.
    Number of free Quotas: 3 characters.
  - Rest of the lines (registered students):
    Student Card:
    Name: Maximum 20 characters.
    Correction (if there is any): Inclusion in Correction (I) or Elimination in Correction (E).

## Considerations

+ In the registration application process: all applications are accepted. This criterion does not consider quota limits.
+ In the correction process:
  - In the case of eliminations: All must be accepted.
  - In the case of registration: Priority is given to students with the lowest number of approved credits.

---

Made with ❤ by [chrischriscris](https://github.com/chrischriscris/) and [fungikami](https://github.com/fungikami/).
