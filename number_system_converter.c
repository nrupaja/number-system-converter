/* 
Title: 		Number System Converter in C
Description: 	This program takes an input from the user in the form of (Number, Current Base, Base it needs be converted in) and displays the output accordingly.
Date: 		05/15/2022
*/

#include <stdio.h>
#include <stdlib.h>

int n = 1000;
// int checker = 0;

// Converts a character digit into an integer digit
int charToInt(char digit) {
  
  if (digit >= '0' && digit <= '9') {
    return digit - '0';
  } else if (digit >= 'A' && digit <= 'Z') {
    return digit - 'A' + 10;
  } else if (digit >= 'a' && digit <= 'z') {
    return digit - 'a' + 10;
  } else{
    printf("Invalid Input\n");
    abort();
  }
}

// Converts an integer digit into a character digit
char intToChar(int digit) {
  if (digit > 9) {
    return (digit - 10) + 'A';
  } else {
    return digit + '0';
  }
}

//Power function
double powerRelation(double base, int exponent) {
  double result = 1;
  if (exponent < 0) {
    base = 1.0 / base;
    exponent = exponent * -1;
  }
  for (int i=0; i<exponent; i++) {
    result = result * base;
  }
  return result;
}

//This function checks the power relation between the current base of the number entered and the base it has to be converted to.
int powerRelationChecker(int base1, int base2, int *power1, int *power2) {
  int power = 2;
  while (power <= base1 && power <= base2) {
    for (int i=1; powerRelation(power, i) <= base1; i++) {
      if (powerRelation(power, i) == base1) {
        *power1 = i;
      }
    }
    if (*power1 != 0) {
      for (int i=1; powerRelation(power, i) <= base2; i++) {
        if (powerRelation(power, i) == base2) {
          *power2 = i;
        }
      }
      if (*power2 != 0) {
        return power;
      }
    }
    power++;
  }
  return 0;
}

//Using division by the base number, this function prints out the decimal to any base conversion by filling the convertedAr with each remainder.
void decConverter(double number, int base, int floatingPointNumber) {
  if (floatingPointNumber == 1) {
    number = number * powerRelation(base, 8);
  }
  long long a = number;
  int c = base, b = 0;
  char convertedAr[n];
  convertedAr[n-1] = 0;

  if (a == 0) {
    printf("0");
  } else {
    int i;
    for (i=n-2; a>0; i--) {
      b = a % c;
      convertedAr[i] = intToChar(b);
      a = a / c;
    }

    if (floatingPointNumber == 1) {
      for (int j=n-1; j>n-9; j--) {
        convertedAr[j] = convertedAr[j - 1];
      }
      convertedAr[n-9] = '.';
    }
    printf("Result: %s\n", &convertedAr[i + 1]);
  }
}

//Converts binary to any power of itself (ex: 2->8 / 2->16).
void rootToPower(char *originalAr, char *convertedAr, int power, int convertedPower, int nDec) {
  int i = 0, currentIndex = 0;
  int a = nDec % convertedPower;
  if (a != 0) {
    a = convertedPower - a;
  }
  while (originalAr[i] != 0) {
    int tempNum = 0;
    if (originalAr[i] == '.') {
      convertedAr[currentIndex] = '.';
      currentIndex++;
      i++;
      continue;
    }
    while (a<convertedPower && originalAr[i]!=0) {
      tempNum += (charToInt(originalAr[i]) *
                  powerRelation(power, convertedPower - a - 1));
      a++;
      i++;
    }
    convertedAr[currentIndex] = intToChar(tempNum);
    currentIndex++;
    a = 0;
  }
  convertedAr[currentIndex] = 0;
}

//Converts any power of a base system to itself (ex: 16->2, 8->2)
void powerToRoot(char *originalAr, char *convertedAr, int power, int originalPower) {
  int a, b = 0, c = power;
  int j, total = 0;
  for (int i = 0; originalAr[i] != 0; i++) {
    if (originalAr[i] == '.') {
      convertedAr[total] = '.';
      total = total + 1;
      continue;
    }
    a = charToInt(originalAr[i]);
    for (j=originalPower-1; j>=0; j--) {
      b = a % c;
      convertedAr[total + j] = b + '0';
      a = a / c;
    }
    total = total + originalPower;
  }
  convertedAr[total] = 0;
}

