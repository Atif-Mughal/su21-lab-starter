#include <stdio.h>

// Define a static inline function to return an integer value
static inline int add(int a, int b) {
    return a + b;
}

int main() {
    int result;

    // Call the static inline function
    result = add(5, 7);

    // Print the result
    printf("The result of adding 5 and 7 is: %d\n", result);

    return 0;
}

