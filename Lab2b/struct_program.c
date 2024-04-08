#include <stdio.h>

// Define a structure for student
struct Student {
    char name[50];
    int id;
    int age;
};

int main() {
    // Declare a variable of type struct Student
    struct Student student1;

    // Input student information
    printf("Enter student name: ");
    scanf("%s", student1.name); // Assuming name doesn't contain whitespace
    printf("Enter student ID: ");
    scanf("%d", &student1.id);
    printf("Enter student age: ");
    scanf("%d", &student1.age);

    // Print student information
    printf("\nStudent Information\n");
    printf("Name: %s\n", student1.name);
    printf("ID: %d\n", student1.id);
    printf("Age: %d\n", student1.age);

    return 0;
}