//This function accounts for the floating point  
double floatingPoint(char *originalAr, int base, int decimal) {
  double number = 0;
  for (int i=0; i<decimal; i++) {
    number = number + (charToInt(originalAr[i]) * powerRelation(base, decimal - i - 1));
  }
  if (originalAr[decimal] == '.') {
    for (int i=decimal+1; originalAr[i]!=0; i++) {
      number = number + (charToInt(originalAr[i]) * powerRelation(base, decimal - i));
    }
  }
  return number;
}

// void twosComplement(char number){
// 	int i, carry = 1;
//  char num[n+1], one[n+1], two[n+1];
// 	for(i=n-1; i>= 0; i--){
// 		if(one[i] == '1' && carry == 1){
//       two[i] = '0';
//    	}
//    	else if(one[i] == '0' && carry == 1){
//       two[i] = '1';
//       carry = 0;
//    	} else {
//       two[i] = one[i];
//    	}
// 	}
// 	two[n] = '\0';
// }

int continousRun(char * again) {
  if (again[0] == '1') {
    return 1;
  } else if (again[0] == '2') {
    return 2;
  } else if (again[0] == '3') {
    return 0;
	} else {
		return 3;
  }
}

int main(void) {
  // Declaring variables
  char originalAr[n], convertedAr[n], again[n];;
  int originalBase, convertedBase, power, originalPower, convertedPower, againInp;
  double number;

  printf("====================================\n");
  printf("NUMBER SYSTEM CONVERTER\n");
  printf("====================================\n");

	do {
	  // Taking input in a character array
	  printf("\nEnter a number to convert: ");
	  scanf("%s", originalAr);
	
	  // Here the program checks if the input contains any floating point or not.
	  int decimal = 0, floatingPointNumber = 0;
	  int nDec = 0;
	  for (int i = 0; i < n; i++) {
	    if (originalAr[i] == '.') {
	      decimal = i;
	      floatingPointNumber = 1;
	      break;
	    } else if (originalAr[i] == 0) {
	      decimal = i;
	      break;
	    } else {
	      nDec++;
	    }
	  }
	
	  // Taking input base of the number inputed
	  printf("Base of the number entered: ");
	  scanf("%d", &originalBase);
		do {	
		  do {
		    // Taking input for base to convert to
		    printf("Base to convert the number to: ");
		    scanf("%d", &convertedBase);
		    if (convertedBase == originalBase) {
		      printf("Same Base\n\n");
		    }
		  } while (convertedBase == originalBase);
		
		  power = powerRelationChecker(originalBase, convertedBase, &originalPower, &convertedPower);
		
		  printf("\n------------------------------------\n");
		
		  printf("\nConversion of %s from base %d to base %d:-\n", originalAr,
		         originalBase, convertedBase);
		  //Base 2 to 16 and 8 to 16 and 16 to 10
		  if (convertedBase == 10) {
		    printf("Result: %lf\n",
		           floatingPoint(originalAr, originalBase, decimal));
		    //Base 16 to 2 and 16 to 8 and 10 to 16
		  } else if (originalBase == 10) {
		    number = floatingPoint(originalAr, originalBase, decimal);
		    decConverter(number, convertedBase, floatingPointNumber);
		  } else if (power != 0) {
		    // Base to 2 to 16 and 2 to 8
		    if (originalBase == power) {
		      rootToPower(originalAr, convertedAr, power, convertedPower, nDec);
		      printf("Result: %s\n", convertedAr);
		      //Base 16 to 2 and 8 to 2
		    } else if (convertedBase == power) {
		      powerToRoot(originalAr, convertedAr, power, originalPower);
		      printf("Result: %s\n", convertedAr);
		      //Base 8 to 2 and 8 to 16
		    } else {
		      powerToRoot(originalAr, convertedAr, power, originalPower);
		      char extraArray[n];
		      rootToPower(convertedAr, extraArray, power, convertedPower, nDec);
		      printf("Result: %s\n", extraArray);
		    }
		  } else {
		    number = floatingPoint(originalAr, originalBase, decimal);
		    decConverter(number, convertedBase, floatingPointNumber);
		  }
		  // Repeat Program
		  do {
		  	printf("\n------------------------------------\n\n");
		        printf("Choose (1 = Run Again | 2 = Convert the same number to another base | 3 = Exit): ");
			scanf("%s", again);
		      againInp = continousRun(again);
		  } while (againInp == 3);
	  } while (againInp == 2);
	} while (againInp == 1);
}
